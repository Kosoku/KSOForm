//
//  KSOFormModel.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormSection+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

KSOFormModelKey const KSOFormModelKeyTitle = @"title";
KSOFormModelKey const KSOFormModelKeyBackgroundView = @"backgroundView";
KSOFormModelKey const KSOFormModelKeyHeaderView = @"headerView";
KSOFormModelKey const KSOFormModelKeyFooterView = @"footerView";
KSOFormModelKey const KSOFormModelKeyCellIdentifiersToCellNibs = @"cellIdentifiersToCellNibs";
KSOFormModelKey const KSOFormModelKeyHeaderFooterViewIdentifiersToHeaderFooterViewNibs = @"headerFooterViewIdentifiersToHeaderFooterViewNibs";
KSOFormModelKey const KSOFormModelKeySections = @"sections";
KSOFormModelKey const KSOFormModelKeyRows = @"rows";

@interface KSOFormModel ()
@property (readwrite,copy,nonatomic) NSMutableArray<KSOFormSection *> *sections;
@property (weak,nonatomic) UITableView *tableView;
@end

@implementation KSOFormModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> title=%@ sections=%@",NSStringFromClass(self.class),self,self.title,self.sections];
}

- (instancetype)init {
    return [self initWithDictionary:nil];
}
- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary {
    if (!(self = [super init]))
        return nil;
    
    _cellIdentifiersToCellNibs = dictionary[KSOFormModelKeyCellIdentifiersToCellNibs];
    _headerFooterViewIdentifiersToHeaderFooterViewNibs = dictionary[KSOFormModelKeyHeaderFooterViewIdentifiersToHeaderFooterViewNibs];
    _title = dictionary[KSOFormModelKeyTitle];
    _backgroundView = dictionary[KSOFormModelKeyBackgroundView];
    _headerView = dictionary[KSOFormModelKeyHeaderView];
    _footerView = dictionary[KSOFormModelKeyFooterView];
    _sections = [[NSMutableArray alloc] init];
    
    if (dictionary[KSOFormModelKeySections] != nil) {
        [_sections addObjectsFromArray:[dictionary[KSOFormModelKeySections] KQS_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
            return [[KSOFormSection alloc] initWithDictionary:object model:self];
        }]];
    }
    else if (dictionary[KSOFormModelKeyRows] != nil) {
        [_sections addObject:[[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyRows: dictionary[KSOFormModelKeyRows]} model:self]];
    }
    
    return self;
}

- (KSOFormRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section].rows[indexPath.row];
}
- (NSIndexPath *)indexPathForRow:(KSOFormRow *)formRow {
    NSIndexPath *retval = nil;
    
    for (NSUInteger i=0; i<self.sections.count; i++) {
        for (NSUInteger j=0; j<self.sections[i].rows.count; j++) {
            if ([formRow isEqual:self.sections[i].rows[j]]) {
                retval = [NSIndexPath indexPathForRow:j inSection:i];
                break;
            }
        }
        
        if (retval != nil) {
            break;
        }
    }
    
    return retval;
}

- (void)addSection:(KSOFormSection *)section {
    [self addSections:@[section]];
}
- (void)addSections:(NSArray<KSOFormSection *> *)sections; {
    [self insertSections:sections atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_sections.count, sections.count)]];
}

- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary; {
    [self addSection:[[KSOFormSection alloc] initWithDictionary:dictionary model:self]];
}
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries; {
    [self addSections:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormSection alloc] initWithDictionary:object model:self];
    }]];
}

- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index; {
    [self insertSections:@[section] atIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes; {
    [self.tableView beginUpdates];
    
    [_sections insertObjects:sections atIndexes:indexes];

    for (KSOFormSection *section in sections) {
        [section setModel:self];
    }
    
    [self.tableView insertSections:indexes withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
}

- (void)removeSection:(KSOFormSection *)section; {
    [self removeSections:@[section]];
}
- (void)removeSections:(NSArray<KSOFormSection *> *)sections; {
    [self.tableView beginUpdates];
    
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    
    for (KSOFormSection *section in sections) {
        [indexes addIndex:[_sections indexOfObject:section]];
        [section setModel:nil];
    }
    
    [_sections removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection {
    [self.tableView beginUpdates];
    
    NSUInteger index = [_sections indexOfObject:oldSection];
    
    [_sections replaceObjectAtIndex:index withObject:newSection];
    
    [oldSection setModel:nil];
    [newSection setModel:self];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}
#pragma mark Properties
- (NSArray<KSOFormSection *> *)sections {
    return [_sections copy];
}

@end

@implementation KSOFormModel (KSOFormModelKeyedSubscripting)
- (id)objectForKeyedSubscript:(KSOFormModelKey)key {
    return [self valueForKey:key];
}
- (void)setObject:(id)obj forKeyedSubscript:(KSOFormModelKey)key {
    [self setValue:obj forKey:key];
}
@end

@implementation KSOFormModel (KSOFormModelIndexedSubscripting)
- (KSOFormSection *)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.sections[idx];
}
- (void)setObject:(KSOFormSection *)obj atIndexedSubscript:(NSUInteger)idx {
    [self replaceSection:self.sections[idx] withSection:obj];
}
@end
