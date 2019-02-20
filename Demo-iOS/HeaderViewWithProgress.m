//
//  HeaderViewWithProgress.m
//  Demo-iOS
//
//  Created by William Towe on 9/28/17.
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

#import "HeaderViewWithProgress.h"

#import <Ditko/Ditko.h>

@interface HeaderViewWithProgress ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;

@property (copy,nonatomic) NSArray<NSLayoutConstraint *> *activeConstraints;

- (NSArray<NSLayoutConstraint *> *)_constraintsForContentViews;
@end

@implementation HeaderViewWithProgress

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithReuseIdentifier:reuseIdentifier]))
        return nil;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
    [self.contentView addSubview:_titleLabel];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_indicatorView];
    
    [self setActiveConstraints:[self _constraintsForContentViews]];
    
    return self;
}

- (void)updateConstraints {
    [self setActiveConstraints:[self _constraintsForContentViews]];
    
    [super updateConstraints];
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self setNeedsUpdateConstraints];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window == nil) {
        [self.indicatorView stopAnimating];
    }
    else {
        [self.indicatorView startAnimating];
    }
}

@synthesize formSection=_formSection;
- (void)setFormSection:(KSOFormSection *)formSection {
    _formSection = formSection;
    
    [self.titleLabel setText:_formSection.headerTitle.uppercaseString];
}
@synthesize formTheme=_formTheme;
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    [self.titleLabel setTextColor:_formTheme.headerTitleColor];
    [self.titleLabel setFont:_formTheme.headerTitleFont];
    
    if (_formTheme.headerTitleTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.titleLabel forTextStyle:_formTheme.headerTitleTextStyle];
    }
}

- (NSArray<NSLayoutConstraint *> *)_constraintsForContentViews; {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view]" options:0 metrics:@{@"left": @(self.layoutMargins.left)} views:@{@"view": self.titleLabel}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.titleLabel}]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]->=right-|" options:0 metrics:@{@"right": @(self.layoutMargins.right)} views:@{@"view": self.indicatorView, @"subview": self.titleLabel}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.indicatorView}]];
    
    return constraints;
}

- (void)setActiveConstraints:(NSArray<NSLayoutConstraint *> *)activeConstraints {
    [NSLayoutConstraint deactivateConstraints:_activeConstraints];
    
    _activeConstraints = activeConstraints;
    
    [NSLayoutConstraint activateConstraints:_activeConstraints];
}

@end
