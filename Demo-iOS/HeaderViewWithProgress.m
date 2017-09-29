//
//  HeaderViewWithProgress.m
//  Demo-iOS
//
//  Created by William Towe on 9/28/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
