//
//  KSOFormRowView.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
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

/**
 Notification posted when the receiver begins editing. Post this when appropriate to get automatic support for indication of editing in the table view cell.
 */
FOUNDATION_EXTERN NSNotificationName const KSOFormRowViewNotificationDidBeginEditing;
/**
 Notification posted when the receiver ends editing. Post this when appropriate to get automatic support for indication of editing in the table view cell.
 */
FOUNDATION_EXTERN NSNotificationName const KSOFormRowViewNotificationDidEndEditing;

@class KSOFormRow,KSOFormTheme;

/**
 Protocol for an object used to display a single KSOFormRow object.
 */
@protocol KSOFormRowView <NSObject>
@required
/**
 The form row to display.
 */
@property (strong,nonatomic,nullable) KSOFormRow *formRow;
@optional
/**
 The form theme to control appearance.
 */
@property (strong,nonatomic,nullable) KSOFormTheme *formTheme;

/**
 Return whether the receiver supports editing the form row.
 */
@property (readonly,nonatomic) BOOL canEditFormRow;
/**
 Returns whether the receiver is editing the form row.
 */
@property (readonly,nonatomic,getter=isEditingFormRow) BOOL editingFormRow;
/**
 Called to being editing the form row.
 */
- (void)beginEditingFormRow;
@end

NS_ASSUME_NONNULL_END
