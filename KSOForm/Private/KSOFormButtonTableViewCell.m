//
//  KSOFormButtonTableViewCell.m
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
                [self.trailingView setEnabled:self.formRow.isEnabled];
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
