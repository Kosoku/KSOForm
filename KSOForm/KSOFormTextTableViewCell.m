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
@property (strong,nonatomic) KDITextField *trailingView;

@property (copy,nonatomic) NSArray<NSLayoutConstraint *> *activeConstraints;
@end

@implementation KSOFormTextTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[[KDITextField alloc] initWithFrame:CGRectZero]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setTextAlignment:NSTextAlignmentRight];
    [self.trailingView setInputAccessoryView:[[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:self.trailingView]];
    [self.trailingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:self.trailingView.text];
    } forControlEvents:UIControlEventAllEditingEvents];
    [self.contentView addSubview:self.trailingView];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (BOOL)canBecomeFirstResponder {
    return [self.trailingView canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [self.trailingView canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [self.trailingView becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [self.trailingView resignFirstResponder];
}
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    [self.trailingView setText:formRow.value];
    [self.trailingView setPlaceholder:formRow.placeholder];
    [self.trailingView setKeyboardType:formRow.keyboardType];
    [self.trailingView setAutocapitalizationType:formRow.autocapitalizationType];
    [self.trailingView setAutocorrectionType:formRow.autocorrectionType];
    [self.trailingView setSpellCheckingType:formRow.spellCheckingType];
    [self.trailingView setSecureTextEntry:formRow.isSecureTextEntry];
    if (@available(iOS 10.0, *)) {
        [self.trailingView setTextContentType:formRow.textContentType];
    }
    if (@available(iOS 11.0, *)) {
        [self.trailingView setSmartQuotesType:formRow.smartQuotesType];
        [self.trailingView setSmartDashesType:formRow.smartDashesType];
        [self.trailingView setSmartInsertDeleteType:formRow.smartInsertDeleteType];
    }
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.trailingView setFont:formTheme.valueFont];
    [self.trailingView setTextColor:formTheme.textColor ?: self.tintColor];
    [self.trailingView setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.formRow.placeholder attributes:@{NSForegroundColorAttributeName: formTheme.valueColor}]];
    [self.trailingView setKeyboardAppearance:formTheme.keyboardAppearance];
    
    if (formTheme.textSelectionColor != nil) {
        [self.trailingView setTintColor:formTheme.textSelectionColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.trailingView];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.trailingView forTextStyle:formTheme.valueTextStyle];
    }
}

@end
