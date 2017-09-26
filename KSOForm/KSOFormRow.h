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
#import <KSOTextValidation/KSOTextValidator.h>
#import <KSOTextValidation/KSOTextFormatter.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSOFormRowType) {
    KSOFormRowTypeLabel = 0,
    KSOFormRowTypeText,
    KSOFormRowTypeSwitch,
    KSOFormRowTypePickerView,
    KSOFormRowTypeDatePicker,
    KSOFormRowTypeStepper
};

typedef BOOL(^KSOFormRowShouldChangeValueBlock)(id _Nullable value, NSError **error);
typedef void(^KSOFormRowDidChangeValueBlock)(id _Nullable value);

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
static KSOFormRowKey const KSOFormRowKeyReturnKeyType = @"returnKeyType";
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
// UIStepper
static KSOFormRowKey const KSOFormRowKeyStepperMinimumValue = @"stepperMinimumValue";
static KSOFormRowKey const KSOFormRowKeyStepperMaximumValue = @"stepperMaximumValue";
static KSOFormRowKey const KSOFormRowKeyStepperStepValue = @"stepperStepValue";

@class KSOFormSection;

@interface KSOFormRow : NSObject

@property (readonly,weak,nonatomic) KSOFormSection *section;

@property (readonly,assign,nonatomic) KSOFormRowType type;

@property (readonly,nonatomic,getter=isEditable) BOOL editable;

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
@property (copy,nonatomic,nullable) NSString *placeholder;
@property (strong,nonatomic,nullable) id<KSOTextValidator> textValidator;
@property (strong,nonatomic,nullable) id<KSOTextFormatter> textFormatter;

@property (assign,nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (assign,nonatomic) UITextAutocorrectionType autocorrectionType;
@property (assign,nonatomic) UITextSpellCheckingType spellCheckingType;
@property (assign,nonatomic) UITextSmartQuotesType smartQuotesType NS_AVAILABLE_IOS(11_0);
@property (assign,nonatomic) UITextSmartDashesType smartDashesType NS_AVAILABLE_IOS(11_0);
@property (assign,nonatomic) UITextSmartInsertDeleteType smartInsertDeleteType NS_AVAILABLE_IOS(11_0);
@property (assign,nonatomic) UIKeyboardType keyboardType;
@property (assign,nonatomic) UIReturnKeyType returnKeyType;
@property (assign,nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;
@property (copy,nonatomic) UITextContentType textContentType NS_AVAILABLE_IOS(10_0);

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

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary section:(KSOFormSection *)section NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
