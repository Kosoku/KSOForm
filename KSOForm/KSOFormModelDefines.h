//
//  KSOFormModelDefines.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/30/17.
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

#ifndef __KSO_FORM_MODEL_DEFINES__
#define __KSO_FORM_MODEL_DEFINES__

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFormModel;

/**
 Block that is invoked immediately before owning KSOFormTableViewController is displayed. This happens within the viewWillAppear: method. You could use this block to adjust contentInsets for example.
 
 @param model The model that is about to be visible
 */
typedef void(^KSOFormModelWillAppearBlock)(KSOFormModel *model);
/**
 Block that is invoked after the owning KSOFormTableViewController has been fully displayed. This happens within the viewDidAppear: method. You could use this block to begin editing a specific row, for example.
 
 @param model The model that is visible
 */
typedef void(^KSOFormModelDidAppearBlock)(KSOFormModel *model);

/**
 String type that should be used for keys of a dictionary used to initialize the receiver.
 */
typedef NSString* KSOFormModelKey NS_EXTENSIBLE_STRING_ENUM;

/**
 The title of the owning KSOFormTableViewController.
 
 @see [KSOFormModel title]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyTitle;
/**
 The titleView of the owning KSOFormTableViewController. This overrides KSOFormModelKeyTitle if non-nil.
 
 @see [KSOFormModel titleView]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyTitleView;
/**
 The left bar button items of the owning KSOFormTableViewController.
 
 @see [KSOFormModel leftBarButtonItems]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyLeftBarButtonItems;
/**
 The right bar button items of the owning KSOFormTableViewController.
 
 @see [KSOFormModel rightBarButtonItems]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyRightBarButtonItems;

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
 A block that is invoked within viewWillAppear:.
 
 @see [KSOFormModel willAppearBlock]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyWillAppearBlock;
/**
 A block that is invoked within viewDidAppear:.
 
 @see [KSOFormModel didAppearBlock]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyDidAppearBlock;

/**
 The KSOFormSection objects owned by the receiver. These can be either KSOFormSection objects or NSDictionary objects.
 
 @see [KSOFormSection sections]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeySections;
/**
 The KSOFormRow objects owned by the receiver. If this key is present and KSOFormModelKeySections is not, a single KSOFormSection object will be created and passed these rows.
 
 @see [KSOFormSection rows]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyRows;

NS_ASSUME_NONNULL_END

#endif
