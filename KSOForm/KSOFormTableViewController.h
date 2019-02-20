//
//  KSOFormTableViewController.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFormModel,KSOFormTheme;

/**
 KSOFormTableViewController manages the display of a single KSOFormModel object. If you add/remove/replace the sections/rows of the KSOFormModel owned by the receiver, it will automatically update the appropriate UI. The default appearance matches the display of the Settings app.
 */
@interface KSOFormTableViewController : UITableViewController

/**
 The theme controlling the appearance of the receiver.
 
 The default is KSOFormTheme.defaultTheme.
 
 @see KSOFormTheme
 */
@property (strong,nonatomic,null_resettable) KSOFormTheme *theme;

/**
 The form model displayed by the receiver. Setting this causes the entire table view to reload. Use the add/remove/replace methods in KSOFormModel and KSOFormSection for more granular updates.
 
 @see KSOFormModel
 */
@property (strong,nonatomic,nullable) KSOFormModel *model;

/**
 Perform any setup before the receiver's view is loaded. For example, create and set the KSOFormModel your subclass will display. You must call super.
 */
- (void)setup NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
