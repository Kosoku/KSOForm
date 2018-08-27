//
//  KSOFormTableViewController.h
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
