//
//  KSOFormSection.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
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

KSOFormSectionKey const KSOFormSectionKeyIdentifier = @"identifier";
KSOFormSectionKey const KSOFormSectionKeyRows = @"rows";
KSOFormSectionKey const KSOFormSectionKeyHeaderTitle = @"headerTitle";
KSOFormSectionKey const KSOFormSectionKeyFooterTitle = @"footerTitle";
KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle = @"headerAttributedTitle";
KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle = @"footerAttributedTitle";
KSOFormSectionKey const KSOFormSectionKeyHeaderViewClass = @"headerViewClass";
KSOFormSectionKey const KSOFormSectionKeyHeaderViewClassBundle = @"headerViewClassBundle";
KSOFormSectionKey const KSOFormSectionKeyFooterViewClass = @"footerViewClass";
KSOFormSectionKey const KSOFormSectionKeyFooterViewClassBundle = @"footerViewClassBundle";

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
    return [self initWithDictionary:nil];
}
- (instancetype)initWithDictionary:(NSDictionary<KSOFormSectionKey, id> *)dictionary {
    if (!(self = [super init]))
        return nil;
    
    _identifier = dictionary[KSOFormSectionKeyIdentifier] ?: [[NSUUID UUID] UUIDString];
    _headerTitle = dictionary[KSOFormSectionKeyHeaderTitle];
    _footerTitle = dictionary[KSOFormSectionKeyFooterTitle];
    _headerAttributedTitle = dictionary[KSOFormSectionKeyHeaderAttributedTitle];
    _footerAttributedTitle = dictionary[KSOFormSectionKeyFooterAttributedTitle];
    _headerViewClass = dictionary[KSOFormSectionKeyHeaderViewClass];
    _headerViewClassBundle = dictionary[KSOFormSectionKeyHeaderViewClassBundle];
    _footerViewClass = dictionary[KSOFormSectionKeyFooterViewClass];
    _footerViewClassBundle = dictionary[KSOFormSectionKeyFooterViewClassBundle];
    _rows = [[NSMutableArray alloc] init];
    
    for (id row in dictionary[KSOFormSectionKeyRows]) {
        if ([row isKindOfClass:NSDictionary.class]) {
            [self addRowFromDictionary:row];
        }
        else if ([row isKindOfClass:KSOFormRow.class]) {
            [self addRow:row];
        }
    }
    
    return self;
}

+ (instancetype)formSectionWithDictionary:(NSDictionary<KSOFormSectionKey,id> *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (void)performUpdates:(dispatch_block_t)updates {
    [self.model.tableView beginUpdates];
    
    updates();
    
    [self.model.tableView endUpdates];
}

- (void)reloadRow:(KSOFormRow *)row; {
    [self reloadRows:@[row]];
}
- (void)reloadRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation; {
    [self reloadRows:@[row] animation:animation];
}
- (void)reloadRows:(NSArray<KSOFormRow *> *)rows; {
    [self reloadRows:rows animation:UITableViewRowAnimationNone];
}
- (void)reloadRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation; {
    NSUInteger section = [self.model.sections indexOfObject:self];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (KSOFormRow *row in rows) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:[_rows indexOfObject:row] inSection:section]];
    }
    
    [self.model.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)addRow:(KSOFormRow *)row {
    [self addRows:@[row]];
}
- (void)addRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation; {
    [self addRows:@[row] animation:animation];
}
- (void)addRows:(NSArray<KSOFormRow *> *)rows; {
    [self insertRows:rows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_rows.count, rows.count)]];
}
- (void)addRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation; {
    [self insertRows:rows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_rows.count, rows.count)] animation:animation];
}

- (void)addRowFromDictionary:(NSDictionary<KSOFormSectionKey, id> *)dictionary; {
    [self addRow:[[KSOFormRow alloc] initWithDictionary:dictionary]];
}
- (void)addRowFromDictionary:(NSDictionary<KSOFormSectionKey, id> *)dictionary animation:(UITableViewRowAnimation)animation; {
    [self addRow:[[KSOFormRow alloc] initWithDictionary:dictionary] animation:animation];
}
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<KSOFormSectionKey, id> *> *)dictionaries; {
    [self addRows:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormRow alloc] initWithDictionary:object];
    }]];
}
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<KSOFormSectionKey, id> *> *)dictionaries animation:(UITableViewRowAnimation)animation; {
    [self addRows:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormRow alloc] initWithDictionary:object];
    }] animation:animation];
}

- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index; {
    [self insertRows:@[row] atIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation; {
    [self insertRows:@[row] atIndexes:[NSIndexSet indexSetWithIndex:index] animation:animation];
}
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes; {
    [self insertRows:rows atIndexes:indexes animation:UITableViewRowAnimationNone];
}
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation; {
    NSInteger section = [self.model.sections indexOfObject:self];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
    }];
    
    [_rows insertObjects:rows atIndexes:indexes];
    
    for (KSOFormRow *row in rows) {
        [row setSection:self];
    }
    
    [self.model.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)removeRow:(KSOFormRow *)row; {
    [self removeRows:@[row]];
}
- (void)removeRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation; {
    [self removeRows:@[row] animation:animation];
}
- (void)removeRows:(NSArray<KSOFormRow *> *)rows; {
    [self removeRows:rows animation:UITableViewRowAnimationNone];
}
- (void)removeRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation; {
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
    
    [self.model.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow; {
    [self replaceRow:oldRow withRow:newRow animation:UITableViewRowAnimationNone];
}
- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow animation:(UITableViewRowAnimation)animation; {
    NSUInteger index = [_rows indexOfObject:oldRow];
    
    [_rows replaceObjectAtIndex:index withObject:newRow];
    
    [oldRow setSection:nil];
    [newRow setSection:self];
    
    [self.model.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
}
#pragma mark Properties
- (BOOL)wantsHeaderView {
    return (self.headerTitle != nil ||
            self.headerAttributedTitle != nil ||
            self.headerViewClass != Nil);
}
- (BOOL)wantsFooterView {
    return (self.footerTitle != nil ||
            self.footerAttributedTitle != nil ||
            self.footerViewClass != Nil);
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
- (KSOFormRow *)objectAtIndexedSubscript:(NSUInteger)index; {
    return self.rows[index];
}
- (void)setObject:(KSOFormRow *)obj atIndexedSubscript:(NSUInteger)index; {
    [self replaceRow:self.rows[index] withRow:obj];
}
@end
