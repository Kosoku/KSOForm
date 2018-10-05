//
//  KSOFormRow.m
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

#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "NSBundle+KSOFormExtensions.h"

#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>
#import <Ditko/Ditko.h>

KSOFormRowKey const KSOFormRowKeyIdentifier = @"identifier";
KSOFormRowKey const KSOFormRowKeyContext = @"context";
KSOFormRowKey const KSOFormRowKeyType = @"type";
KSOFormRowKey const KSOFormRowKeyEnabled = @"enabled";
KSOFormRowKey const KSOFormRowKeyValue = @"value";
KSOFormRowKey const KSOFormRowKeyValueKey = @"valueKey";
KSOFormRowKey const KSOFormRowKeyValueFormatter = @"valueFormatter";
KSOFormRowKey const KSOFormRowKeyValueTransformer = @"valueTransformer";
KSOFormRowKey const KSOFormRowKeyValueDataSource = @"valueDataSource";
KSOFormRowKey const KSOFormRowKeyValueShouldChangeBlock = @"valueShouldChangeBlock";
KSOFormRowKey const KSOFormRowKeyValueDidChangeBlock = @"valueDidChangeBlock";

KSOFormRowKey const KSOFormRowKeyAllowsMultipleSelection = @"allowsMultipleSelection";

KSOFormRowKey const KSOFormRowKeyImage = @"image";
KSOFormRowKey const KSOFormRowKeyTitle = @"title";
KSOFormRowKey const KSOFormRowKeySubtitle = @"subtitle";
KSOFormRowKey const KSOFormRowKeyCellAccessoryType = @"cellAccessoryType";
KSOFormRowKey const KSOFormRowKeyCellTrailingView = @"cellTrailingView";
KSOFormRowKey const KSOFormRowKeyCellWantsLeadingViewCenteredVertically = @"wantsLeadingViewCenteredVertically";

KSOFormRowKey const KSOFormRowKeyPlaceholder = @"placeholder";
KSOFormRowKey const KSOFormRowKeyMinimumNumberOfLines = @"minimumNumberOfLines";
KSOFormRowKey const KSOFormRowKeyMaximumNumberOfLines = @"maximumNumberOfLines";
KSOFormRowKey const KSOFormRowKeyTextValidator = @"textValidator";
KSOFormRowKey const KSOFormRowKeyTextFormatter = @"textFormatter";

KSOFormRowKey const KSOFormRowKeyAutocapitalizationType = @"autocapitalizationType";
KSOFormRowKey const KSOFormRowKeyAutocorrectionType = @"autocorrectionType";
KSOFormRowKey const KSOFormRowKeySpellCheckingType = @"spellCheckingType";
KSOFormRowKey const KSOFormRowKeySmartQuotesType = @"smartQuotesType";
KSOFormRowKey const KSOFormRowKeySmartDashesType = @"smartDashesType";
KSOFormRowKey const KSOFormRowKeySmartInsertDeleteType = @"smartInsertDeleteType";
KSOFormRowKey const KSOFormRowKeyKeyboardType = @"keyboardType";
KSOFormRowKey const KSOFormRowKeyKeyboardAppearance = @"keyboardAppearance";
KSOFormRowKey const KSOFormRowKeyReturnKeyType = @"returnKeyType";
KSOFormRowKey const KSOFormRowKeyEnablesReturnKeyAutomatically = @"enablesReturnKeyAutomatically";
KSOFormRowKey const KSOFormRowKeySecureTextEntry = @"secureTextEntry";
KSOFormRowKey const KSOFormRowKeyTextContentType = @"textContentType";

KSOFormRowKey const KSOFormRowKeyOptionRows = @"optionRows";

KSOFormRowKey const KSOFormRowKeyPickerViewColumnsAndRows = @"pickerViewColumnsAndRows";
KSOFormRowKey const KSOFormRowKeyPickerViewRows = @"pickerViewRows";
KSOFormRowKey const KSOFormRowKeyPickerViewSelectedComponentsJoinString = @"pickerViewSelectedComponentsJoinString";

KSOFormRowKey const KSOFormRowKeyDatePickerMode = @"datePickerMode";
KSOFormRowKey const KSOFormRowKeyDatePickerMinimumDate = @"datePickerMinimumDate";
KSOFormRowKey const KSOFormRowKeyDatePickerMaximumDate = @"datePickerMaximumDate";
KSOFormRowKey const KSOFormRowKeyDatePickerDateFormatter = @"datePickerDateFormatter";
KSOFormRowKey const KSOFormRowKeyDatePickerDateTitleBlock = @"datePickerDateTitleBlock";

KSOFormRowKey const KSOFormRowKeyMinimumValue = @"minimumValue";
KSOFormRowKey const KSOFormRowKeyMaximumValue = @"maximumValue";

KSOFormRowKey const KSOFormRowKeyStepperStepValue = @"stepperStepValue";

KSOFormRowKey const KSOFormRowKeySliderMinimumValueImage = @"sliderMinimumValueImage";
KSOFormRowKey const KSOFormRowKeySliderMaximumValueImage = @"sliderMaximumValueImage";

KSOFormRowKey const KSOFormRowKeyControlBlock = @"controlBlock";

KSOFormRowKey const KSOFormRowKeySegmentedItems = @"segmentedItems";

KSOFormRowKey const KSOFormRowKeyAction = @"action";
KSOFormRowKey const KSOFormRowKeyActionDelegate = @"actionDelegate";
KSOFormRowKey const KSOFormRowKeyActionModel = @"actionModel";
KSOFormRowKey const KSOFormRowKeyActionViewControllerClass = @"actionViewControllerClass";

KSOFormRowKey const KSOFormRowKeyCellClass = @"cellClass";
KSOFormRowKey const KSOFormRowKeyCellClassBundle = @"cellClassBundle";

KSOFormRowKey const KSOFormRowKeyImageAccessibilityLabel = @"imageAccessibilityLabel";
KSOFormRowKey const KSOFormRowKeyButtonAccessibilityHint = @"buttonAccessibilityHint";

KSOFormRowKey const KSOFormRowKeyThemeTitleColor = @"themeTitleColor";
KSOFormRowKey const KSOFormRowKeyThemeTextColor = @"themeTextColor";

@interface KSOFormRow ()
@property (readwrite,weak,nonatomic) KSOFormSection *section;
@property (readwrite,copy,nonatomic) NSString *identifier;
@property (readwrite,assign,nonatomic) KSOFormRowType type;
@end

@implementation KSOFormRow

+ (BOOL)automaticallyNotifiesObserversOfValue {
    return NO;
}
+ (NSSet<NSString *> *)keyPathsForValuesAffectingCellAccessoryType {
    return [NSSet setWithArray:@[@kstKeypath(KSOFormRow.new,value),@kstKeypath(KSOFormRow.new,isSelected)]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> identifier=%@ title=%@",NSStringFromClass(self.class),self,self.identifier,self.title];
}

- (instancetype)init {
    return [self initWithDictionary:nil];
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

- (instancetype)initWithDictionary:(NSDictionary<KSOFormRowKey, id> *)dictionary {
    if (!(self = [super init]))
        return nil;
    
    _identifier = dictionary[KSOFormRowKeyIdentifier] ?: [[NSUUID UUID] UUIDString];
    
    _context = dictionary[KSOFormRowKeyContext];
    
    _type = [dictionary[KSOFormRowKeyType] integerValue];
    
    _enabled = dictionary[KSOFormRowKeyEnabled] == nil ? YES : [dictionary[KSOFormRowKeyEnabled] boolValue];
    
    _value = dictionary[KSOFormRowKeyValue];
    _valueKey = dictionary[KSOFormRowKeyValueKey];
    _valueFormatter = dictionary[KSOFormRowKeyValueFormatter];
    _valueTransformer = dictionary[KSOFormRowKeyValueTransformer];
    _valueDataSource = dictionary[KSOFormRowKeyValueDataSource];
    _shouldChangeValueBlock = dictionary[KSOFormRowKeyValueShouldChangeBlock];
    _didChangeValueBlock = dictionary[KSOFormRowKeyValueDidChangeBlock];
    
    _allowsMultipleSelection = dictionary[KSOFormRowKeyAllowsMultipleSelection] == nil ? YES : [dictionary[KSOFormRowKeyAllowsMultipleSelection] boolValue];
    
    _image = dictionary[KSOFormRowKeyImage];
    _title = dictionary[KSOFormRowKeyTitle];
    _subtitle = dictionary[KSOFormRowKeySubtitle];
    _cellAccessoryType = dictionary[KSOFormRowKeyCellAccessoryType] == nil ? KSOFormRowCellAccessoryTypeAutomatic : [dictionary[KSOFormRowKeyCellAccessoryType] integerValue];
    _cellTrailingView = dictionary[KSOFormRowKeyCellTrailingView];
    _wantsLeadingViewCenteredVertically = dictionary[KSOFormRowKeyCellWantsLeadingViewCenteredVertically] == nil ? YES :[dictionary[KSOFormRowKeyCellWantsLeadingViewCenteredVertically] boolValue];
    
    _placeholder = dictionary[KSOFormRowKeyPlaceholder];
    _minimumNumberOfLines = [dictionary[KSOFormRowKeyMinimumNumberOfLines] unsignedIntegerValue];
    _maximumNumberOfLines = [dictionary[KSOFormRowKeyMaximumNumberOfLines] unsignedIntegerValue];
    _textValidator = dictionary[KSOFormRowKeyTextValidator];
    _textFormatter = dictionary[KSOFormRowKeyTextFormatter];
    
    _autocapitalizationType = [dictionary[KSOFormRowKeyAutocapitalizationType] integerValue];
    _autocorrectionType = [dictionary[KSOFormRowKeyAutocorrectionType] integerValue];
    _spellCheckingType = [dictionary[KSOFormRowKeySpellCheckingType] integerValue];
    if (@available(iOS 11.0, tvOS 11.0, *)) {
        _smartQuotesType = [dictionary[KSOFormRowKeySmartQuotesType] integerValue];
        _smartDashesType = [dictionary[KSOFormRowKeySmartDashesType] integerValue];
        _smartInsertDeleteType = [dictionary[KSOFormRowKeySmartInsertDeleteType] integerValue];
    }
    _keyboardType = [dictionary[KSOFormRowKeyKeyboardType] integerValue];
    _keyboardAppearance = [dictionary[KSOFormRowKeyKeyboardAppearance] integerValue];
    _returnKeyType = [dictionary[KSOFormRowKeyReturnKeyType] integerValue];
    _enablesReturnKeyAutomatically = [dictionary[KSOFormRowKeyEnablesReturnKeyAutomatically] integerValue];
    _secureTextEntry = [dictionary[KSOFormRowKeySecureTextEntry] boolValue];
    _textContentType = dictionary[KSOFormRowKeyTextContentType];
    
    _optionRows = dictionary[KSOFormRowKeyOptionRows];
    
#if (!TARGET_OS_TV)
    _pickerViewColumnsAndRows = dictionary[KSOFormRowKeyPickerViewColumnsAndRows];
    _pickerViewRows = dictionary[KSOFormRowKeyPickerViewRows];
    _pickerViewSelectedComponentsJoinString = dictionary[KSOFormRowKeyPickerViewSelectedComponentsJoinString];
    
    _datePickerMode = [dictionary[KSOFormRowKeyDatePickerMode] integerValue];
    _datePickerMinimumDate = dictionary[KSOFormRowKeyDatePickerMinimumDate];
    _datePickerMaximumDate = dictionary[KSOFormRowKeyDatePickerMaximumDate];
    _datePickerDateFormatter = dictionary[KSOFormRowKeyDatePickerDateFormatter];
    _datePickerDateTitleBlock = dictionary[KSOFormRowKeyDatePickerDateTitleBlock];
    
    _stepperMinimumValue = [dictionary[KSOFormRowKeyMinimumValue] doubleValue];
    _stepperMaximumValue = [dictionary[KSOFormRowKeyMaximumValue] doubleValue];
    _stepperStepValue = [dictionary[KSOFormRowKeyStepperStepValue] doubleValue];
    
    _sliderMinimumValue = [dictionary[KSOFormRowKeyMinimumValue] floatValue];
    _sliderMaximumValue = [dictionary[KSOFormRowKeyMaximumValue] floatValue];
    _sliderMinimumValueImage = dictionary[KSOFormRowKeySliderMinimumValueImage];
    _sliderMaximumValueImage = dictionary[KSOFormRowKeySliderMaximumValueImage];
#endif
    
    _controlBlock = dictionary[KSOFormRowKeyControlBlock];
    
    _segmentedItems = dictionary[KSOFormRowKeySegmentedItems];
    
    _action = [dictionary[KSOFormRowKeyAction] integerValue];
    _actionDelegate = dictionary[KSOFormRowKeyActionDelegate];
    _actionModel = dictionary[KSOFormRowKeyActionModel];
    _actionViewControllerClass = dictionary[KSOFormRowKeyActionViewControllerClass];
    
    _cellClass = dictionary[KSOFormRowKeyCellClass];
    _cellClassBundle = dictionary[KSOFormRowKeyCellClassBundle];
    
    _imageAccessibilityLabel = dictionary[KSOFormRowKeyImageAccessibilityLabel];
    _buttonAccessibilityHint = dictionary[KSOFormRowKeyButtonAccessibilityHint];
    
    _themeTitleColor = dictionary[KSOFormRowKeyThemeTitleColor];
    _themeTextColor = dictionary[KSOFormRowKeyThemeTextColor];
    
    return self;
}

+ (instancetype)formRowWithDictionary:(NSDictionary<KSOFormRowKey,id> *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (void)reload; {
    [self reloadWithAnimation:UITableViewRowAnimationNone];
}
- (void)reloadWithAnimation:(UITableViewRowAnimation)animation; {
    [self.section reloadRow:self animation:animation];
}

- (void)reloadHeightAnimated:(BOOL)animated; {
    [self reloadHeightAnimated:animated completion:nil];
}
- (void)reloadHeightAnimated:(BOOL)animated completion:(dispatch_block_t)completion {
    [self.section.model.tableView KDI_reloadHeightAnimated:animated block:nil completion:completion];
}

- (BOOL)isEditable {
    return (self.isEnabled &&
            (self.type == KSOFormRowTypeText ||
#if (!TARGET_OS_TV)
             self.type == KSOFormRowTypeTextMultiline ||
             self.type == KSOFormRowTypeDatePicker ||
             self.type == KSOFormRowTypePickerView ||
             self.type == KSOFormRowTypeOptionsInline ||
#endif
             ([self.cellTrailingView respondsToSelector:@selector(canEditFormRow)] &&
              self.cellTrailingView.canEditFormRow)));
}
- (BOOL)isSelectable {
    return (self.isEditable ||
            (self.isEnabled &&
             (self.cellAccessoryType == KSOFormRowCellAccessoryTypeDisclosureIndicator ||
              self.section.model.parentFormRow.type == KSOFormRowTypeOptions)));
}
- (BOOL)isSelected {
    if (self.section.model.parentFormRow.type == KSOFormRowTypeOptions) {
        id value = self.section.model.parentFormRow.value;
        
        if (!KSTIsEmptyObject(value)) {
            if ([value isKindOfClass:NSArray.class]) {
                return [value containsObject:self.context];
            }
            else {
                return [value isEqual:self.context];
            }
        }
    }
    return NO;
}

@synthesize value=_value;
- (id)value {
    return self.valueKey != nil && self.valueDataSource != nil ? [self.valueDataSource valueForKey:self.valueKey] : _value;;
}
- (void)setValue:(id)value {
    [self setValue:value notify:NO];
}
- (void)setValue:(id)value notify:(BOOL)notify; {
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
        self.valueDataSource != nil &&
        [self.valueDataSource respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[self.valueKey substringToIndex:1].uppercaseString,[self.valueKey substringFromIndex:1]])]) {
        
        [self.valueDataSource setValue:_value forKey:self.valueKey];
    }
    
    [self didChangeValueForKey:@kstKeypath(self,value)];
    
    if (self.type == KSOFormRowTypeOptions) {
        for (KSOFormRow *row in self.actionModel.sections.firstObject.rows) {
            [row willChangeValueForKey:@kstKeypath(row,isSelected)];
            [row didChangeValueForKey:@kstKeypath(row,isSelected)];
        }
    }
    
    if (notify) {
        if (self.didChangeValueBlock != nil) {
            self.didChangeValueBlock(self,_value);
        }
    }
}

- (NSString *)formattedValue {
    if (self.valueFormatter != nil) {
        return [self.valueFormatter stringForObjectValue:self.value];
    }
    else if (self.valueTransformer != nil) {
        return [self.valueTransformer transformedValue:self.value];
    }
    else {
        id value = self.value;
        
        if ([value isKindOfClass:NSArray.class]) {
            return [[value KQS_map:^id _Nullable(id  _Nonnull object, NSInteger index) {
                if ([object conformsToProtocol:@protocol(KSOFormOptionRow)]) {
                    return [object formOptionRowTitle];
                }
                else if ([object conformsToProtocol:@protocol(KSOFormPickerViewRow)]) {
                    return [object formPickerViewRowTitle];
                }
                else if ([object conformsToProtocol:@protocol(KSOFormRowSegmentedItem)]) {
                    return [object formRowSegmentedItemTitle];
                }
                return object;
            }] componentsJoinedByString:NSLocalizedStringWithDefaultValue(@"row.value.join-string", nil, NSBundle.KSO_formFrameworkBundle, @", ", @"row value join string (e.g. x, y, z)")];
        }
        return [value description];
    }
}

- (KSOFormRowCellAccessoryType)cellAccessoryType {
    if (_cellAccessoryType == KSOFormRowCellAccessoryTypeAutomatic) {
        if (self.isEnabled &&
            (self.type == KSOFormRowTypeOptions ||
             self.actionDelegate != nil ||
             self.actionModel != nil ||
             self.actionViewControllerClass != Nil)) {
            
            return KSOFormRowCellAccessoryTypeDisclosureIndicator;
        }
        else if (self.isSelected) {
            return KSOFormRowCellAccessoryTypeCheckmark;
        }
        return KSOFormRowCellAccessoryTypeNone;
    }
    return _cellAccessoryType;
}

#if (!TARGET_OS_TV)
- (double)stepperMaximumValue {
    return _stepperMaximumValue > 0.0 ? _stepperMaximumValue : 1.0;
}
- (double)stepperStepValue {
    return _stepperStepValue > 0.0 ? _stepperStepValue : 1.0;
}

- (float)sliderMaximumValue {
    return _sliderMaximumValue > 0.0 ? _sliderMaximumValue : 1.0;
}
#endif

- (KSOFormModel *)actionModel {
    if (self.type == KSOFormRowTypeOptions &&
        self.isEnabled &&
        _actionModel == nil) {
        
        _actionModel = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyRows: [self.optionRows KQS_map:^id _Nullable(id<KSOFormOptionRow>  _Nonnull object, NSInteger index) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{KSOFormRowKeyTitle: object.formOptionRowTitle, KSOFormRowKeyContext: object}];
            
            if ([object respondsToSelector:@selector(formOptionRowImage)]) {
                id value = object.formOptionRowImage;
                
                if (value != nil) {
                    dict[KSOFormRowKeyImage] = value;
                }
            }
            if ([object respondsToSelector:@selector(formOptionRowSubtitle)]) {
                id value = object.formOptionRowSubtitle;
                
                if (value != nil) {
                    dict[KSOFormRowKeySubtitle] = value;
                }
            }
            
            return [[KSOFormRow alloc] initWithDictionary:dict];
        }], KSOFormModelKeyTitle: self.title}];
        [_actionModel setParentFormRow:self];
    }
    return [self.actionDelegate respondsToSelector:@selector(actionFormModelForFormRow:)] ? [self.actionDelegate actionFormModelForFormRow:self] : _actionModel;
}
- (Class)actionViewControllerClass {
    return [self.actionDelegate respondsToSelector:@selector(actionViewControllerClassForFormRow:)] ? [self.actionDelegate actionViewControllerClassForFormRow:self] : _actionViewControllerClass;
}

@end

@implementation KSOFormRow (KSOFormRowKeyedSubscripting)
- (id)objectForKeyedSubscript:(KSOFormRowKey)key; {
    return [self valueForKey:key];
}
- (void)setObject:(id)obj forKeyedSubscript:(KSOFormRowKey)key; {
    [self setValue:obj forKey:key];
}
@end
