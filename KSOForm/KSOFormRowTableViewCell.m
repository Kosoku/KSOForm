//
//  KSOFormRowTableViewCell.m
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

#import "KSOFormRowTableViewCell.h"
#import "KSOFormThemeEditingIndicatorView.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

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
            if (self.accessoryView == nil) {
                [self setAccessoryType:(UITableViewCellAccessoryType)self.formRow.cellAccessoryType];
            }
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KSOFormRowViewNotificationDidBeginEditing,KSOFormRowViewNotificationDidEndEditing] object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        if ([[self.contentView KDI_recursiveSubviews] KQS_none:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
            return [notification.object isEqual:object];
        }]) {
            return;
        }
        
        switch (self.formTheme.firstResponderStyle) {
            case KSOFormThemeFirstResponderStyleBackgroundView:
                if ([notification.name isEqualToString:KSOFormRowViewNotificationDidBeginEditing]) {
                    if (self.backgroundView == nil) {
                        [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
                        [self.backgroundView setBackgroundColor:UIColor.clearColor];
                    }
                    
                    [UIView animateWithDuration:KSOFormThemeEditingIndicatorViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.backgroundView setBackgroundColor:self.formTheme.firstResponderColor ?: [self.tintColor colorWithAlphaComponent:0.1]];
                    } completion:nil];
                }
                else {
                    [UIView animateWithDuration:KSOFormThemeEditingIndicatorViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        [self.backgroundView setBackgroundColor:UIColor.clearColor];
                    } completion:nil];
                }
                break;
            case KSOFormThemeFirstResponderStyleUnderlineTitle:
            case KSOFormThemeFirstResponderStyleCustom: {
                UIView<KSOFormThemeEditingIndicatorView> *view = [[self.contentView KDI_recursiveSubviews] KQS_find:^BOOL(__kindof UIView * _Nonnull object, NSInteger index) {
                    return [object conformsToProtocol:@protocol(KSOFormThemeEditingIndicatorView)];
                }];
                
                if ([notification.name isEqualToString:KSOFormRowViewNotificationDidEndEditing]) {
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
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    if (_formTheme.cellBackgroundColor != nil) {
        self.backgroundColor = _formTheme.cellBackgroundColor;
    }
    if (_formTheme.cellSelectedBackgroundColor != nil) {
        self.selectedBackgroundView = ({
            UIView *retval = [[UIView alloc] initWithFrame:CGRectZero];
            
            retval.backgroundColor = _formTheme.cellSelectedBackgroundColor;
            
            retval;
        });
    }
}
- (BOOL)canEditFormRow {
    return NO;
}

@end
