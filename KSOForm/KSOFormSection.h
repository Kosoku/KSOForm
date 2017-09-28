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

typedef NSString* KSOFormSectionKey NS_STRING_ENUM;

static KSOFormSectionKey const KSOFormSectionKeyRows = @"rows";
static KSOFormSectionKey const KSOFormSectionKeyHeaderTitle = @"headerTitle";
static KSOFormSectionKey const KSOFormSectionKeyFooterTitle = @"footerTitle";
static KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle = @"headerAttributedTitle";
static KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle = @"footerAttributedTitle";

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



@property (readonly,copy,nonatomic) NSArray<KSOFormRow *> *rows;

- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary model:(nullable KSOFormModel *)model NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary;

- (void)addRow:(KSOFormRow *)row;
- (void)addRows:(NSArray<KSOFormRow *> *)rows;

- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary;
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries;

- (void)removeRow:(KSOFormRow *)row;
- (void)removeRows:(NSArray<KSOFormRow *> *)rows;

@end

NS_ASSUME_NONNULL_END

