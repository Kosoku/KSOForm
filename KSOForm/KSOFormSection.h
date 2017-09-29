//
//  KSOFormSection.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* KSOFormSectionKey NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyRows;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderTitle;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterTitle;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderViewClass;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterViewClass;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderViewIdentifier;
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterViewIdentifier;

@class KSOFormRow,KSOFormModel;

@interface KSOFormSection : NSObject

@property (readonly,weak,nonatomic) KSOFormModel *model;

@property (readonly,copy,nonatomic) NSString *identifier;

@property (readonly,nonatomic) BOOL wantsHeaderView;
@property (readonly,nonatomic) BOOL wantsFooterView;

@property (copy,nonatomic,nullable) NSString *headerTitle;
@property (copy,nonatomic,nullable) NSString *footerTitle;

@property (copy,nonatomic,nullable) NSAttributedString *headerAttributedTitle;
@property (copy,nonatomic,nullable) NSAttributedString *footerAttributedTitle;

@property (strong,nonatomic,nullable) Class headerViewClass;
@property (strong,nonatomic,nullable) Class footerViewClass;
@property (copy,nonatomic,nullable) NSString *headerViewIdentifier;
@property (copy,nonatomic,nullable) NSString *footerViewIdentifier;

@property (readonly,copy,nonatomic) NSArray<KSOFormRow *> *rows;

- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary model:(nullable KSOFormModel *)model NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary;

- (void)addRow:(KSOFormRow *)row;
- (void)addRows:(NSArray<KSOFormRow *> *)rows;

- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary;
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries;

- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index;
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes;

- (void)removeRow:(KSOFormRow *)row;
- (void)removeRows:(NSArray<KSOFormRow *> *)rows;

- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow;

@end

@interface KSOFormSection (KSOFormSectionKeyedSubscripting)
- (nullable id)objectForKeyedSubscript:(KSOFormSectionKey)key;
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormSectionKey)key;
@end

@interface KSOFormSection (KSOFormSectionIndexedSubscripting)
- (KSOFormRow *)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(KSOFormRow *)obj atIndexedSubscript:(NSUInteger)idx;
@end

NS_ASSUME_NONNULL_END

