//
//  KSOFormRowActionDelegate.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/27/17.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFormRow,KSOFormModel;

/**
 Protocol for an object that vends increasingly specialize objects for displaying additional UI when KSFormRow objects are interacted with by the user. The methods are checked for implementation and non-nil return values from top to bottom. The first non-nil return value is used.
 */
@protocol KSOFormRowActionDelegate <NSObject>
@optional
/**
 The KSOFormModel to use when creating a new form table view controller to push or present.
 
 @param formRow The form row for which to take action
 @return The form model
 */
- (nullable KSOFormModel *)actionFormModelForFormRow:(KSOFormRow *)formRow;
/**
 The view controller class to use when creating a view controller to push or present.
 
 @param formRow The form row for which to take action
 @return The view controller class
 */
- (nullable Class)actionViewControllerClassForFormRow:(KSOFormRow *)formRow;
/**
 The view controller to push or present.
 
 @param formRow The form row for which to take action
 @return The view controller
 */
- (nullable __kindof UIViewController *)actionViewControllerForFormRow:(KSOFormRow *)formRow;
/**
 Allows the delegate to handle the action itself.
 
 @param formRow The form row for which to take action
 */
- (void)executeActionForFormRow:(KSOFormRow *)formRow;
@end

NS_ASSUME_NONNULL_END

