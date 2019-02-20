//
//  KSOFormDatePickerTableViewCell.m
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

#import "KSOFormDatePickerTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormDatePickerTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KDIDatePickerButton *trailingView;
@end

@implementation KSOFormDatePickerTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[KDIDatePickerButton buttonWithType:UIButtonTypeSystem]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:self.trailingView.date notify:YES];
    } forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                [self.trailingView setDate:self.formRow.value];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setUserInteractionEnabled:self.formRow.isEnabled];
                [self.trailingView setTintColor:self.formRow.isEnabled ? self.formTheme.textColor : self.formTheme.valueColor];
            }
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.trailingView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
- (BOOL)wantsTrailingViewTopBottomLayoutMargins {
    return NO;
}
#pragma mark KSOFormRowView
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setMode:formRow.datePickerMode];
    [self.trailingView setMinimumDate:formRow.datePickerMinimumDate];
    [self.trailingView setMaximumDate:formRow.datePickerMaximumDate];
    [self.trailingView setDateFormatter:formRow.datePickerDateFormatter];
    [self.trailingView setDateTitleBlock:formRow.datePickerDateTitleBlock];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    [self.trailingView.titleLabel setFont:formTheme.valueFont];
    
    if (formTheme.textColor != nil) {
        [self.trailingView setTintColor:formTheme.textColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.trailingView.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.trailingView.titleLabel forTextStyle:formTheme.valueTextStyle];
    }
}
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return self.trailingView.isPresentingDatePicker;
}
- (void)beginEditingFormRow {
    [self.trailingView presentDatePicker];
}

@end
