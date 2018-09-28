//
//  KSOFormSection.h
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

#import <UIKit/UIKit.h>
#import <KSOForm/KSOFormSectionDefines.h>
#import <KSOForm/KSOFormRowDefines.h>

NS_ASSUME_NONNULL_BEGIN

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
 Get the identifier of the section. The identifier is created during initialization and cannot be changed. If you want to use a custom identifier, pass one using KSOFormSectionKeyIdentifier.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Get the context associated with the receiver.
 */
@property (weak,nonatomic,nullable) id context;

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
 Get the custom header view class used to create the header view from a XIB.
 */
@property (strong,nonatomic,nullable) NSBundle *headerViewClassBundle;
/**
 Get the custom footer view class used to display the receiver.
 */
@property (strong,nonatomic,nullable) Class footerViewClass;
/**
 Get the custom footer view class used to create the footer view from a XIB.
 */
@property (strong,nonatomic,nullable) NSBundle *footerViewClassBundle;

/**
 The KSOFormRow objects owned by the receiver. Accessing this property always returns a copy of the underlying NSMutableArray that contains the objects. To add/remove rows after creation, use the various public methods below.
 
 @see KSOFormRow
 */
@property (readonly,copy,nonatomic) NSArray<KSOFormRow *> *rows;

/**
 The designated initializer. Pass a dictionary using the KSOFormSectionKey keys above.
 
 @param dictionary The dictionary contains KSOFormSectionKey keys and appropriate values
 @return The initialized instance
 */
- (instancetype)initWithDictionary:(nullable NSDictionary<KSOFormSectionKey, id> *)dictionary NS_DESIGNATED_INITIALIZER;

/**
 Convenience initializer that calls initWithDictionary:.
 */
+ (instancetype)formSectionWithDictionary:(nullable NSDictionary<KSOFormSectionKey, id> *)dictionary;

/**
 Perform batch updates to the rows owned by the receiver. All calls to the add/insert/remove/replace methods will be animated at the same time.
 
 @param updates The block of updates to perform
 */
- (void)performUpdates:(NS_NOESCAPE dispatch_block_t)updates;

/**
 Reload *row* without animation.
 
 @param row The row to reload
 */
- (void)reloadRow:(KSOFormRow *)row;
/**
 Reload *row* using the specified *animation*.
 
 @param row The row to reload
 @param animation The animation to use
 */
- (void)reloadRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation;
/**
 Reload *rows* without animation.
 
 @param rows The rows to reload
 */
- (void)reloadRows:(NSArray<KSOFormRow *> *)rows;
/**
 Reload *rows* using the specified *animation*.
 
 @param rows The rows to reload
 @param animation The animation to use
 */
- (void)reloadRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation;

/**
 Add the *row* without animation.
 
 @param row The row to add
 */
- (void)addRow:(KSOFormRow *)row;
/**
 Add the *row* using the specified *animation*.
 
 @param row The row to add
 @param animation The animation to use
 */
- (void)addRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation;
/**
 Adds the *rows* without animation.
 
 @param rows The rows to add
 */
- (void)addRows:(NSArray<KSOFormRow *> *)rows;
/**
 Adds the *rows* using the specified *animation*.
 
 @param rows The rows to add
 @param animation The animation to use
 */
- (void)addRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation;

/**
 Add the row from *dictionary* without animation.
 
 @param dictionary The dictionary from which to create a row
 */
- (void)addRowFromDictionary:(NSDictionary<KSOFormRowKey, id> *)dictionary;
/**
 Add the row from *dictionary* using the specified *animation*.
 
 @param dictionary The dictionary from which to create a row
 @param animation The animation to use
 */
- (void)addRowFromDictionary:(NSDictionary<KSOFormRowKey, id> *)dictionary animation:(UITableViewRowAnimation)animation;
/**
 Add the rows from *dictionaries* without animation.
 
 @param dictionaries The dictionaries form which to create rows
 */
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<KSOFormRowKey, id> *> *)dictionaries;
/**
 Add the rows from *dictionaries* using the specified *animation*.
 
 @param dictionaries The dictionaries form which to create rows
 @param animation The animation to use
 */
- (void)addRowsFromDictionaries:(NSArray<NSDictionary<KSOFormRowKey, id> *> *)dictionaries animation:(UITableViewRowAnimation)animation;

/**
 Inserts the *row* at *index* without animation.
 
 @param row The row to add
 @param index The index to insert at
 */
- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index;
/**
 Inserts the *row* at *index* using the specified *animation*.
 
 @param row The row to insert
 @param index The index to insert at
 @param animation The animation to use
 */
- (void)insertRow:(KSOFormRow *)row atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation;
/**
 Inserts the *rows* at *indexes* without animation.
 
 @param rows The rows to insert
 @param indexes The indexes to insert
 */
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes;
/**
 Inserts the *rows* at *indexes* using the specified *animation*.
 
 @param rows The rows to insert
 @param indexes The indexes to insert
 @param animation The animation to use
 */
- (void)insertRows:(NSArray<KSOFormRow *> *)rows atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation;

/**
 Removes *row* without animation.
 
 @param row The row to remove
 */
- (void)removeRow:(KSOFormRow *)row;
/**
 Removes *row* using the specified *animation*.
 
 @param row The row to remove
 @param animation The animation to use
 */
- (void)removeRow:(KSOFormRow *)row animation:(UITableViewRowAnimation)animation;
/**
 Removes the *rows* without animation.
 
 @param rows The rows the remove
 */
- (void)removeRows:(NSArray<KSOFormRow *> *)rows;
/**
 Removes *rows* using the specified *animation*.
 
 @param rows The rows to remove
 @param animation The animation to use
 */
- (void)removeRows:(NSArray<KSOFormRow *> *)rows animation:(UITableViewRowAnimation)animation;

/**
 Replaces the *oldRow* with *newRow* without animation.
 
 @param oldRow The row to replace
 @param newRow The new row
 */
- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow;
/**
 Replaces *oldRow* with *newRow* using the specified *animation*.
 
 @param oldRow The row to replace
 @param newRow The new row
 @param animation The animation to use
 */
- (void)replaceRow:(KSOFormRow *)oldRow withRow:(KSOFormRow *)newRow animation:(UITableViewRowAnimation)animation;

@end

/**
 Adds support for keyed subscripting to KSFormSection instances. You can set and get their properties like you would an instance of NSDictionary.
 
 For example:
 
     KSFormSection *section = ...;
 
     // set the title
     model[KSOFormSectionKeyHeaderTitle] = @"New Header Title";
 */
@interface KSOFormSection (KSOFormSectionKeyedSubscripting)
/**
 Return the value for the provided *key*.
 
 @param key The form section key
 @return The corresponding value for key
 */
- (nullable id)objectForKeyedSubscript:(KSOFormSectionKey)key;
/**
 Set the value of *key* to *obj*.
 
 @param obj The obj to set as the value
 @param key The key to use when setting the value
 */
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormSectionKey)key;
@end

/**
 Adds support for indexed subscripting to KSOFormSection instances. You can get and replace their KSOFormRow objects as you would objects in an NSMutableArray object.
 
 For example:
 
     KSOFormSection *section = ...;
     KSOFormRow *row = ...;
 
     // replace row at index 2 with row
     section[2] = row;
 */
@interface KSOFormSection (KSOFormSectionIndexedSubscripting)
/**
 Return the KSOFormRow at the provided *index*.
 
 KSOFormSection *section = ...;
 
 // return the section at index 1
 KSOFormRow *row = section[1];
 
 @param index The index of the KSOFormRow to return
 @return The section
 */
- (KSOFormRow *)objectAtIndexedSubscript:(NSUInteger)index;
/**
 This calls through to replaceRow:withRow:, passing *obj* and self[index] respectively.
 
 @param obj The new section
 @param index The index of the section to replace
 */
- (void)setObject:(KSOFormRow *)obj atIndexedSubscript:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END

