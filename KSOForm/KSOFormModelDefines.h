//
//  KSOFormModelDefines.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/30/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __KSO_FORM_MODEL_DEFINES__
#define __KSO_FORM_MODEL_DEFINES__

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
 The KSOFormSection objects owned by the receiver. These can be either KSOFormSection objects or NSDictionary objects.
 
 @see sections
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeySections;
/**
 The KSOFormRow objects owned by the receiver. If this key is present and KSOFormModelKeySections is not, a single KSOFormSection object will be created and passed these rows.
 
 @see [KSOFormSection rows]
 */
UIKIT_EXTERN KSOFormModelKey const KSOFormModelKeyRows;

NS_ASSUME_NONNULL_END

#endif
