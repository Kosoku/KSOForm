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
#import <KSOForm/KSOFormRowDefines.h>
#import <KSOForm/KSOFormRowValueDataSource.h>
#import <KSOForm/KSOFormPickerViewRow.h>
#import <KSOForm/KSOFormRowSegmentedItem.h>
#import <KSOForm/KSOFormRowActionDelegate.h>
#import <KSOTextValidation/KSOTextValidator.h>
#import <KSOTextValidation/KSOTextFormatter.h>
#import <Ditko/UIControl+KDIExtensions.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOFormSection,KSOFormModel;

@interface KSOFormRow : NSObject <UITextInputTraits>

@property (readonly,weak,nonatomic) KSOFormSection *section;

@property (readonly,copy,nonatomic) NSString *identifier;

@property (readonly,assign,nonatomic) KSOFormRowType type;

@property (assign,nonatomic,getter=isEnabled) BOOL enabled;
@property (readonly,nonatomic,getter=isEditable) BOOL editable;
@property (readonly,nonatomic,getter=isSelectable) BOOL selectable;
@property (readonly,nonatomic,getter=isSelected) BOOL selected;

@property (strong,nonatomic,nullable) id value;
@property (readonly,nonatomic,nullable) NSString *formattedValue;
@property (copy,nonatomic,nullable) NSString *valueKey;
// this only formats read only value, to format as the user types, use textFormatter property
@property (strong,nonatomic,nullable) __kindof NSFormatter *valueFormatter;
@property (weak,nonatomic,nullable) NSObject<KSOFormRowValueDataSource> *valueDataSource;
@property (copy,nonatomic,nullable) KSOFormRowShouldChangeValueBlock shouldChangeValueBlock;
@property (copy,nonatomic,nullable) KSOFormRowDidChangeValueBlock didChangeValueBlock;

@property (strong,nonatomic,nullable) UIImage *image;
@property (copy,nonatomic,nullable) NSString *title;
@property (copy,nonatomic,nullable) NSString *subtitle;
@property (assign,nonatomic) KSOFormRowCellAccessoryType cellAccessoryType;

@property (copy,nonatomic,nullable) NSString *placeholder;
@property (assign,nonatomic) NSUInteger minimumNumberOfLines;
@property (assign,nonatomic) NSUInteger maximumNumberOfLines;
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
@property (strong,nonatomic,nullable) UIImage *sliderMinimumValueImage;
@property (strong,nonatomic,nullable) UIImage *sliderMaximumValueImage;

@property (copy,nonatomic,nullable) KDIUIControlBlock controlBlock;
@property (copy,nonatomic,nullable) NSArray<id<KSOFormRowSegmentedItem> > *segmentedItems;

@property (assign,nonatomic) KSOFormRowAction action;
@property (weak,nonatomic,nullable) id<KSOFormRowActionDelegate> actionDelegate;
@property (strong,nonatomic,nullable) KSOFormModel *actionModel;
@property (strong,nonatomic,nullable) Class actionViewControllerClass;

@property (strong,nonatomic,nullable) Class cellClass;
@property (copy,nonatomic,nullable) NSString *cellIdentifier;
@property (copy,nonatomic,nullable) NSString *headerFooterViewIdentifier;

@property (copy,nonatomic,nullable) NSString *imageAccessibilityLabel;
@property (copy,nonatomic,nullable) NSString *buttonAccessibilityHint;

- (instancetype)initWithDictionary:(nullable NSDictionary<KSOFormRowKey, id> *)dictionary NS_DESIGNATED_INITIALIZER;

@end

@interface KSOFormRow (KSOFormRowKeyedSubscripting)
- (nullable id)objectForKeyedSubscript:(KSOFormRowKey)key;
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormRowKey)key;
@end

NS_ASSUME_NONNULL_END
