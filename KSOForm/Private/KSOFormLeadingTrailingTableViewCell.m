//
//  KSOFormLeadingTrailingTableViewCell.m
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

#import "KSOFormLeadingTrailingTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormLeadingTrailingTableViewCell ()
@property (copy,nonatomic) NSArray<NSLayoutConstraint *> *activeConstraints;
@end

@implementation KSOFormLeadingTrailingTableViewCell

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)updateConstraints {
    NSAssert(self.leadingView != nil, @"leadingView cannot be nil!");
    
    [NSLayoutConstraint deactivateConstraints:self.activeConstraints];
    
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    
    NSNumber *leadingTop = @(self.layoutMargins.top);
    NSNumber *leadingBottom = @(self.layoutMargins.bottom);
    
    if (!self.wantsLeadingViewTopBottomLayoutMargins) {
        leadingTop = @0.0;
        leadingBottom = @0.0;
    }
    
    if (self.trailingView == nil) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.leadingView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": leadingTop, @"bottom": leadingBottom} views:@{@"view": self.leadingView}]];
    }
    else {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.leadingView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": leadingTop, @"bottom": leadingBottom} views:@{@"view": self.leadingView}]];
        
        NSNumber *right = @(self.layoutMargins.right);
        
        if (self.accessoryType != UITableViewCellAccessoryNone ||
            self.accessoryView != nil) {
            
            right = @0.0;
        }
        
        NSNumber *trailingTop = @(self.layoutMargins.top);
        NSNumber *trailingBottom = @(self.layoutMargins.bottom);
        
        if (!self.wantsTrailingViewTopBottomLayoutMargins) {
            trailingTop = @0.0;
            trailingBottom = @0.0;
        }
        
        if (self.leadingToTrailingMargin == nil) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-|" options:0 metrics:@{@"right": right} views:@{@"view": self.trailingView, @"subview": self.leadingView}]];
        }
        else {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-margin-[view]-|" options:0 metrics:@{@"right": right, @"margin": self.leadingToTrailingMargin} views:@{@"view": self.trailingView, @"subview": self.leadingView}]];
        }
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": trailingTop, @"bottom": trailingBottom} views:@{@"view": self.trailingView}]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.trailingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        if (self.minimumTrailingViewHeight > 0.0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:self.trailingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.minimumTrailingViewHeight]];
            [constraints.lastObject setPriority:UILayoutPriorityDefaultHigh];
        }
    }
    
    if (self.wantsLeadingViewCenteredVertically) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    NSArray *customLayoutConstraints = self.customLayoutConstraints;
    
    if (!KSTIsEmptyObject(customLayoutConstraints)) {
        [constraints addObjectsFromArray:customLayoutConstraints];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self setActiveConstraints:constraints];
    
    [super updateConstraints];
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self setNeedsUpdateConstraints];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
#if (!TARGET_OS_TV)
    UIView *view = self.leadingView.leadingSeparatorView;
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetMinX([self convertRect:view.bounds fromView:view]), 0, 0)];
#endif
}

- (BOOL)wantsLeadingViewCenteredVertically {
    return YES;
}
- (NSNumber *)leadingToTrailingMargin {
    return nil;
}
- (BOOL)wantsLeadingViewTopBottomLayoutMargins {
    return YES;
}
- (BOOL)wantsTrailingViewTopBottomLayoutMargins {
    return YES;
}
- (CGFloat)minimumTrailingViewHeight {
    return 0.0;
}
- (NSArray<NSLayoutConstraint *> *)customLayoutConstraints {
    return nil;
}

@end
