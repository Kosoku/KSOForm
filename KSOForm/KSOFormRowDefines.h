//
//  KSOFormRowDefines.h
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

#ifndef __KSO_FORM_ROW_DEFINES__
#define __KSO_FORM_ROW_DEFINES__

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSOFormRowType) {
    KSOFormRowTypeLabel = 0,
    KSOFormRowTypeText,
    KSOFormRowTypeTextMultiline,
    KSOFormRowTypeSwitch,
    KSOFormRowTypePickerView,
    KSOFormRowTypeDatePicker,
    KSOFormRowTypeStepper,
    KSOFormRowTypeSlider,
    KSOFormRowTypeButton,
    KSOFormRowTypeSegmented
};

typedef NS_ENUM(NSInteger, KSOFormRowAction) {
    KSOFormRowActionPush = 0,
    KSOFormRowActionPresent
};

typedef NS_ENUM(NSInteger, KSOFormRowCellAccessoryType) {
    KSOFormRowCellAccessoryTypeNone = UITableViewCellAccessoryNone,
    KSOFormRowCellAccessoryTypeDisclosureIndicator = UITableViewCellAccessoryDisclosureIndicator,
    KSOFormRowCellAccessoryTypeDetailDisclosureButton = UITableViewCellAccessoryDetailDisclosureButton,
    KSOFormRowCellAccessoryTypeCheckmark = UITableViewCellAccessoryCheckmark,
    KSOFormRowCellAccessoryTypeDetailButton = UITableViewCellAccessoryDetailButton,
    KSOFormRowCellAccessoryTypeAutomatic = NSIntegerMax
};

@class KSOFormRow;

typedef BOOL(^KSOFormRowShouldChangeValueBlock)(KSOFormRow *row, id _Nullable value, NSError **error);
typedef void(^KSOFormRowDidChangeValueBlock)(KSOFormRow *row, id _Nullable value);

typedef NSString* KSOFormRowKey NS_EXTENSIBLE_STRING_ENUM;

// value related
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValue;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueKey;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueFormatter;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueDataSource;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueShouldChangeBlock;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueDidChangeBlock;
// secondary properties
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyImage;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTitle;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySubtitle;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellAccessoryType;
// text properties
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPlaceholder;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMinimumNumberOfLines;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMaximumNumberOfLines;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextValidator;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextFormatter;
// UITextInputTraits
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAutocapitalizationType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAutocorrectionType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySpellCheckingType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartQuotesType NS_AVAILABLE_IOS(11_0);
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartDashesType NS_AVAILABLE_IOS(11_0);
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartInsertDeleteType NS_AVAILABLE_IOS(11_0);
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyKeyboardType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyKeyboardAppearance;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyReturnKeyType;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyEnablesReturnKeyAutomatically;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySecureTextEntry;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextContentType;
// UIPickerView
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewColumnsAndRows;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewRows;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewSelectedComponentsJoinString;
// UIDatePicker
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMode;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMinimumDate;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMaximumDate;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerDateFormatter;
// UIStepper & UISlider
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMinimumValue;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMaximumValue;
// UIStepper
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyStepperStepValue;
// UISlider
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySliderMinimumValueImage;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySliderMaximumValueImage;
// UIControl (e.g. UIButton)
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyControlBlock;
// UISegmentedControl
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySegmentedItems;
// present/push support
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAction;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionDelegate;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionModel;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionViewControllerClass;
// custom cell support
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellClass;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellIdentifier;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyHeaderFooterViewIdentifier;
// UIAccessibility
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyImageAccessibilityLabel;
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyButtonAccessibilityHint;

NS_ASSUME_NONNULL_END

#endif
