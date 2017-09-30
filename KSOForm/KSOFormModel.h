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

/**
 String type that should be used for keys of a dictionary used to initialize the receiver.
 */
typedef NSString* KSOFormModelKey NS_EXTENSIBLE_STRING_ENUM;

/**
 The title of the owning KSOFormTableViewController.
 
 @see title
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyTitle;
/**
 The backgroundView of the UITableView displaying the form.
 
 @see [UITableView backgroundView]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyBackgroundView;
/**
 The tableHeaderView of the UITableView displaying the form.
 
 @see [UITableView tableHeaderView]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyHeaderView;
/**
 The tableFooterView of the UITableView displaying the form.
 
 @see [UITableView tableFooterView]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyFooterView;
/**
 The KSOFormSection objects owned by the receiver. These can be either KSOFormSection objects or NSDictionary objects.
 
 @see sections
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeySections;
/**
 The KSOFormRow objects owned by the receiver. If this key is present and KSOFormModelKeySections is not, a single KSOFormSection object will be created and passed these rows.
 
 @see [KSOFormSection rows]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyRows;

@class KSOFormSection,KSOFormRow;

/**
 KSOFormModel is the root of a form object displayed by an owning KSOFormTableViewController object. It represents the root of the form tree. Modifying any of its properties will update the display of the form appropriately.
 */
@interface KSOFormModel : NSObject

/**
 The title of the owning KSOFormTableViewController object.
 
 @see [UIViewController title]
 */
@property (copy,nonatomic,nullable) NSString *title;

/**
 The backgroundView of the owning UITableView displaying the form.
 
 @see [UITableView backgroundView]
 */
@property (strong,nonatomic,nullable) __kindof UIView *backgroundView;
/**
 The tableHeaderView of the UITableView displaying the form.
 
 @see [UITableView tableHeaderView]
 */
@property (strong,nonatomic,nullable) __kindof UIView *headerView;
/**
 The tableFooterView of the UITableView displaying the form.
 
 @see [UITableView tableFooterView]
 */
@property (strong,nonatomic,nullable) __kindof UIView *footerView;

/**
 The KSOFormSection objects owned by the receiver. Accessing this property always returns a copy of the underlying NSMutableArray that contains the objects. To add/remove sections after creation, use the various public methods below.
 
 @see KSOFormSection
 */
@property (readonly,copy,nonatomic) NSArray<KSOFormSection *> *sections;

/**
 The designated initializer. Pass a dictionary using the KSOFormModelKey keys above.
 
 @param dictionary The dictionary contains KSOFormModelKey keys and appropriate values
 @return The initialize instance
 */
- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary NS_DESIGNATED_INITIALIZER;

/**
 Returns the corresponding KSOFormRow object for the provided *indexPath* or nil if the section or row of the *indexPath* is out of bounds.
 
 @param indexPath The index path for which to return a row
 @return The form row
 */
- (nullable KSOFormRow *)rowForIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the corresponding NSIndexPath object for the provided *formRow* or nil if the *formRow* is not owned by the receiver.
 
 @param formRow The form row for which to return a index path
 @return The index path
 */
- (nullable NSIndexPath *)indexPathForRow:(KSOFormRow *)formRow;

- (void)performUpdates:(nullable NS_NOESCAPE dispatch_block_t)updates;

- (void)addSection:(KSOFormSection *)section;
- (void)addSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation;
- (void)addSections:(NSArray<KSOFormSection *> *)sections;
- (void)addSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation;

- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary;
- (void)addSectionFromDictionary:(NSDictionary<NSString *,id> *)dictionary animation:(UITableViewRowAnimation)animation;
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries;
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<NSString *,id> *> *)dictionaries animation:(UITableViewRowAnimation)animation;

- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index;
- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation;
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes;
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation;

- (void)removeSection:(KSOFormSection *)section;
- (void)removeSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation;
- (void)removeSections:(NSArray<KSOFormSection *> *)sections;
- (void)removeSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation;

- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection;
- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection animation:(UITableViewRowAnimation)animation;

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

