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

/**
 Enum for possible form row types.
 */
typedef NS_ENUM(NSInteger, KSOFormRowType) {
    /**
     The trailing view is a UILabel.
     */
    KSOFormRowTypeLabel = 0,
    /**
     The trailing view is a UITextField.
     */
    KSOFormRowTypeText,
    /**
     The trailing view is a UITextView.
     */
    KSOFormRowTypeTextMultiline,
    /**
     The trailing view is a UISwitch.
     */
    KSOFormRowTypeSwitch,
    /**
     The trailing view is a KDIPickerViewButton.
     */
    KSOFormRowTypePickerView,
    /**
     The trailing view is a KDIDatePickerButton.
     */
    KSOFormRowTypeDatePicker,
    /**
     The trailing view is a UIStepper.
     */
    KSOFormRowTypeStepper,
    /**
     The trailing view is a UISlider.
     */
    KSOFormRowTypeSlider,
    /**
     The leading view is a UIButton. The trailing view is nil.
     */
    KSOFormRowTypeButton,
    /**
     The trailing view is a UISegmentedControl.
     */
    KSOFormRowTypeSegmented,
    /**
     The trailing view is a UILabel showing the current selection. Tapping the row pushes a new form allowing the user to make a new selection.
     */
    KSOFormRowTypeOptions
};

/**
 Enum for possible action values. This controls whether the action view controller is pushed or presented modally.
 */
typedef NS_ENUM(NSInteger, KSOFormRowAction) {
    /**
     The action view controller is pushed onto the navigation stack.
     */
    KSOFormRowActionPush = 0,
    /**
     The action view controller is presented modally wrapped in a UINavigationController.
     */
    KSOFormRowActionPresent
};

/**
 Enum for possible cell accessory types.
 */
typedef NS_ENUM(NSInteger, KSOFormRowCellAccessoryType) {
    /**
     No cell accessory type.
     */
    KSOFormRowCellAccessoryTypeNone = UITableViewCellAccessoryNone,
    /**
     The disclosure chevron.
     */
    KSOFormRowCellAccessoryTypeDisclosureIndicator = UITableViewCellAccessoryDisclosureIndicator,
    /**
     The detail button and disclosure chevron.
     */
    KSOFormRowCellAccessoryTypeDetailDisclosureButton = UITableViewCellAccessoryDetailDisclosureButton,
    /**
     The checkmark.
     */
    KSOFormRowCellAccessoryTypeCheckmark = UITableViewCellAccessoryCheckmark,
    /**
     The detail button.
     */
    KSOFormRowCellAccessoryTypeDetailButton = UITableViewCellAccessoryDetailButton,
    /**
     Determine the cell accessory type automatically. This is the default.
     */
    KSOFormRowCellAccessoryTypeAutomatic = NSIntegerMax
};

@class KSOFormRow;

/**
 Block that is invoked when the receiver value is about to change. The block should return YES to allow the change, otherwise NO.
 
 @param row The row whose value ia about to change
 @param value The new value
 @param error The error that will be displayed to the user if the change is rejected
 */
typedef BOOL(^KSOFormRowShouldChangeValueBlock)(KSOFormRow *row, id _Nullable value, NSError **error);
/**
 Block that is invoked when the receiver value changes.
 
 @param row The row whose value changed
 @param value The new value
 */
typedef void(^KSOFormRowDidChangeValueBlock)(KSOFormRow *row, id _Nullable value);

/**
 String type that should be used for keys of a dictionary used to initialize the receiver.
 */
typedef NSString* KSOFormRowKey NS_EXTENSIBLE_STRING_ENUM;

/**
 The type of the receiver. Must be one of the KSOFormRowType values.
 
 @see [KSOFormRow type]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyType;
/**
 The value of the receiver. Should be appropriate for the type, unless a valueFormatter is provided.
 
 @see [KSOFormRow value]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValue;
/**
 The value key of the receiver. This will be used to read/write the value from the valueDataSource.
 
 @see [KSOFormRow valueKey]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueKey;
/**
 The value formatter used to format value for display. Must be a subclass of NSFormatter.
 
 @see [KSOFormRow valueFormatter]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueFormatter;
/**
 The value data source used to retrieve value using valueKey.
 
 @see [KSOFormRow valueDataSource]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueDataSource;
/**
 The value should change block that is invoked before the value is set to allow the change.
 
 @see [KSOFormRow valueShouldChangeBlock]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueShouldChangeBlock;
/**
 The value did change block that is invoked after the value is set.
 
 @see [KSOFormRow valueDidChangeBlock]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueDidChangeBlock;

/**
 The image of the receiver. Aligned to the leading edge.
 
 @see [KSOFormRow image]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyImage;
/**
 The title of the receiver. Aligned to the leading edge.
 
 @see [KSOFormRow title]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTitle;
/**
 The subtitle of the receiver. Aligned to the leading edge.
 
 @see [KSOFormRow subtitle]
 */
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
