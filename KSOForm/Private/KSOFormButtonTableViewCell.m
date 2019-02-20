//
//  KSOFormButtonTableViewCell.m
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

#import "KSOFormButtonTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormButtonTableViewCell ()
@property (strong,nonatomic) KDIButton *leadingView;
@end

@implementation KSOFormButtonTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[KDIButton buttonWithType:UIButtonTypeSystem]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.leadingView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.leadingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        if (self.formRow.controlBlock != nil) {
            self.formRow.controlBlock(control, controlEvents);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leadingView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.title),@kstKeypath(self,formRow.enabled)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.title)]) {
                [self.leadingView setTitle:self.formRow.title forState:UIControlStateNormal];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setUserInteractionEnabled:self.formRow.isEnabled];
                [self.trailingView setTintColor:self.formRow.isEnabled ? (self.formRow.themeTextColor ?: self.formTheme.textColor) : self.formTheme.valueColor];
            }
        });
    }];
    
    return self;
}
#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.leadingView sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark -
@dynamic leadingView;
- (BOOL)wantsLeadingViewTopBottomLayoutMargins {
    return NO;
}
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setAccessibilityHint:formRow.buttonAccessibilityHint];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView.titleLabel setFont:formTheme.titleFont];
    
    if (formTheme.titleTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.leadingView.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.leadingView.titleLabel forTextStyle:formTheme.titleTextStyle];
    }
    
    if (formTheme.textColor != nil) {
        [self.leadingView setTintColor:formTheme.textColor];
    }
    
    if (self.formRow.themeTextColor != nil) {
        [self.leadingView setTintColor:self.formRow.themeTextColor];
    }
}
@end
