//
//  KSOFormModel.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormSection+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormRowView.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

KSOFormModelKey const KSOFormModelKeyTitle = @"title";
KSOFormModelKey const KSOFormModelKeyTitleView = @"titleView";
KSOFormModelKey const KSOFormModelKeyLeftBarButtonItems = @"leftBarButtonItems";
KSOFormModelKey const KSOFormModelKeyRightBarButtonItems = @"rightBarButtonItems";
KSOFormModelKey const KSOFormModelKeyBackgroundView = @"backgroundView";
KSOFormModelKey const KSOFormModelKeyHeaderView = @"headerView";
KSOFormModelKey const KSOFormModelKeyFooterView = @"footerView";
KSOFormModelKey const KSOFormModelKeySections = @"sections";
KSOFormModelKey const KSOFormModelKeyRows = @"rows";
KSOFormModelKey const KSOFormModelKeyDidAppearBlock = @"didAppearBlock";

@interface KSOFormModel ()
@property (readwrite,copy,nonatomic) NSMutableArray<KSOFormSection *> *sections;
@property (weak,nonatomic) KSOFormRow *parentFormRow;

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
    
    _title = dictionary[KSOFormModelKeyTitle];
    _titleView = dictionary[KSOFormModelKeyTitleView];
    _leftBarButtonItems = dictionary[KSOFormModelKeyLeftBarButtonItems];
    _rightBarButtonItems = dictionary[KSOFormModelKeyRightBarButtonItems];
    _backgroundView = dictionary[KSOFormModelKeyBackgroundView];
    _headerView = dictionary[KSOFormModelKeyHeaderView];
    _footerView = dictionary[KSOFormModelKeyFooterView];
    _didAppearBlock = dictionary[KSOFormModelKeyDidAppearBlock];
    _sections = [[NSMutableArray alloc] init];
    
    if (dictionary[KSOFormModelKeySections] != nil) {
        for (id section in dictionary[KSOFormModelKeySections]) {
            if ([section isKindOfClass:NSDictionary.class]) {
                [self addSectionFromDictionary:section];
            }
            else if ([section isKindOfClass:KSOFormSection.class]) {
                [self addSection:section];
            }
        }
    }
    else if (dictionary[KSOFormModelKeyRows] != nil) {
        [self addSection:[[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyRows: dictionary[KSOFormModelKeyRows]}]];
    }
    
    return self;
}

+ (instancetype)formModelWithDictionary:(NSDictionary<KSOFormModelKey,id> *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (KSOFormSection *)sectionForIdentifier:(NSString *)identifier {
    return [self sectionsForIdentifiers:@[identifier]].firstObject;
}
- (NSArray<KSOFormSection *> *)sectionsForIdentifiers:(NSArray<NSString *> *)identifiers; {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (KSOFormSection *section in self.sections) {
        if ([identifiers containsObject:section.identifier]) {
            [retval addObject:section];
        }
    }
    
    return [retval copy];
}
- (KSOFormRow *)rowForIdentifier:(NSString *)identifier {
    return [self rowsForIdentifiers:@[identifier]].firstObject;
}
- (NSArray<KSOFormRow *> *)rowsForIdentifiers:(NSArray<NSString *> *)identifiers; {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (KSOFormSection *section in self.sections) {
        for (KSOFormRow *row in section.rows) {
            if ([identifiers containsObject:row.identifier]) {
                [retval addObject:row];
            }
            if (row.actionModel != nil) {
                [retval addObjectsFromArray:[row.actionModel rowsForIdentifiers:identifiers]];
            }
        }
    }
    
    return [retval copy];
}

- (KSOFormRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count < indexPath.section ||
        self.sections[indexPath.section].rows.count < indexPath.row) {
        
        return nil;
    }
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

- (void)beginEditingRow:(KSOFormRow *)row; {
    if (!row.isEditable) {
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathForRow:row];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    UITableViewCell<KSOFormRowView> *cell = (UITableViewCell<KSOFormRowView> *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(beginEditingFormRow)]) {
        [cell beginEditingFormRow];
    }
}

- (void)performUpdates:(NS_NOESCAPE dispatch_block_t)updates {
    [self.tableView beginUpdates];
    
    updates();
    
    [self.tableView endUpdates];
}

- (void)reloadSection:(KSOFormSection *)section; {
    [self reloadSections:@[section]];
}
- (void)reloadSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation; {
    [self reloadSections:@[section] animation:animation];
}
- (void)reloadSections:(NSArray<KSOFormSection *> *)sections; {
    [self reloadSections:sections animation:UITableViewRowAnimationNone];
}
- (void)reloadSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation; {
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    
    for (KSOFormSection *section in sections) {
        [indexes addIndex:[_sections indexOfObject:section]];
    }
    
    [self.tableView reloadSections:indexes withRowAnimation:animation];
}

- (void)addSection:(KSOFormSection *)section {
    [self addSections:@[section]];
}
- (void)addSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation; {
    [self addSections:@[section] animation:animation];
}
- (void)addSections:(NSArray<KSOFormSection *> *)sections; {
    [self insertSections:sections atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_sections.count, sections.count)]];
}
- (void)addSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation; {
    [self insertSections:sections atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_sections.count, sections.count)] animation:animation];
}

- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary; {
    [self addSection:[[KSOFormSection alloc] initWithDictionary:dictionary]];
}
- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary animation:(UITableViewRowAnimation)animation; {
    [self addSection:[[KSOFormSection alloc] initWithDictionary:dictionary] animation:animation];
}
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries; {
    [self addSections:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormSection alloc] initWithDictionary:object];
    }]];
}
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries animation:(UITableViewRowAnimation)animation; {
    [self addSections:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormSection alloc] initWithDictionary:object];
    }] animation:animation];
}

- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index; {
    [self insertSections:@[section] atIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation; {
    [self insertSections:@[section] atIndexes:[NSIndexSet indexSetWithIndex:index] animation:animation];
}
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes; {
    [self insertSections:sections atIndexes:indexes animation:UITableViewRowAnimationNone];
}
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation; {
    [_sections insertObjects:sections atIndexes:indexes];
    
    for (KSOFormSection *section in sections) {
        [section setModel:self];
    }
    
    [self.tableView insertSections:indexes withRowAnimation:animation];
}

- (void)removeSection:(KSOFormSection *)section; {
    [self removeSections:@[section]];
}
- (void)removeSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation; {
    [self removeSections:@[section] animation:animation];
}
- (void)removeSections:(NSArray<KSOFormSection *> *)sections; {
    [self removeSections:sections animation:UITableViewRowAnimationNone];
}
- (void)removeSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation; {
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    
    for (KSOFormSection *section in sections) {
        [indexes addIndex:[_sections indexOfObject:section]];
        [section setModel:nil];
    }
    
    [_sections removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteSections:indexes withRowAnimation:animation];
}

- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection {
    [self replaceSection:oldSection withSection:newSection animation:UITableViewRowAnimationNone];
}
- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection animation:(UITableViewRowAnimation)animation; {
    NSUInteger index = [_sections indexOfObject:oldSection];
    
    [_sections replaceObjectAtIndex:index withObject:newSection];
    
    [oldSection setModel:nil];
    [newSection setModel:self];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
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
- (KSOFormSection *)objectAtIndexedSubscript:(NSUInteger)index {
    return self.sections[index];
}
- (void)setObject:(KSOFormSection *)obj atIndexedSubscript:(NSUInteger)index {
    [self replaceSection:self.sections[index] withSection:obj];
}
@end
