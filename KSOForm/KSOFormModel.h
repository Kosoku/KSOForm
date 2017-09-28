//
//  KSOFormModel.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* KSOFormModelKey NS_EXTENSIBLE_STRING_ENUM;

UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyTitle;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyBackgroundView;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyHeaderView;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyFooterView;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyCellIdentifiersToCellNibs;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyHeaderFooterViewIdentifiersToHeaderFooterViewNibs;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeySections;
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyRows;

@class KSOFormSection,KSOFormRow;

@interface KSOFormModel : NSObject

@property (copy,nonatomic,nullable) NSString *title;

@property (copy,nonatomic,nullable) NSDictionary<NSString *, UINib *> *cellIdentifiersToCellNibs;
@property (copy,nonatomic,nullable) NSDictionary<NSString *, UINib *> *headerFooterViewIdentifiersToHeaderFooterViewNibs;

@property (strong,nonatomic,nullable) __kindof UIView *backgroundView;
@property (strong,nonatomic,nullable) __kindof UIView *headerView;
@property (strong,nonatomic,nullable) __kindof UIView *footerView;

@property (readonly,copy,nonatomic) NSArray<KSOFormSection *> *sections;

- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary NS_DESIGNATED_INITIALIZER;

- (nullable KSOFormRow *)rowForIndexPath:(NSIndexPath *)indexPath;
- (nullable NSIndexPath *)indexPathForRow:(KSOFormRow *)formRow;

- (void)addSection:(KSOFormSection *)section;
- (void)addSections:(NSArray<KSOFormSection *> *)sections;

- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary;
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries;

- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index;
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes;

- (void)removeSection:(KSOFormSection *)section;
- (void)removeSections:(NSArray<KSOFormSection *> *)sections;

- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection;

@end

@interface KSOFormModel (KSOFormModelKeyedSubscripting)
- (nullable id)objectForKeyedSubscript:(KSOFormModelKey)key;
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormModelKey)key;
@end

@interface KSOFormModel (KSOFormModelIndexedSubscripting)
- (KSOFormSection *)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(KSOFormSection *)obj atIndexedSubscript:(NSUInteger)idx;
@end

NS_ASSUME_NONNULL_END

