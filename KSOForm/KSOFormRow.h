//
//  KSOFormRow.h
//  KSOForm-iOS
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
#import <KSOForm/KSOFormRowValueDataSource.h>
#import <KSOForm/KSOFormPickerViewRow.h>
#import <KSOForm/KSOFormRowActionDelegate.h>
#import <KSOTextValidation/KSOTextValidator.h>
#import <KSOTextValidation/KSOTextFormatter.h>
#import <Ditko/UIControl+KDIExtensions.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSOFormRowType) {
    KSOFormRowTypeLabel = 0,
    KSOFormRowTypeText,
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

typedef BOOL(^KSOFormRowShouldChangeValueBlock)(KSOFormRow *row, id _Nullable value, NSError **error);
typedef void(^KSOFormRowDidChangeValueBlock)(KSOFormRow *row, id _Nullable value);

typedef NSString* KSOFormRowKey NS_STRING_ENUM;

// value related
static KSOFormRowKey const KSOFormRowKeyType = @"type";
static KSOFormRowKey const KSOFormRowKeyValue = @"value";
static KSOFormRowKey const KSOFormRowKeyValueKey = @"valueKey";
static KSOFormRowKey const KSOFormRowKeyValueFormatter = @"valueFormatter";
static KSOFormRowKey const KSOFormRowKeyValueDataSource = @"valueDataSource";
static KSOFormRowKey const KSOFormRowKeyValueShouldChangeBlock = @"valueShouldChangeBlock";
static KSOFormRowKey const KSOFormRowKeyValueDidChangeBlock = @"valueDidChangeBlock";
// secondary properties
static KSOFormRowKey const KSOFormRowKeyImage = @"image";
static KSOFormRowKey const KSOFormRowKeyTitle = @"title";
static KSOFormRowKey const KSOFormRowKeySubtitle = @"subtitle";
static KSOFormRowKey const KSOFormRowKeyCellAccessoryType = @"cellAccessoryType";
// text properties
static KSOFormRowKey const KSOFormRowKeyPlaceholder = @"placeholder";
static KSOFormRowKey const KSOFormRowKeyTextValidator = @"textValidator";
static KSOFormRowKey const KSOFormRowKeyTextFormatter = @"textFormatter";
// UITextInputTraits
static KSOFormRowKey const KSOFormRowKeyAutocapitalizationType = @"autocapitalizationType";
static KSOFormRowKey const KSOFormRowKeyAutocorrectionType = @"autocorrectionType";
static KSOFormRowKey const KSOFormRowKeySpellCheckingType = @"spellCheckingType";
static KSOFormRowKey const KSOFormRowKeySmartQuotesType = @"smartQuotesType";
static KSOFormRowKey const KSOFormRowKeySmartDashesType = @"smartDashesType";
static KSOFormRowKey const KSOFormRowKeySmartInsertDeleteType = @"smartInsertDeleteType";
static KSOFormRowKey const KSOFormRowKeyKeyboardType = @"keyboardType";
static KSOFormRowKey const KSOFormRowKeyKeyboardAppearance = @"keyboardAppearance";
static KSOFormRowKey const KSOFormRowKeyReturnKeyType = @"returnKeyType";
static KSOFormRowKey const KSOFormRowKeyEnablesReturnKeyAutomatically = @"enablesReturnKeyAutomatically";
static KSOFormRowKey const KSOFormRowKeySecureTextEntry = @"secureTextEntry";
static KSOFormRowKey const KSOFormRowKeyTextContentType = @"textContentType";
// UIPickerView
static KSOFormRowKey const KSOFormRowKeyPickerViewColumnsAndRows = @"pickerViewColumnsAndRows";
static KSOFormRowKey const KSOFormRowKeyPickerViewRows = @"pickerViewRows";
static KSOFormRowKey const KSOFormRowKeyPickerViewSelectedComponentsJoinString = @"pickerViewSelectedComponentsJoinString";
// UIDatePicker
static KSOFormRowKey const KSOFormRowKeyDatePickerMode = @"datePickerMode";
static KSOFormRowKey const KSOFormRowKeyDatePickerMinimumDate = @"datePickerMinimumDate";
static KSOFormRowKey const KSOFormRowKeyDatePickerMaximumDate = @"datePickerMaximumDate";
static KSOFormRowKey const KSOFormRowKeyDatePickerDateFormatter = @"datePickerDateFormatter";
// UIStepper & UISlider
static KSOFormRowKey const KSOFormRowKeyMinimumValue = @"minimumValue";
static KSOFormRowKey const KSOFormRowKeyMaximumValue = @"maximumValue";
// UIStepper
static KSOFormRowKey const KSOFormRowKeyStepperStepValue = @"stepperStepValue";
// UISlider
static KSOFormRowKey const KSOFormRowKeySliderMinimumValueImage = @"sliderMinimumValueImage";
static KSOFormRowKey const KSOFormRowKeySliderMaximumValueImage = @"sliderMaximumValueImage";
// UIControl (e.g. UIButton)
static KSOFormRowKey const KSOFormRowKeyControlBlock = @"controlBlock";
// UISegmentedControl
static KSOFormRowKey const KSOFormRowKeySegmentedItems = @"segmentedItems";
// present/push support
static KSOFormRowKey const KSOFormRowKeyAction = @"action";
static KSOFormRowKey const KSOFormRowKeyActionDelegate = @"actionDelegate";
static KSOFormRowKey const KSOFormRowKeyActionModel = @"actionModel";
static KSOFormRowKey const KSOFormRowKeyActionViewControllerClass = @"actionViewController";

@class KSOFormSection,KSOFormModel;

@interface KSOFormRow : NSObject <UITextInputTraits>

@property (readonly,weak,nonatomic) KSOFormSection *section;

@property (readonly,copy,nonatomic) NSString *identifier;

@property (readonly,assign,nonatomic) KSOFormRowType type;

@property (readonly,nonatomic,getter=isEditable) BOOL editable;
@property (readonly,nonatomic,getter=isSelectable) BOOL selectable;

@property (strong,nonatomic,nullable) id value;
@property (readonly,nonatomic,nullable) NSString *formattedValue;
@property (copy,nonatomic,nullable) NSString *valueKey;
@property (strong,nonatomic,nullable) __kindof NSFormatter *valueFormatter;
@property (weak,nonatomic,nullable ) NSObject<KSOFormRowValueDataSource> *valueDataSource;
@property (copy,nonatomic,nullable) KSOFormRowShouldChangeValueBlock shouldChangeValueBlock;
@property (copy,nonatomic,nullable) KSOFormRowDidChangeValueBlock didChangeValueBlock;

@property (strong,nonatomic,nullable) UIImage *image;
@property (copy,nonatomic,nullable) NSString *title;
@property (copy,nonatomic,nullable) NSString *subtitle;
@property (assign,nonatomic) KSOFormRowCellAccessoryType cellAccessoryType;

@property (copy,nonatomic,nullable) NSString *placeholder;
@property (strong,nonatomic,nullable) id<KSOTextValidator> textValidator;
// NSFormatter works here as well
@property (strong,nonatomic,nullable) id<KSOTextFormatter> textFormatter;

@property (copy,nonatomic,nullable) NSArray<NSArray<id<KSOFormPickerViewRow> > *> *pickerViewColumnsAndRows;
@property (copy,nonatomic,nullable) NSArray<id<KSOFormPickerViewRow> > *pickerViewRows;
@property (copy,nonatomic,nullable) NSString *pickerViewSelectedComponentsJoinString;

@property (assign,nonatomic) UIDatePickerMode datePickerMode;
@property (copy,nonatomic,nullable) NSDate *datePickerMinimumDate;
@property (copy,nonatomic,nullable) NSDate *datePickerMaximumDate;
@property (strong,nonatomic,nullable) NSDateFormatter *datePickerDateFormatter;

@property (assign,nonatomic) double stepperMinimumValue;
@property (assign,nonatomic) double stepperMaximumValue;
@property (assign,nonatomic) double stepperStepValue;

@property (assign,nonatomic) float sliderMinimumValue;
@property (assign,nonatomic) float sliderMaximumValue;
@property (copy,nonatomic,nullable) UIImage *sliderMinimumValueImage;
@property (copy,nonatomic,nullable) UIImage *sliderMaximumValueImage;

@property (copy,nonatomic,nullable) KDIUIControlBlock controlBlock;
// NSString or UIImage
@property (copy,nonatomic,nullable) NSArray *segmentedItems;

@property (assign,nonatomic) KSOFormRowAction action;
@property (weak,nonatomic,nullable) id<KSOFormRowActionDelegate> actionDelegate;
@property (strong,nonatomic,nullable) KSOFormModel *actionModel;
@property (strong,nonatomic,nullable) Class actionViewControllerClass;

- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary section:(nullable KSOFormSection *)section NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(nullable NSDictionary<NSString *,id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
