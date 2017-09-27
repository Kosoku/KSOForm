//
//  KSOFormRow.m
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

#import "KSOFormRow.h"

#import <Stanley/Stanley.h>

@interface KSOFormRow ()
@property (readwrite,weak,nonatomic) KSOFormSection *section;
@property (readwrite,copy,nonatomic) NSString *identifier;
@property (readwrite,assign,nonatomic) KSOFormRowType type;
@end

@implementation KSOFormRow

+ (BOOL)automaticallyNotifiesObserversOfValue {
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> identifier=%@ title=%@",NSStringFromClass(self.class),self,self.identifier,self.title];
}

- (instancetype)init {
    return [self initWithDictionary:nil section:nil];
}

@synthesize autocapitalizationType=_autocapitalizationType;
@synthesize autocorrectionType=_autocorrectionType;
@synthesize spellCheckingType=_spellCheckingType;
@synthesize smartQuotesType=_smartQuotesType;
@synthesize smartDashesType=_smartDashesType;
@synthesize smartInsertDeleteType=_smartInsertDeleteType;
@synthesize keyboardType=_keyboardType;
@synthesize keyboardAppearance=_keyboardAppearance;
@synthesize returnKeyType=_returnKeyType;
@synthesize enablesReturnKeyAutomatically=_enablesReturnKeyAutomatically;
@synthesize secureTextEntry=_secureTextEntry;
@synthesize textContentType=_textContentType;

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary section:(KSOFormSection *)section {
    if (!(self = [super init]))
        return nil;
    
    _section = section;
    
    _identifier = [[NSUUID UUID] UUIDString];
    
    _type = [dictionary[KSOFormRowKeyType] integerValue];
    
    _value = dictionary[KSOFormRowKeyValue];
    _valueKey = dictionary[KSOFormRowKeyValueKey];
    _valueFormatter = dictionary[KSOFormRowKeyValueFormatter];
    _valueDataSource = dictionary[KSOFormRowKeyValueDataSource];
    _shouldChangeValueBlock = dictionary[KSOFormRowKeyValueShouldChangeBlock];
    _didChangeValueBlock = dictionary[KSOFormRowKeyValueDidChangeBlock];
    
    _image = dictionary[KSOFormRowKeyImage];
    _title = dictionary[KSOFormRowKeyTitle];
    _subtitle = dictionary[KSOFormRowKeySubtitle];
    _cellAccessoryType = dictionary[KSOFormRowKeyCellAccessoryType] == nil ? KSOFormRowCellAccessoryTypeAutomatic : [dictionary[KSOFormRowKeyCellAccessoryType] integerValue];
    
    _placeholder = dictionary[KSOFormRowKeyPlaceholder];
    _textValidator = dictionary[KSOFormRowKeyTextValidator];
    _textFormatter = dictionary[KSOFormRowKeyTextFormatter];
    
    _autocapitalizationType = [dictionary[KSOFormRowKeyAutocapitalizationType] integerValue];
    _autocorrectionType = [dictionary[KSOFormRowKeyAutocorrectionType] integerValue];
    _spellCheckingType = [dictionary[KSOFormRowKeySpellCheckingType] integerValue];
    _smartQuotesType = [dictionary[KSOFormRowKeySmartQuotesType] integerValue];
    _smartDashesType = [dictionary[KSOFormRowKeySmartDashesType] integerValue];
    _smartInsertDeleteType = [dictionary[KSOFormRowKeySmartInsertDeleteType] integerValue];
    _keyboardType = [dictionary[KSOFormRowKeyKeyboardType] integerValue];
    _keyboardAppearance = [dictionary[KSOFormRowKeyKeyboardAppearance] integerValue];
    _returnKeyType = [dictionary[KSOFormRowKeyReturnKeyType] integerValue];
    _enablesReturnKeyAutomatically = [dictionary[KSOFormRowKeyEnablesReturnKeyAutomatically] integerValue];
    _secureTextEntry = [dictionary[KSOFormRowKeySecureTextEntry] boolValue];
    _textContentType = dictionary[KSOFormRowKeyTextContentType];
    
    _pickerViewColumnsAndRows = dictionary[KSOFormRowKeyPickerViewColumnsAndRows];
    _pickerViewRows = dictionary[KSOFormRowKeyPickerViewRows];
    _pickerViewSelectedComponentsJoinString = dictionary[KSOFormRowKeyPickerViewSelectedComponentsJoinString];
    
    _datePickerMode = [dictionary[KSOFormRowKeyDatePickerMode] integerValue];
    _datePickerMinimumDate = dictionary[KSOFormRowKeyDatePickerMinimumDate];
    _datePickerMaximumDate = dictionary[KSOFormRowKeyDatePickerMaximumDate];
    _datePickerDateFormatter = dictionary[KSOFormRowKeyDatePickerDateFormatter];
    
    _stepperMinimumValue = [dictionary[KSOFormRowKeyMinimumValue] doubleValue];
    _stepperMaximumValue = [dictionary[KSOFormRowKeyMaximumValue] doubleValue];
    _stepperStepValue = [dictionary[KSOFormRowKeyStepperStepValue] doubleValue];
    
    _sliderMinimumValue = [dictionary[KSOFormRowKeyMinimumValue] floatValue];
    _sliderMaximumValue = [dictionary[KSOFormRowKeyMaximumValue] floatValue];
    _sliderMinimumValueImage = dictionary[KSOFormRowKeySliderMinimumValueImage];
    _sliderMaximumValueImage = dictionary[KSOFormRowKeySliderMaximumValueImage];
    
    _controlBlock = dictionary[KSOFormRowKeyControlBlock];
    
    _segmentedItems = dictionary[KSOFormRowKeySegmentedItems];
    
    _action = [dictionary[KSOFormRowKeyAction] integerValue];
    _actionDelegate = dictionary[KSOFormRowKeyActionDelegate];
    _actionModel = dictionary[KSOFormRowKeyActionModel];
    _actionViewControllerClass = dictionary[KSOFormRowKeyActionViewControllerClass];
    
    return self;
}
- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary {
    return [self initWithDictionary:dictionary section:nil];
}

- (BOOL)isEditable {
    return (self.type == KSOFormRowTypeText ||
            self.type == KSOFormRowTypeDatePicker ||
            self.type == KSOFormRowTypePickerView);
}
- (BOOL)isSelectable {
    return (self.isEditable || self.cellAccessoryType == KSOFormRowCellAccessoryTypeDisclosureIndicator);
}

@synthesize value=_value;
- (id)value {
    return self.valueKey != nil && self.valueDataSource != nil ? [self.valueDataSource valueForKey:self.valueKey] : _value;;
}
- (void)setValue:(id)value {
    if (self.shouldChangeValueBlock != nil) {
        NSError *outError;
        if (!self.shouldChangeValueBlock(self,value,&outError)) {
            return;
        }
    }
    
    if (self.valueKey != nil &&
        [self.valueDataSource respondsToSelector:@selector(shouldChangeValueBlock)] &&
        self.valueDataSource.shouldChangeValueBlock != nil) {
        
        NSError *outError;
        if (!self.valueDataSource.shouldChangeValueBlock(self,value,&outError)) {
            return;
        }
    }
    
    if ([_value isEqual:value]) {
        return;
    }
    
    [self willChangeValueForKey:@kstKeypath(self,value)];
    
    _value = value;
    
    if (self.valueKey != nil &&
        self.valueDataSource != nil) {
        
        [self.valueDataSource setValue:_value forKey:self.valueKey];
    }
    
    [self didChangeValueForKey:@kstKeypath(self,value)];
    
    if (self.didChangeValueBlock != nil) {
        self.didChangeValueBlock(self,_value);
    }
}
- (NSString *)formattedValue {
    return self.valueFormatter == nil ? [self.value description] : [self.valueFormatter stringForObjectValue:self.value];
}

- (KSOFormRowCellAccessoryType)cellAccessoryType {
    if (_cellAccessoryType == KSOFormRowCellAccessoryTypeAutomatic) {
        if (self.actionDelegate != nil ||
            self.actionModel != nil ||
            self.actionViewControllerClass != Nil) {
            
            return KSOFormRowCellAccessoryTypeDisclosureIndicator;
        }
        return KSOFormRowCellAccessoryTypeNone;
    }
    return _cellAccessoryType;
}

- (double)stepperMaximumValue {
    return _stepperMaximumValue > 0.0 ? _stepperMaximumValue : 1.0;
}
- (double)stepperStepValue {
    return _stepperStepValue > 0.0 ? _stepperStepValue : 1.0;
}

- (float)sliderMaximumValue {
    return _sliderMaximumValue > 0.0 ? _sliderMaximumValue : 1.0;
}

- (KSOFormModel *)actionModel {
    return [self.actionDelegate respondsToSelector:@selector(actionFormModelForFormRow:)] ? [self.actionDelegate actionFormModelForFormRow:self] : _actionModel;
}
- (Class)actionViewControllerClass {
    return [self.actionDelegate respondsToSelector:@selector(actionViewControllerClassForFormRow:)] ? [self.actionDelegate actionViewControllerClassForFormRow:self] : _actionViewControllerClass;
}

@end
