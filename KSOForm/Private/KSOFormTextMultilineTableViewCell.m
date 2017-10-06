//
//  KSOFormTextMultilineTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/28/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormTextMultilineTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormTextMultilineTableViewCell () <UITextViewDelegate>
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KDITextView *trailingView;

@property (assign,nonatomic) CGFloat height;
@end

@implementation KSOFormTextMultilineTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[[KDITextView alloc] initWithFrame:CGRectZero]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setTextAlignment:NSTextAlignmentRight];
    [self.trailingView setInputAccessoryView:[[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:self.trailingView]];
    [self.trailingView setBackgroundColor:UIColor.clearColor];
    [self.trailingView setDelegate:self];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.trailingView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
- (BOOL)wantsLeadingViewCenteredVertically {
    return NO;
}
- (CGFloat)minimumTrailingViewHeight {
    CGFloat lineHeight = MAX(self.height, ceil(self.trailingView.font.lineHeight));
    CGFloat retval = lineHeight;
    
    if (self.formRow.minimumNumberOfLines > 0) {
        retval = lineHeight * self.formRow.minimumNumberOfLines;
    }
    
    if (self.formRow.maximumNumberOfLines > 0) {
        retval = lineHeight * self.formRow.maximumNumberOfLines;
    }
    
    return retval;
}
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setText:formRow.value];
    [self.trailingView setPlaceholder:formRow.placeholder];
    [self.trailingView setKeyboardType:formRow.keyboardType];
    [self.trailingView setKeyboardAppearance:formRow.keyboardAppearance];
    [self.trailingView setAutocapitalizationType:formRow.autocapitalizationType];
    [self.trailingView setAutocorrectionType:formRow.autocorrectionType];
    [self.trailingView setSpellCheckingType:formRow.spellCheckingType];
    [self.trailingView setSecureTextEntry:formRow.isSecureTextEntry];
    [self.trailingView setTextContentType:formRow.textContentType];
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
    [self.trailingView setKeyboardAppearance:formTheme.keyboardAppearance];
    [self.trailingView setPlaceholderTextColor:formTheme.valueColor];
    
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
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return self.trailingView.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self.trailingView becomeFirstResponder];
}
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.formRow.shouldChangeValueBlock != nil) {
        NSString *value = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSError *outError;
        
        return self.formRow.shouldChangeValueBlock(self.formRow,value,&outError);
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    [self.formRow setValue:self.trailingView.text notify:YES];
    [self setHeight:[textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)].height];
}
#pragma mark *** Private Methods ***
#pragma mark Properties
- (void)setHeight:(CGFloat)height {
    if (_height == height) {
        return;
    }
    
    _height = height;
    
    [self setNeedsUpdateConstraints];
    
    [self.formRow.section.model.tableView beginUpdates];
    [self.formRow.section.model.tableView endUpdates];
    
    [self.trailingView scrollRangeToVisible:self.trailingView.selectedRange];
}
@end
