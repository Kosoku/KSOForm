//
//  KSOFormTextMultilineTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/28/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
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
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormTextMultilineTableViewCell () <UITextViewDelegate>
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) UIScrollView *trailingView;
@property (strong,nonatomic) KDITextView *textView;
@end

@implementation KSOFormTextMultilineTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    self.trailingView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.trailingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailingView.backgroundColor = UIColor.clearColor;
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.trailingView];
    
    self.textView = [[KDITextView alloc] initWithFrame:CGRectZero];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.textAlignment = NSTextAlignmentRight;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = UIColor.clearColor;
    self.textView.inputAccessoryView = [[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:self.textView];
    self.textView.delegate = self;
    [self.trailingView addSubview:self.textView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.textView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.textView}]];
    [NSLayoutConstraint activateConstraints:@[[self.textView.widthAnchor constraintEqualToAnchor:self.trailingView.widthAnchor]]];
    
    NSLayoutConstraint *height = [self.trailingView.heightAnchor constraintEqualToAnchor:self.textView.heightAnchor];
    
    height.priority = UILayoutPriorityDefaultLow;
    
    [NSLayoutConstraint activateConstraints:@[height]];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled),@kstKeypath(self,formRow.placeholder)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                [self.textView setText:self.formRow.value];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setUserInteractionEnabled:self.formRow.isEnabled];
                [self.textView setUserInteractionEnabled:self.formRow.isEnabled];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.placeholder)]) {
                [self.textView setPlaceholder:self.formRow.placeholder];
            }
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.textView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}
#pragma mark -
- (void)updateConstraints {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    CGFloat lineHeight = ceil(self.textView.font.lineHeight);
    
    if (self.formRow.minimumNumberOfLines > 0) {
        [temp addObject:[self.trailingView.heightAnchor constraintGreaterThanOrEqualToConstant:lineHeight * (CGFloat)self.formRow.minimumNumberOfLines]];
    }
    if (self.formRow.maximumNumberOfLines > 0) {
        [temp addObject:[self.trailingView.heightAnchor constraintLessThanOrEqualToConstant:lineHeight * (CGFloat)self.formRow.maximumNumberOfLines]];
    }
    
    self.trailingView.KDI_customConstraints = temp;
    
    [super updateConstraints];
}

@dynamic leadingView;
@dynamic trailingView;
- (BOOL)wantsLeadingViewCenteredVertically {
    return NO;
}

#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.textView setKeyboardType:formRow.keyboardType];
    [self.textView setKeyboardAppearance:formRow.keyboardAppearance];
    [self.textView setAutocapitalizationType:formRow.autocapitalizationType];
    [self.textView setAutocorrectionType:formRow.autocorrectionType];
    [self.textView setSpellCheckingType:formRow.spellCheckingType];
    [self.textView setSecureTextEntry:formRow.isSecureTextEntry];
    [self.textView setTextContentType:formRow.textContentType];
//    [self.textView setMinimumNumberOfLines:formRow.minimumNumberOfLines];
//    [self.textView setMaximumNumberOfLines:formRow.maximumNumberOfLines];
    if (@available(iOS 11.0, *)) {
        [self.textView setSmartQuotesType:formRow.smartQuotesType];
        [self.textView setSmartDashesType:formRow.smartDashesType];
        [self.textView setSmartInsertDeleteType:formRow.smartInsertDeleteType];
    }
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.textView setFont:formTheme.valueFont];
    [self.textView setTextColor:self.formRow.isEnabled ? (formTheme.textColor ?: self.tintColor) : formTheme.valueColor];
    [self.textView setKeyboardAppearance:formTheme.keyboardAppearance];
    [self.textView setPlaceholderTextColor:formTheme.valueColor];
    
    if (formTheme.textSelectionColor != nil) {
        [self.textView setTintColor:formTheme.textSelectionColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.textView];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.textView forTextStyle:formTheme.valueTextStyle];
    }
}
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return self.textView.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self.textView becomeFirstResponder];
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
    [self.formRow setValue:self.textView.text notify:YES];
    
    [self.formRow reloadHeightAnimated:NO];
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    [self.trailingView scrollRectToVisible:rect animated:NO];
}

@end
