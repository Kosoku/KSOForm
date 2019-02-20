//
//  KSOFormStepperTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
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

#import "KSOFormStepperTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormStepperTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) UIStackView *trailingView;
@property (strong,nonatomic) UILabel *valueLabel;
@property (strong,nonatomic) UIStepper *stepper;
@end

@implementation KSOFormStepperTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[[UIStackView alloc] initWithFrame:CGRectZero]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setAlignment:UIStackViewAlignmentCenter];
    [self.trailingView setSpacing:8.0];
    [self.contentView addSubview:self.trailingView];
    
    [self setValueLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.valueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView addArrangedSubview:self.valueLabel];
    
    [self setStepper:[[UIStepper alloc] initWithFrame:CGRectZero]];
    [self.stepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.stepper KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:@(self.stepper.value) notify:YES];
        [self.valueLabel setText:self.formRow.formattedValue];
    } forControlEvents:UIControlEventValueChanged];
    [self.trailingView addArrangedSubview:self.stepper];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                [self.stepper setValue:[self.formRow.value doubleValue]];
                [self.valueLabel setText:self.formRow.formattedValue];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.stepper setEnabled:self.formRow.isEnabled];
            }
        });
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.stepper setMinimumValue:formRow.stepperMinimumValue];
    [self.stepper setMaximumValue:formRow.stepperMaximumValue];
    [self.stepper setStepValue:formRow.stepperStepValue];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.valueLabel setFont:formTheme.valueFont];
    [self.valueLabel setTextColor:formTheme.textColor ?: self.tintColor];
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.valueLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.valueLabel forTextStyle:formTheme.valueTextStyle];
    }
    
    if (formTheme.textColor != nil) {
        [self.stepper setTintColor:formTheme.textColor];
    }
}
@end
