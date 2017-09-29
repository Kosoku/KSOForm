//
//  KSOFormLeadingTrailingTableViewCell.m
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

#import "KSOFormLeadingTrailingTableViewCell.h"

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
    
    if (self.trailingView == nil) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]-right-|" options:0 metrics:@{@"left": @(self.layoutMargins.left), @"right": @(self.layoutMargins.right)} views:@{@"view": self.leadingView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.leadingView}]];
    }
    else {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]" options:0 metrics:@{@"left": @(self.layoutMargins.left)} views:@{@"view": self.leadingView}]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.leadingView}]];
        
        NSNumber *right = @(self.layoutMargins.right);
        
        if (self.accessoryType != UITableViewCellAccessoryNone) {
            right = @0.0;
        }
        
        NSNumber *top = @(self.layoutMargins.top);
        NSNumber *bottom = @(self.layoutMargins.bottom);
        
        if (!self.trailingViewWantsTopBottomLayoutMargins) {
            top = @0.0;
            bottom = @0.0;
        }
        
        if (self.leadingToTrailingMargin == nil) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-right-|" options:0 metrics:@{@"right": right} views:@{@"view": self.trailingView, @"subview": self.leadingView}]];
        }
        else {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-margin-[view]-right-|" options:0 metrics:@{@"right": right, @"margin": self.leadingToTrailingMargin} views:@{@"view": self.trailingView, @"subview": self.leadingView}]];
        }
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=top-[view]->=bottom-|" options:0 metrics:@{@"top": top, @"bottom": bottom} views:@{@"view": self.trailingView}]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.trailingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        if (self.minimumTrailingViewHeight > 0.0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:self.trailingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.minimumTrailingViewHeight]];
            [constraints.lastObject setPriority:UILayoutPriorityDefaultHigh];
        }
    }
    
    if (self.wantsLeadingViewCenteredVertically) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self setActiveConstraints:constraints];
    
    [super updateConstraints];
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self setNeedsUpdateConstraints];
}

- (BOOL)wantsLeadingViewCenteredVertically {
    return YES;
}
- (NSNumber *)leadingToTrailingMargin {
    return nil;
}
- (BOOL)trailingViewWantsTopBottomLayoutMargins {
    return YES;
}
- (CGFloat)minimumTrailingViewHeight {
    return 0.0;
}

@end
