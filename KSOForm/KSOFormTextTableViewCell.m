//
//  KSOFormTextTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/25/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormTextTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormTextTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KDITextField *textField;

@property (copy,nonatomic) NSArray<NSLayoutConstraint *> *activeConstraints;
@end

@implementation KSOFormTextTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    _leadingView = [[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero];
    [_leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_leadingView];
    
    _textField = [[KDITextField alloc] initWithFrame:CGRectZero];
    [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_textField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [_textField setTextAlignment:NSTextAlignmentRight];
    [_textField setInputAccessoryView:[[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:_textField]];
    [_textField KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:self.textField.text];
    } forControlEvents:UIControlEventAllEditingEvents];
    [self.contentView addSubview:_textField];
    
    return self;
}
#pragma mark -
- (BOOL)canBecomeFirstResponder {
    return [self.textField canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [self.textField canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}
#pragma mark -
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    [NSLayoutConstraint deactivateConstraints:self.activeConstraints];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]" options:0 metrics:@{@"left": @(self.layoutMargins.left)} views:@{@"view": self.leadingView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.leadingView}]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-right-|" options:0 metrics:@{@"right": @(self.layoutMargins.right)} views:@{@"view": self.textField, @"subview": self.leadingView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.textField}]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self setActiveConstraints:constraints];
    
    [super updateConstraints];
}
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    [self.textField setText:formRow.value];
    [self.textField setPlaceholder:formRow.placeholder];
    [self.textField setKeyboardType:formRow.keyboardType];
    [self.textField setAutocapitalizationType:formRow.autocapitalizationType];
    [self.textField setAutocorrectionType:formRow.autocorrectionType];
    [self.textField setSpellCheckingType:formRow.spellCheckingType];
    [self.textField setSecureTextEntry:formRow.isSecureTextEntry];
    if (@available(iOS 10.0, *)) {
        [self.textField setTextContentType:formRow.textContentType];
    }
    if (@available(iOS 11.0, *)) {
        [self.textField setSmartQuotesType:formRow.smartQuotesType];
        [self.textField setSmartDashesType:formRow.smartDashesType];
        [self.textField setSmartInsertDeleteType:formRow.smartInsertDeleteType];
    }
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.textField setFont:formTheme.valueFont];
    [self.textField setTextColor:formTheme.textColor ?: self.tintColor];
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.formRow.placeholder attributes:@{NSForegroundColorAttributeName: formTheme.valueColor}]];
    [self.textField setKeyboardAppearance:formTheme.keyboardAppearance];
    
    if (formTheme.textSelectionColor != nil) {
        [self.textField setTintColor:formTheme.textSelectionColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.textField];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.textField forTextStyle:formTheme.valueTextStyle];
    }
}

@end
