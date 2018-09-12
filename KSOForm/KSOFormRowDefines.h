//
//  KSOFormRowDefines.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/30/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
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
    KSOFormRowTypeOptions,
#if (!TARGET_OS_TV)
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
    KSOFormRowTypeSlider
#endif
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
#if (!TARGET_OS_TV)
    KSOFormRowCellAccessoryTypeDetailDisclosureButton = UITableViewCellAccessoryDetailDisclosureButton,
#endif
    /**
     The checkmark.
     */
    KSOFormRowCellAccessoryTypeCheckmark = UITableViewCellAccessoryCheckmark,
    /**
     The detail button.
     */
#if (!TARGET_OS_TV)
    KSOFormRowCellAccessoryTypeDetailButton = UITableViewCellAccessoryDetailButton,
#endif
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
 The identifier of the row. This allows to specify a custom identifier in order to refer to the row later.
 
 @see [KSOFormRow identifier]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyIdentifier;
/**
 The type of the receiver. Must be one of the KSOFormRowType values.
 
 @see [KSOFormRow type]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyType;
/**
 Whether the row is enabled. This affects any controls bound to the row (e.g. UISwitch).
 
 @see [KSOFormRow enabled]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyEnabled;
/**
 The value of the receiver. Should be appropriate for the type, unless a valueFormatter is provided. Aligned to the trailing edge.
 
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
 The value transformer used to format value for display. Must be a subclass of NSValueTransformer. This should not be used to format text input, like UITextField or UITextView. Use KSOFormRowKeyValueFormatter key instead.
 
 @see [KSOFormRow valueTransformer]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyValueTransformer;
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
 The title of the receiver. Aligned to the leading edge, to the right of the image.
 
 @see [KSOFormRow title]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTitle;
/**
 The subtitle of the receiver. Aligned to the leading edge underneath the title.
 
 @see [KSOFormRow subtitle]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySubtitle;
/**
 The cell accessory type of the receiver. Must be one of the KSOFormRowCellAccessoryType values.
 
 @see [KSOFormRow cellAccessoryType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellAccessoryType;
/**
 The cell trailing view of the receiver. Must be a subclass over UIView and conform to the KSOFormRowView protocol.
 
 @see [KSOFormRow cellTrailingView]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellTrailingView;

/**
 The placeholder text of the text field or text view.
 
 @see [KSOFormRow placeholder]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPlaceholder;
/**
 The minimum number of lines for multiline text. The height of the text view will always be at least font.lineHeight * minLines.
 
 @see [KSOFormRow minimumNumberOfLines]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMinimumNumberOfLines;
/**
 The maximum number of lines for multiline text. The height of the text view can be at most font.lineHeight * maxLines before scrolling is required.
 
 @see [KSOFormRow maximumNumberOfLines]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMaximumNumberOfLines;
/**
 The object conforming to the KSOTextValidator protocol to handle text validation for the receiver.
 
 @see [KSOFormRow textValidator]
 @see KSOTextValidator
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextValidator;
/**
 The object conforming to the KSOTextFormatter protocol to handle text formatting for the receiver. NSFormatter conforms to KSOTextFormatter.
 
 @see [KSOFormRow textFormatter]
 @see KSOTextFormatter
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextFormatter;

/**
 The autocapitalization type.
 
 @see [UITextInputTraits autocapitalizationType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAutocapitalizationType;
/**
 The autocorrection type.
 
 @see [UITextInputTraits autocorrectionType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAutocorrectionType;
/**
 The spell checking type.
 
 @see [UITextInputTraits spellCheckingType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySpellCheckingType;
/**
 The smart quotes type.
 
 @see [UITextInputTraits smartQuotesType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartQuotesType NS_AVAILABLE_IOS(11_0);
/**
 The smart dashes type.
 
 @see [UITextInputTraits smartDashesType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartDashesType NS_AVAILABLE_IOS(11_0);
/**
 The smart insert delete type.
 
 @see [UITextInputTraits smartInsertDeleteType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySmartInsertDeleteType NS_AVAILABLE_IOS(11_0);
/**
 The keyboard type.
 
 @see [UITextInputTraits keyboardType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyKeyboardType;
/**
 The keyboard appearance. This will override the keyboard appearance from [KSOTheme keyboardAppearance].
 
 @see [UITextInputTraits keyboardAppearance]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyKeyboardAppearance;
/**
 The return key type.
 
 @see [UITextInputTraits returnKeyType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyReturnKeyType;
/**
 Whether the return is enabled automatically.
 
 @see [UITextInputTraits enablesReturnKeyAutomatically]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyEnablesReturnKeyAutomatically;
/**
 Whether text entry is secure (e.g. password entry).
 
 @see [UITextInputTraits secureTextEntry]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySecureTextEntry;
/**
 The text content type.
 
 @see [UITextInputTraits textContentType]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyTextContentType;

/**
 The rows to display when pushing from a KSOFormRowTypeOptions row.
 
 @see [KSOFormRow optionRows]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyOptionRows;

#if (!TARGET_OS_TV)
/**
 The picker view columns and rows. Use this to specify multiple columns.
 
 @see [KSOFormRow pickerViewColumnsAndRows]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewColumnsAndRows;
/**
 The picker view rows. Use this to specify a single column.
 
 @see [KSOFormRow pickerViewRows]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewRows;
/**
 The picker view selected components join string.
 
 @see [KDIPickerViewButton selectedComponentsJoinString]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyPickerViewSelectedComponentsJoinString;
#endif

#if (!TARGET_OS_TV)
/**
 The date picker mode.
 
 @see [UIDatePicker datePickerMode]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMode;
/**
 The date picker minimum date.
 
 @see [UIDatePicker minimumDate]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMinimumDate;
/**
 The date picker maximum date.
 
 @see [UIDatePicker maximumDate]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerMaximumDate;
/**
 The date formatter used to format the date picker date for display.
 
 @see [KDIDatePickerButton dateFormatter]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerDateFormatter;
/**
 The date title block used to format the date picker date for display.
 
 @see [KDIDatePickerButton dateTitleBlock]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyDatePickerDateTitleBlock;
#endif

#if (!TARGET_OS_TV)
/**
 The minimum value.
 
 @see [UISlider minimumValue]
 @see [UIStepper minimumValue]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMinimumValue;
/**
 The maximum value.
 
 @see [UISlider maximumValue]
 @see [UIStepper maximumValue]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyMaximumValue;

/**
 The stepper step value.
 
 @see [UIStepper stepValue]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyStepperStepValue;

/**
 The slider minimum value image.
 
 @see [UISlider minimumValueImage]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySliderMinimumValueImage;
/**
 The slider maximum value image.
 
 @see [UISlider maximumValueImage]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySliderMaximumValueImage;
#endif

/**
 The block that should be invoked when the control is tapped (e.g. UIButton tap).
 
 @see KDIUIControlBlock
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyControlBlock;

/**
 The segmented control items. Must conform to KSOFormRowSegmentedItem protocol.
 
 @see KSOFormRowSegmentedItem
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeySegmentedItems;

/**
 The row action.
 
 @see [KSOFormRow action]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyAction;
/**
 The action delegate.
 
 @see KSOFormRowActionDelegate
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionDelegate;
/**
 The KSOFormModel object to assign to the action view controller.
 
 @see KSOFormModel
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionModel;
/**
 The action view controller class.
 
 @see [KSOFormRow actionViewControllerClass]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyActionViewControllerClass;

/**
 The table view cell class.
 
 @see [KSOFormRow cellClass]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellClass;
/**
 The table view cell class bundle, used for cells that should be created from a XIB.
 
 @see [KSOFormRow cellClassBundle]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyCellClassBundle;

/**
 The accessibility label for the image.
 
 @see [UIAccessibility accessibilityLabel]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyImageAccessibilityLabel;
/**
 The accessibility hint for the button.
 
 @see [UIAccessibility accessibilityHint]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyButtonAccessibilityHint;

/**
 Override the theme title color for the row. For example, to color the title blue instead of the default black.
 
 @see [KSOFormRow themeTitleColor]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyThemeTitleColor;
/**
 Override the theme text color for the row. For example, to tint a button red instead of the default blue.
 
 @see [KSOFormRow themeTextColor]
 */
UIKIT_EXTERN KSOFormRowKey const KSOFormRowKeyThemeTextColor;

NS_ASSUME_NONNULL_END

#endif
