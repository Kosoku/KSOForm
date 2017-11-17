//
//  KSOFormRowActionDelegate.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/27/17.
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

