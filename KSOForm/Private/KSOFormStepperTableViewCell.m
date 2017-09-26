//
//  KSOFormStepperTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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
        NSNumber *value = @(self.stepper.value);
        
        [self.formRow setValue:value];
        [self.valueLabel setText:value.stringValue];
    } forControlEvents:UIControlEventValueChanged];
    [self.trailingView addArrangedSubview:self.stepper];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.stepper setValue:[formRow.value doubleValue]];
    [self.valueLabel setText:[formRow.value stringValue]];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.valueLabel setFont:formTheme.valueFont];
    [self.valueLabel setTextColor:formTheme.valueColor];
    
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
