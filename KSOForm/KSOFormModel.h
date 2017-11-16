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
#import <KSOForm/KSOFormModelDefines.h>
#import <KSOForm/KSOFormSectionDefines.h>

NS_ASSUME_NONNULL_BEGIN

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
 The titleView of the owning KSOFormTableViewController object.
 
 @see [UIViewController titleView]
 */
@property (strong,nonatomic,nullable) __kindof UIView *titleView;
/**
 The left bar button items of the KSOFormTableViewController object.
 
 @see [UINavigationItem leftBarButtonItems]
 */
@property (copy,nonatomic,nullable) NSArray<UIBarButtonItem *> *leftBarButtonItems;
/**
 The right bar button items of the KSOFormTableViewController object.
 
 @see [UINavigationItem rightBarButtonItems]
 */
@property (copy,nonatomic,nullable) NSArray<UIBarButtonItem *> *rightBarButtonItems;

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
 Block that is invoked when the receiver is visible, this is invoked within the viewDidAppear: method. You could use this to begin editing a specific row, for example.
 
 @see KSOFormModelDidAppearBlock
 */
@property (copy,nonatomic,nullable) KSOFormModelDidAppearBlock didAppearBlock;

/**
 The KSOFormSection objects owned by the receiver. Accessing this property always returns a copy of the underlying NSMutableArray that contains the objects. To add/remove sections after creation, use the various public methods below.
 
 @see KSOFormSection
 */
@property (readonly,copy,nonatomic) NSArray<KSOFormSection *> *sections;

/**
 The designated initializer. Pass a dictionary using the KSOFormModelKey keys above.
 
 @param dictionary The dictionary contains KSOFormModelKey keys and appropriate values
 @return The initialized instance
 */
- (instancetype)initWithDictionary:(nullable NSDictionary<KSOFormModelKey, id> *)dictionary NS_DESIGNATED_INITIALIZER;

/**
 Returns the KSOFormSection object for the provided *identifier* or nil if a section with that identifier cannot be found.
 
 @param identifier The section identifier
 @return The section or nil
 */
- (nullable KSOFormSection *)sectionForIdentifier:(NSString *)identifier;
/**
 Returns an array of KSOFormSection objects for the provided *identifiers*.
 
 @param identifiers The array of section identifiers
 @return The array of sections
 */
- (NSArray<KSOFormSection *> *)sectionsForIdentifiers:(NSArray<NSString *> *)identifiers;
/**
 Returns the KSOFormRow object for the provided *identifier* or nil if the a row with that identifier cannot be found.
 
 @param identifier The row identifier
 @return The row or nil
 */
- (nullable KSOFormRow *)rowForIdentifier:(NSString *)identifier;
/**
 Returns an array of KSOFormRow objects for the provided *identifiers*.
 
 @param identifiers The array of row identifiers
 @return The array of rows
 */
- (NSArray<KSOFormRow *> *)rowsForIdentifiers:(NSArray<NSString *> *)identifiers;

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

/**
 Coordinates with the owning KSOFormTableViewController to begin editing the provided *row*. Does nothing if the row is not editable.
 
 @param row The row to begin editing
 */
- (void)beginEditingRow:(KSOFormRow *)row;

/**
 Perform batch updates to the sections/rows owned by the receiver. All calls to the add/insert/remove/replace methods will be animated at the same time.
 
 @param updates The block of updates to perform
 */
- (void)performUpdates:(NS_NOESCAPE dispatch_block_t)updates;

/**
 Reloads the section without animation.
 
 @param section The section to reload
 */
- (void)reloadSection:(KSOFormSection *)section;
/**
 Reloads the *section* using the specified *animation*.
 
 @param section The section to reload
 @param animation The animation to use
 */
- (void)reloadSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation;
/**
 Reloads the *sections* without animation.
 
 @param sections The sections to reload
 */
- (void)reloadSections:(NSArray<KSOFormSection *> *)sections;
/**
 Reloads the *sections* using the specified *animation*.
 
 @param sections The sections to reload
 @param animation The animation to use
 */
- (void)reloadSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation;

/**
 Adds the section without animation.
 
 @param section The section to add
 */
- (void)addSection:(KSOFormSection *)section;
/**
 Adds the section using the specified *animation*.
 
 @param section The section to add
 @param animation The animation to use
 */
- (void)addSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation;
/**
 Adds the sections without animation.
 
 @param sections The sections to add
 */
- (void)addSections:(NSArray<KSOFormSection *> *)sections;
/**
 Adds the sections using the specified *animation*.
 
 @param sections The sections to add
 @param animation The animation to use
 */
- (void)addSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation;

/**
 Add the section from *dictionary* without animation.
 
 @param dictionary The dictionary from which to create a section
 */
- (void)addSectionFromDictionary:(NSDictionary<KSOFormSectionKey, id> *)dictionary;
/**
 Add the section from *dictionary* using the specified *animation*.
 
 @param dictionary The dictionary from which to create a section
 @param animation The animation to use
 */
- (void)addSectionFromDictionary:(NSDictionary<KSOFormSectionKey, id> *)dictionary animation:(UITableViewRowAnimation)animation;
/**
 Add the sections from *dictionaries* without animation.
 
 @param dictionaries The dictionaries from which to create sections
 */
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<KSOFormSectionKey, id> *> *)dictionaries;
/**
 Add the sections from *dictionaries* using the specified *animation*.
 
 @param dictionaries The dictionaries from which to create sections
 @param animation The animation to use
 */
- (void)addSectionsFromDictionaries:(NSArray<NSDictionary<KSOFormSectionKey, id> *> *)dictionaries animation:(UITableViewRowAnimation)animation;

/**
 Insert the *section* at *index* without animation.
 
 @param section The section to insert
 @param index The index to insert at
 */
- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index;
/**
 Insert the *section* at *index* using the specified *animation*.
 
 @param section The section to insert
 @param index The index to insert at
 @param animation The animation to use
 */
- (void)insertSection:(KSOFormSection *)section atIndex:(NSUInteger)index animation:(UITableViewRowAnimation)animation;
/**
 Insert the *sections* at *indexes* without animation.
 
 @param sections The sections to insert
 @param indexes The indexes to insert at
 */
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes;
/**
 Insert the *sections* at *indexes* using the specified *animation*.
 
 @param sections The sections to insert
 @param indexes The indexes to insert at
 @param animation The animation to use
 */
- (void)insertSections:(NSArray<KSOFormSection *> *)sections atIndexes:(NSIndexSet *)indexes animation:(UITableViewRowAnimation)animation;

/**
 Removes the *section* without animation.
 
 @param section The section to remove
 */
- (void)removeSection:(KSOFormSection *)section;
/**
 Removes the *section* using the specified *animation*.
 
 @param section The section to remove
 @param animation The animation to use
 */
- (void)removeSection:(KSOFormSection *)section animation:(UITableViewRowAnimation)animation;
/**
 Removes the *sections* without animation.
 
 @param sections The sections to remove
 */
- (void)removeSections:(NSArray<KSOFormSection *> *)sections;
/**
 Removes the *sections* using the specified *animation*.
 
 @param sections The sections to remove
 @param animation The animation to use
 */
- (void)removeSections:(NSArray<KSOFormSection *> *)sections animation:(UITableViewRowAnimation)animation;

/**
 Replaces *oldSection* with *newSection* without animation.
 
 @param oldSection The section to replace
 @param newSection The new section
 */
- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection;
/**
 Replaces *oldSection* with *newSection* using the specified *animation*.
 
 @param oldSection The section to replace
 @param newSection The new section
 @param animation The animation to use
 */
- (void)replaceSection:(KSOFormSection *)oldSection withSection:(KSOFormSection *)newSection animation:(UITableViewRowAnimation)animation;

@end

/**
 Adds support for keyed subscripting to KSOFormModel instances. You can set and get their properties like you would an instance of NSDictionary.
 
 For example:
 
     KSOFormModel *model = ...;
 
     // set the title
     model[KSOFormModelKeyTitle] = @"New Title";
 */
@interface KSOFormModel (KSOFormModelKeyedSubscripting)
/**
 Return the value for the provided *key*.
 
 @param key The form model key
 @return The corresponding value for key
 */
- (nullable id)objectForKeyedSubscript:(KSOFormModelKey)key;
/**
 Set the value of *key* to *obj*.
 
 @param obj The obj to set as the value
 @param key The key to use when setting the value
 */
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormModelKey)key;
@end

/**
 Adds support for indexed subscripting to KSOFormModel instances. You can get and replace their KSOFormSection objects as you would objects in an NSMutableArray object.
 
 For example:
 
     KSOFormModel *model = ...;
     KSOFormSection *section = ...;
 
     // replace section at index 2 with section
     model[2] = section;
 */
@interface KSOFormModel (KSOFormModelIndexedSubscripting)
/**
 Return the KSOFormSection at the provided *index*.
 
     KSOFormModel *model = ...;
 
     // return the section at index 1
     KSOFormSection *section = model[1];
 
 @param index The index of the KSOFormSection to return
 @return The section
 */
- (KSOFormSection *)objectAtIndexedSubscript:(NSUInteger)index;
/**
 This calls through to replaceSection:withSection:, passing *obj* and self[index] respectively.
 
 @param obj The new section
 @param index The index of the section to replace
 */
- (void)setObject:(KSOFormSection *)obj atIndexedSubscript:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END

