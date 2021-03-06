//
//  KSOFormRow.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>
#import <KSOForm/KSOFormRowDefines.h>
#import <KSOForm/KSOFormRowView.h>
#import <KSOForm/KSOFormRowValueDataSource.h>
#import <KSOForm/KSOFormOptionRow.h>
#import <KSOForm/KSOFormPickerViewRow.h>
#import <KSOForm/KSOFormRowSegmentedItem.h>
#import <KSOForm/KSOFormRowActionDelegate.h>
#import <KSOTextValidation/KSOTextValidator.h>
#import <KSOTextValidation/KSOTextFormatter.h>
#import <Ditko/UIControl+KDIExtensions.h>
#if (!TARGET_OS_TV)
#import <Ditko/KDIDatePickerButton.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class KSOFormSection,KSOFormModel;

/**
 KSOFormRow represents a single row in the form and is owned by a KSOFormSection.
 */
@interface KSOFormRow : NSObject <KSOFormOptionRow, UITextInputTraits>

/**
 The section that owns the receiver.
 
 @see KSOFormSection
 */
@property (readonly,weak,nonatomic) KSOFormSection *section;

/**
 The identifier of the receiver. The identifier is created during initialization and cannot be changed.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Get the context associated with the receiver.
 */
@property (weak,nonatomic,nullable) id context;

/**
 The type of the receiver.
 
 @see KSOFormRowType
 */
@property (readonly,assign,nonatomic) KSOFormRowType type;

/**
 Whether the receiver is enabled. If NO, it will disable any control bound to the receiver (e.g. UISwitch).
 */
@property (assign,nonatomic,getter=isEnabled) BOOL enabled;
/**
 Whether the receiver can be edited by the user.
 */
@property (readonly,nonatomic,getter=isEditable) BOOL editable;
/**
 Whether the receiver can be selected by the user.
 */
@property (readonly,nonatomic,getter=isSelectable) BOOL selectable;
/**
 Whether the receiver is selected.
 */
@property (readonly,nonatomic,getter=isSelected) BOOL selected;

/**
 The value managed by the receiver. Updating this will update any views bound to the receiver.
 */
@property (strong,nonatomic,nullable) id value;
/**
 The formatted value, which will use valueFormatter if non-nil, otherwise returns the description of value.
 */
@property (readonly,nonatomic,nullable) NSString *formattedValue;
/**
 The value key to use when reading and writing the value from the valueDataSource.
 */
@property (copy,nonatomic,nullable) NSString *valueKey;
/**
 The formatter to use to generate formattedValue. This does not format text as the user types, use textFormatter instead.
 */
@property (strong,nonatomic,nullable) __kindof NSFormatter *valueFormatter;
/**
 The transformer to use to generate formattedValue if valueFormatter is nil. This should be used to transform read only values for display. For example, transforming a list of enum values to strings. The transformedValue of the receiver should return an NSString.
 */
@property (strong,nonatomic,nullable) __kindof NSValueTransformer *valueTransformer;
/**
 The value data source used to read and write value.
 */
@property (weak,nonatomic,nullable) NSObject<KSOFormRowValueDataSource> *valueDataSource;
/**
 The block to invoke to accept/reject changes to value.
 */
@property (copy,nonatomic,nullable) KSOFormRowShouldChangeValueBlock shouldChangeValueBlock;
/**
 The block to invoke after value has changed.
 */
@property (copy,nonatomic,nullable) KSOFormRowDidChangeValueBlock didChangeValueBlock;

/**
 Whether the row allows multiple selection.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL allowsMultipleSelection;

/**
 The image, aligned to the leading edge.
 */
@property (strong,nonatomic,nullable) UIImage *image;
/**
 The title, aligned to the trailing edge of image.
 */
@property (copy,nonatomic,nullable) NSString *title;
/**
 The subtitle, aligned to the trailing edge of image, underneath title.
 */
@property (copy,nonatomic,nullable) NSString *subtitle;
/**
 The cell accessory type.
 
 The default is KSOFormRowCellAccessoryTypeAutomatic.
 */
@property (assign,nonatomic) KSOFormRowCellAccessoryType cellAccessoryType;
/**
 The cell trailing view.
 
 The default is nil.
 */
@property (strong,nonatomic) __kindof UIView<KSOFormRowView> *cellTrailingView;
/**
 Whether to center the leading view vertically.
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL wantsLeadingViewCenteredVertically;

/**
 The placeholder text.
 */
@property (copy,nonatomic,nullable) NSString *placeholder;
/**
 The minimum number of lines for multiline text.
 */
@property (assign,nonatomic) NSUInteger minimumNumberOfLines;
/**
 The maximum number of lines for multiline text.
 */
@property (assign,nonatomic) NSUInteger maximumNumberOfLines;
/**
 The text validator for validating value if it is text.
 */
@property (strong,nonatomic,nullable) id<KSOTextValidator> textValidator;
/**
 The text formatter for formatting value if it is text.
 */
@property (strong,nonatomic,nullable) id<KSOTextFormatter> textFormatter;

/**
 The option rows to display when pushing from a KSOFormRowTypeOptions row.
 */
@property (copy,nonatomic,nullable) NSArray<id<KSOFormOptionRow>> *optionRows;

#if (!TARGET_OS_TV)
/**
 The picker view columns and rows.
 */
@property (copy,nonatomic,nullable) NSArray<NSArray<id<KSOFormPickerViewRow> > *> *pickerViewColumnsAndRows;
/**
 The picker view rows. Use this to specify a single column.
 */
@property (copy,nonatomic,nullable) NSArray<id<KSOFormPickerViewRow> > *pickerViewRows;
/**
 The string used to join selected components for display.
 */
@property (copy,nonatomic,nullable) NSString *pickerViewSelectedComponentsJoinString;
#endif

#if (!TARGET_OS_TV)
/**
 The date picker mode.
 */
@property (assign,nonatomic) UIDatePickerMode datePickerMode;
/**
 The date picker minimum date.
 */
@property (copy,nonatomic,nullable) NSDate *datePickerMinimumDate;
/**
 The date picker maximum date.
 */
@property (copy,nonatomic,nullable) NSDate *datePickerMaximumDate;
/**
 The date formatter used to format the date picker date for display.
 */
@property (strong,nonatomic,nullable) NSDateFormatter *datePickerDateFormatter;
/**
 The date title block used to format the date picker date for display. If this block returns nil, it falls back to the formatted date using datePickerDateFormatter.
 
 @see KDIDatePickerButtonDateTitleBlock
 */
@property (copy,nonatomic,nullable) KDIDatePickerButtonDateTitleBlock datePickerDateTitleBlock;
#endif

#if (!TARGET_OS_TV)
/**
 The stepper minimum value.
 */
@property (assign,nonatomic) double stepperMinimumValue;
/**
 The stepper maximum value.
 */
@property (assign,nonatomic) double stepperMaximumValue;
/**
 The stepper step value.
 */
@property (assign,nonatomic) double stepperStepValue;
#endif

#if (!TARGET_OS_TV)
/**
 The slider minimum value.
 */
@property (assign,nonatomic) float sliderMinimumValue;
/**
 The slider maximum value.
 */
@property (assign,nonatomic) float sliderMaximumValue;
/**
 The slider minimum value image.
 */
@property (strong,nonatomic,nullable) UIImage *sliderMinimumValueImage;
/**
 The slider maximun value image.
 */
@property (strong,nonatomic,nullable) UIImage *sliderMaximumValueImage;
#endif

/**
 The block to invoke when a control is tapped (e.g. UIButton).
 */
@property (copy,nonatomic,nullable) KDIUIControlBlock controlBlock;

/**
 The segmented control items.
 */
@property (copy,nonatomic,nullable) NSArray<id<KSOFormRowSegmentedItem> > *segmentedItems;

/**
 The form row action, whether to push or present the new view controller.
 */
@property (assign,nonatomic) KSOFormRowAction action;
/**
 The action delegate that can determine what is pushed or presented.
 */
@property (weak,nonatomic,nullable) id<KSOFormRowActionDelegate> actionDelegate;
/**
 The action model to assign to the new form table view controller.
 */
@property (strong,nonatomic,nullable) KSOFormModel *actionModel;
/**
 The action view controller class to push or present.
 */
@property (strong,nonatomic,nullable) Class actionViewControllerClass;

/**
 The table view cell class to use when displaying the receiver.
 */
@property (strong,nonatomic,nullable) Class cellClass;
/**
 The table view cell class bundle to use for cells that should be created from a XIB.
 */
@property (strong,nonatomic,nullable) NSBundle *cellClassBundle;

/**
 The accessibility label for the image.
 */
@property (copy,nonatomic,nullable) NSString *imageAccessibilityLabel;
/**
 The accessibility hint for the button.
 */
@property (copy,nonatomic,nullable) NSString *buttonAccessibilityHint;

/**
 The theme title color for the row. Overrides the color from the KSOFormTheme.
 */
@property (copy,nonatomic,nullable) UIColor *themeTitleColor;
/**
 The theme text color for the row. Overrides the color from the KSOFormTheme.
 */
@property (copy,nonatomic,nullable) UIColor *themeTextColor;

/**
 The designated initializer. Pass a dictionary using the KSOFormRowKey keys above.
 
 @param dictionary The dictionary used to create the receiver
 @return The initialized instance
 */
- (instancetype)initWithDictionary:(nullable NSDictionary<KSOFormRowKey, id> *)dictionary NS_DESIGNATED_INITIALIZER;

/**
 Convenience initializer that calls initWithDictionary:.
 */
+ (instancetype)formRowWithDictionary:(nullable NSDictionary<KSOFormRowKey, id> *)dictionary;

/**
 Reloads the receiver without animation.
 */
- (void)reload;
/**
 Reloads the receiver with the provided *animation*.
 
 @param animation The animation to use
 */
- (void)reloadWithAnimation:(UITableViewRowAnimation)animation;

/**
 Reloads the height of the row with or without animation.
 
 @param animated Whether to animate the reload
 */
- (void)reloadHeightAnimated:(BOOL)animated;
/**
 Reloads the height of the row with or without animation and invokes completion when the reload is finished.
 
 @param animated Whether to animate the reload
 @param completion The block to invoke when the reload completes
 */
- (void)reloadHeightAnimated:(BOOL)animated completion:(nullable dispatch_block_t)completion;

@end

/**
 Adds support for keyed subscripting to KSFormRow instances. You can set and get their properties like you would an instance of NSDictionary.
 
 For example:
 
     KSFormRow *row = ...;
 
     // set the placeholder
     row[KSOFormRowKeyPlaceholder] = @"Placeholder Text";
 */
@interface KSOFormRow (KSOFormRowKeyedSubscripting)
/**
 Return the value for the provided *key*.
 
 @param key The form row key
 @return The corresponding value for key
 */
- (nullable id)objectForKeyedSubscript:(KSOFormRowKey)key;
/**
 Set the value of *key* to *obj*.
 
 @param obj The obj to set as the value
 @param key The key to use when setting the value
 */
- (void)setObject:(nullable id)obj forKeyedSubscript:(KSOFormRowKey)key;
@end

NS_ASSUME_NONNULL_END
