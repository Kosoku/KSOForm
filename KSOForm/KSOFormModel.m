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

#import "KSOFormModel.h"
#import "KSOFormSection.h"
#import "KSOFormSection+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOFormModel ()
@property (readwrite,copy,nonatomic) NSMutableArray<KSOFormSection *> *sections;
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
    [[self mutableArrayValueForKey:@kstKeypath(self,sections)] addObjectsFromArray:sections];
}

- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary; {
    [self addSection:[[KSOFormSection alloc] initWithDictionary:dictionary model:self]];
}
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries; {
    [self addSections:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormSection alloc] initWithDictionary:object model:self];
    }]];
}
#pragma mark Properties
- (NSArray<KSOFormSection *> *)sections {
    return [_sections copy];
}
#pragma mark *** Private Methods ***
#pragma mark KVC
- (void)insertObject:(KSOFormSection *)object inSectionsAtIndex:(NSUInteger)index {
    [_sections insertObject:object atIndex:index];
    
    [object setModel:self];
}
- (void)removeObjectFromSectionsAtIndex:(NSUInteger)index {
    [_sections removeObjectAtIndex:index];
}
- (void)insertSections:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [_sections insertObjects:array atIndexes:indexes];
    
    for (KSOFormSection *section in array) {
        [section setModel:self];
    }
}
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes {
    [_sections removeObjectsAtIndexes:indexes];
}
- (void)replaceObjectInSectionsAtIndex:(NSUInteger)index withObject:(KSOFormSection *)object {
    [_sections replaceObjectAtIndex:index withObject:object];
}

@end
