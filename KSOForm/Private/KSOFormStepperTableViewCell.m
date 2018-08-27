//
//  KSOFormStepperTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
