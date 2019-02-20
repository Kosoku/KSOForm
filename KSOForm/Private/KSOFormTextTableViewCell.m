//
//  KSOFormTextTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/25/17.
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

#import "KSOFormTextTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOTextValidation/KSOTextValidation.h>

@interface KSOFormTextTableViewCell () <UITextFieldDelegate>
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KDITextField *trailingView;
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
#if (!TARGET_OS_TV)
    [self.trailingView setInputAccessoryView:[[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:self.trailingView]];
#endif
    [self.trailingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:self.trailingView.text notify:YES];
    } forControlEvents:UIControlEventAllEditingEvents];
    [self.trailingView setDelegate:self];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled),@kstKeypath(self,formRow.placeholder)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                [self.trailingView setText:self.formRow.value];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setEnabled:self.formRow.isEnabled];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.placeholder)]) {
                [self.trailingView setPlaceholder:self.formRow.placeholder];
            }
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.trailingView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}
#pragma mark -
- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self.trailingView setRightViewEdgeInsets:UIEdgeInsetsMake(0, ceil(self.layoutMargins.right * 0.5), 0, 0)];
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setKeyboardType:formRow.keyboardType];
    [self.trailingView setKeyboardAppearance:formRow.keyboardAppearance];
    [self.trailingView setAutocapitalizationType:formRow.autocapitalizationType];
    [self.trailingView setAutocorrectionType:formRow.autocorrectionType];
    [self.trailingView setSpellCheckingType:formRow.spellCheckingType];
    [self.trailingView setSecureTextEntry:formRow.isSecureTextEntry];
    [self.trailingView setTextContentType:formRow.textContentType];
    if (@available(iOS 11.0, tvOS 11.0, *)) {
        [self.trailingView setSmartQuotesType:formRow.smartQuotesType];
        [self.trailingView setSmartDashesType:formRow.smartDashesType];
        [self.trailingView setSmartInsertDeleteType:formRow.smartInsertDeleteType];
    }
    
    [self.trailingView setKSO_textValidator:formRow.textValidator];
    [self.trailingView setKSO_textFormatter:formRow.textFormatter];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.trailingView setFont:formTheme.valueFont];
    [self.trailingView setTextColor:self.formRow.isEnabled ? (formTheme.textColor ?: self.tintColor) : formTheme.valueColor];
    [self.trailingView setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.formRow.placeholder ?: @"" attributes:@{NSForegroundColorAttributeName: formTheme.valueColor}]];
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
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return self.trailingView.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self.trailingView becomeFirstResponder];
    [self.trailingView selectAll:nil];
}
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.formRow.shouldChangeValueBlock != nil) {
        NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSError *outError;
        
        return self.formRow.shouldChangeValueBlock(self.formRow,value,&outError);
    }
    return YES;
}

@end
