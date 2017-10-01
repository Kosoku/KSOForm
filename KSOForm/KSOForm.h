//
//  KSOForm.h
//  KSOForm
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

//! Project version number for KSOForm.
FOUNDATION_EXPORT double KSOFormVersionNumber;

//! Project version string for KSOForm.
FOUNDATION_EXPORT const unsigned char KSOFormVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KSOForm/PublicHeader.h>

// defines
#import <KSOForm/KSOFormModelDefines.h>
#import <KSOForm/KSOFormSectionDefines.h>
#import <KSOForm/KSOFormRowDefines.h>

// protocols
#import <KSOForm/KSOFormRowView.h>
#import <KSOForm/KSOFormSectionView.h>
#import <KSOForm/KSOFormRowValueDataSource.h>
#import <KSOForm/KSOFormPickerViewRow.h>
#import <KSOForm/KSOFormRowSegmentedItem.h>
#import <KSOForm/KSOFormRowActionDelegate.h>
#import <KSOForm/KSOFormThemeFirstResponderIndicatorView.h>

// classes
#import <KSOForm/KSOFormModel.h>
#import <KSOForm/KSOFormSection.h>
#import <KSOForm/KSOFormRow.h>
#import <KSOForm/KSOFormTheme.h>
#import <KSOForm/KSOFormTableViewController.h>
