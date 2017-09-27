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
#import "KSOFormRow.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

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
    [[self mutableArrayValueForKey:@kstKeypath(self,rows)] addObjectsFromArray:rows];
}

- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary; {
    [self addRow:[[KSOFormRow alloc] initWithDictionary:dictionary section:self]];
}
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries; {
    [self addRows:[dictionaries KQS_map:^id _Nullable(NSDictionary<NSString *,id> * _Nonnull object, NSInteger index) {
        return [[KSOFormRow alloc] initWithDictionary:object section:self];
    }]];
}
#pragma mark Properties
- (NSArray<KSOFormRow *> *)rows {
    return [_rows copy];
}
#pragma mark *** Private Methods ***
#pragma mark KVC
- (void)insertObject:(KSOFormRow *)object inRowsAtIndex:(NSUInteger)index {
    [_rows insertObject:object atIndex:index];
    
    [object setSection:self];
}
- (void)removeObjectFromRowsAtIndex:(NSUInteger)index {
    [_rows removeObjectAtIndex:index];
}
- (void)insertRows:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [_rows insertObjects:array atIndexes:indexes];
    
    for (KSOFormRow *row in array) {
        [row setSection:self];
    }
}
- (void)removeRowsAtIndexes:(NSIndexSet *)indexes {
    [_rows removeObjectsAtIndexes:indexes];
}
- (void)replaceObjectInRowsAtIndex:(NSUInteger)index withObject:(KSOFormRow *)object {
    [_rows replaceObjectAtIndex:index withObject:object];
    
    [object setSection:self];
}

@end
