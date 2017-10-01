//
//  KSOFormRowTableViewCell.m
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

#import "KSOFormRowTableViewCell.h"
#import "KSOFormThemeFirstResponderIndicatorView.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@implementation KSOFormRowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;

    kstWeakify(self);
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(>=height@priority)]" options:0 metrics:@{@"height": @44.0, @"priority": @(UILayoutPriorityDefaultHigh)} views:@{@"view": self.contentView}]];

    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.cellAccessoryType)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self setAccessoryType:(UITableViewCellAccessoryType)self.formRow.cellAccessoryType];
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        if ([[self.contentView KDI_recursiveSubviews] KQS_none:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
            return [notification.object isEqual:object];
        }]) {
            return;
        }
        
        switch (self.formTheme.firstResponderStyle) {
            case KSOFormThemeFirstResponderStyleBackgroundView:
                if ([notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder]) {
                    if (self.backgroundView == nil) {
                        [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
                        [self.backgroundView setBackgroundColor:UIColor.clearColor];
                    }
                    
                    [UIView animateWithDuration:KSOFormThemeFirstResponderIndicatorViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.backgroundView setBackgroundColor:self.formTheme.firstResponderColor ?: [self.tintColor colorWithAlphaComponent:0.1]];
                    } completion:nil];
                }
                else {
                    [UIView animateWithDuration:KSOFormThemeFirstResponderIndicatorViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.backgroundView setBackgroundColor:UIColor.clearColor];
                    } completion:nil];
                }
                break;
            case KSOFormThemeFirstResponderStyleUnderlineTitle:
            case KSOFormThemeFirstResponderStyleCustom: {
                UIView<KSOFormThemeFirstResponderIndicatorView> *view = [[self.contentView KDI_recursiveSubviews] KQS_find:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
                    return [object conformsToProtocol:@protocol(KSOFormThemeFirstResponderIndicatorView)];
                }];
                
                if ([notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder]) {
                    [view setShouldIndicateFirstResponder:YES];
                }
                else {
                    [view setShouldIndicateFirstResponder:NO];
                }
            }
                break;
            case KSOFormThemeFirstResponderStyleNone:
                break;
        }
    }];
    
    return self;
}

@synthesize formRow=_formRow;
@synthesize formTheme=_formTheme;

@end
