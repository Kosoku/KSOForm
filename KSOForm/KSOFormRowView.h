//
//  KSOFormRowView.h
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
