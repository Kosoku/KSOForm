//
//  KSOFormSection.m
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

#import "KSOFormSection.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormModel+KSOExtensionsPrivate.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

KSOFormSectionKey const KSOFormSectionKeyRows = @"rows";
KSOFormSectionKey const KSOFormSectionKeyHeaderTitle = @"headerTitle";
KSOFormSectionKey const KSOFormSectionKeyFooterTitle = @"footerTitle";
KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle = @"headerAttributedTitle";
KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle = @"footerAttributedTitle";
KSOFormSectionKey const KSOFormSectionKeyHeaderViewClass = @"headerViewClass";
KSOFormSectionKey const KSOFormSectionKeyFooterViewClass = @"footerViewClass";
KSOFormSectionKey const KSOFormSectionKeyHeaderViewIdentifier = @"headerViewIdentifier";
KSOFormSectionKey const KSOFormSectionKeyFooterViewIdentifier = @"footerViewIdentifier";

@interface KSOFormSection ()
@property (readwrite,weak,nonatomic) KSOFormModel *model;
@property (readwrite,copy,nonatomic) NSString *identifier;
@property (readwrite,copy,nonatomic) NSMutableArray<KSOFormRow *> *rows;
@end

@implementation KSOFormSection

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> identifier=%@ headerTitle=%@ footerTitle=%@ rows=%@",NSStringFromClass(self.class),self,self.identifier,self.headerTitle,self.footerTitle,self.rows];
}

- (instancetype)init {
    return [self initWithDictionary:nil model:nil];
}
- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary model:(KSOFormModel *)model {
    if (!(self = [super init]))
        return nil;
    
    _model = model;
    _identifier = [[NSUUID UUID] UUIDString];
    _headerTitle = dictionary[KSOFormSectionKeyHeaderTitle];
    _footerTitle = dictionary[KSOFormSectionKeyFooterTitle];
    _headerAttributedTitle = dictionary[KSOFormSectionKeyHeaderAttributedTitle];
    _footerAttributedTitle = dictionary[KSOFormSectionKeyFooterAttributedTitle];
    _headerViewClass = dictionary[KSOFormSectionKeyHeaderViewClass];
    _footerViewClass = dictionary[KSOFormSectionKeyFooterViewClass];
    _headerViewIdentifier = dictionary[KSOFormSectionKeyHeaderViewIdentifier];
    _footerViewIdentifier = dictionary[KSOFormSectionKeyFooterViewIdentifier];
    _rows = [[NSMutableArray alloc] init];
    
    [_rows addObjectsFromArray:[(NSArray *)dictionary[KSOFormSectionKeyRows] KQS_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
        return [[KSOFormRow alloc] initWithDictionary:object section:self];
    }]];
    
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary {
    return [self initWithDictionary:dictionary model:nil];
}

- (void)addRow:(KSOFormRow *)row {
    [self addRows:@[row]];
}
- (void)addRows:(NSArray<KSOFormRow *> *)rows; {
    [self insertRows:rows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_rows.count, rows.count)]];
}

- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary; {
    [self addRow:[[KSOFormRow alloc] initWithDictionary:dictionary section:self]];
}
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries; {
    [self addRows:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormRow alloc] initWithDictionary:object section:self];
    }]];
}

- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index; {
    [self insertRows:@[row] atIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes; {
    [self.model.tableView beginUpdates];
    
    NSInteger section = [self.model.sections indexOfObject:self];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    [_rows insertObjects:rows atIndexes:indexes];
    
    for (KSOFormRow *row in rows) {
        [row setSection:self];
    }
    
    [self.model.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    [self.model.tableView endUpdates];
}

- (void)removeRow:(KSOFormRow *)row; {
    [self removeRows:@[row]];
}
- (void)removeRows:(NSArray<KSOFormRow *> *)rows; {
    [self.model.tableView beginUpdates];
    
    NSInteger section = [self.model.sections indexOfObject:self];
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (KSOFormRow *row in rows) {
        NSInteger index = [_rows indexOfObject:row];
        
        [indexes addIndex:index];
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:section]];
        [row setSection:nil];
    }
    
    [_rows removeObjectsAtIndexes:indexes];
    
    [self.model.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self.model.tableView endUpdates];
}

- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow; {
    [self.model.tableView beginUpdates];
    
    NSUInteger index = [_rows indexOfObject:oldRow];
    
    [_rows replaceObjectAtIndex:index withObject:newRow];
    
    [oldRow setSection:nil];
    [newRow setSection:self];
    
    [self.model.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.model.tableView endUpdates];
}
#pragma mark Properties
- (BOOL)wantsHeaderView {
    return (self.headerTitle != nil ||
            self.headerAttributedTitle != nil);
}
- (BOOL)wantsFooterView {
    return (self.footerTitle != nil ||
            self.footerAttributedTitle != nil);
}

- (NSArray<KSOFormRow *> *)rows {
    return [_rows copy];
}

@end

@implementation KSOFormSection (KSOFormSectionKeyedSubscripting)
- (id)objectForKeyedSubscript:(KSOFormSectionKey)key; {
    return [self valueForKey:key];
}
- (void)setObject:(id)obj forKeyedSubscript:(KSOFormSectionKey)key; {
    [self setValue:obj forKey:key];
}
@end

@implementation KSOFormSection (KSOFormSectionIndexedSubscripting)
- (KSOFormRow *)objectAtIndexedSubscript:(NSUInteger)idx; {
    return self.rows[idx];
}
- (void)setObject:(KSOFormRow *)obj atIndexedSubscript:(NSUInteger)idx; {
    
}
@end
