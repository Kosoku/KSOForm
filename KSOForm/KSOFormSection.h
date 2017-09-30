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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 String type that should be used for keys of a dictionary used to initialize the receiver.
 */
typedef NSString* KSOFormSectionKey NS_EXTENSIBLE_STRING_ENUM;

/**
 The KSOFormRow objects owned by the receiver. These can be either KSOFormRow objects or NSDictionary objects.
 
 @see rows
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyRows;
/**
 The title of the section header in the UITableView displaying the form.
 
 @see headerTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderTitle;
/**
 The title of the section footer in the UITableView displaying the form.
 
 @see footerTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterTitle;
/**
 The attributed title of the section header in the UITableView displaying the form.
 
 @see headerAttributedTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle;
/**
 The attributed title of the section footer in the UITableView displaying the form.
 
 @see footerAttributedTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle;
/**
 The custom section header class that should be used for this section.
 
 @see headerViewClass
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderViewClass;
/**
 The custom section footer class that should be used for this section.
 
 @see footerViewClass
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterViewClass;

@class KSOFormRow,KSOFormModel;

/**
 KSOFormSection represents a single section in a KSOFormModel object. It is displayed using a single section in a UITableView. Changing any of its properties will automatically update its display within the UITableView displaying the form.
 */
@interface KSOFormSection : NSObject

/**
 Get the form that owns the receiver.
 
 @see KSOFormModel
 */
@property (readonly,weak,nonatomic) KSOFormModel *model;

/**
 Get the identifier of the section. The identifier is created during initialization and cannot be changed.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Get whether the display of the receiver should use a section header.
 */
@property (readonly,nonatomic) BOOL wantsHeaderView;
/**
 Get whether the display of the receiver should use a section footer.
 */
@property (readonly,nonatomic) BOOL wantsFooterView;

/**
 Get the header title of the receiver.
 */
@property (copy,nonatomic,nullable) NSString *headerTitle;
/**
 Get the footer title of the receiver.
 */
@property (copy,nonatomic,nullable) NSString *footerTitle;

/**
 Get the header attributed title of the receiver. This value is preferred over headerTitle.
 */
@property (copy,nonatomic,nullable) NSAttributedString *headerAttributedTitle;
/**
 Get the footer attributed title of the receiver. This value is preferred over footerTitle.
 */
@property (copy,nonatomic,nullable) NSAttributedString *footerAttributedTitle;

/**
 Get the custom header view class used to display the receiver.
 */
@property (strong,nonatomic,nullable) Class headerViewClass;
/**
 Get the custom footer view class used to display the receiver.
 */
@property (strong,nonatomic,nullable) Class footerViewClass;

/**
 The KSOFormRow objects owned by the receiver. Accessing this property always returns a copy of the underlying NSMutableArray that contains the objects. To add/remove rows after creation, use the various public methods below.
 
 @see KSOFormRow
 */
@property (readonly,copy,nonatomic) NSArray<KSOFormRow *> *rows;

- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary model:(nullable KSOFormModel *)model NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary;

- (void)performUpdates:(nullable NS_NOESCAPE dispatch_block_t)updates;

- (void)addRow:(KSOFormRow *)row;
- (void)addRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation;
- (void)addRows:(NSArray<KSOFormRow *> *)rows;
- (void)addRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation;

- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary;
- (void)addRowFromDictionary:(NSDictionary<NSString *,id> *)dictionary animation:(UITableViewRowAnimation)animation;
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries;
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries animation:(UITableViewRowAnimation)animation;

- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index;
- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation;
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes;
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation;

- (void)removeRow:(KSOFormRow *)row;
- (void)removeRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation;
- (void)removeRows:(NSArray<KSOFormRow *> *)rows;
- (void)removeRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation;

- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow;
- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow animation:(UITableViewRowAnimation)animation;

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

