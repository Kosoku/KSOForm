//
//  KSOFormIconTitleSubtitleView.m
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

#import "KSOFormImageTitleSubtitleView.h"

#import <Ditko/Ditko.h>

@interface KSOFormImageTitleSubtitleView ()
@property (strong,nonatomic) UIStackView *verticalStackView, *horizontalStackView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *titleLabel, *subtitleLabel;
@end

@implementation KSOFormImageTitleSubtitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _horizontalStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    [_horizontalStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_horizontalStackView setAxis:UILayoutConstraintAxisHorizontal];
    [_horizontalStackView setAlignment:UIStackViewAlignmentCenter];
    [_horizontalStackView setSpacing:8.0];
    [self addSubview:_horizontalStackView];
    
    _verticalStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    [_verticalStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_verticalStackView setAxis:UILayoutConstraintAxisVertical];
    [_verticalStackView setAlignment:UIStackViewAlignmentLeading];
    [_horizontalStackView addArrangedSubview:_verticalStackView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_horizontalStackView insertArrangedSubview:_imageView atIndex:0];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_verticalStackView addArrangedSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_subtitleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [_verticalStackView addArrangedSubview:_subtitleLabel];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _horizontalStackView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _horizontalStackView}]];
    
    return self;
}

@synthesize formRow=_formRow;
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
    
    [self.imageView setImage:_formRow.image];
    [self.imageView setHidden:_formRow.image == nil];
    
    [self.titleLabel setText:_formRow.title];
    [self.titleLabel setHidden:_formRow.title == nil];
    
    [self.subtitleLabel setText:_formRow.subtitle];
    [self.subtitleLabel setHidden:_formRow.subtitle == nil];
}
@synthesize formTheme=_formTheme;
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    [self.titleLabel setFont:_formTheme.titleFont];
    [self.titleLabel setTextColor:_formTheme.titleColor];
    
    [self.subtitleLabel setFont:_formTheme.subtitleFont];
    [self.subtitleLabel setTextColor:_formTheme.subtitleColor];
    
    if (_formTheme.titleTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.titleLabel forTextStyle:_formTheme.titleTextStyle];
    }
    
    if (_formTheme.subtitleTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.subtitleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.subtitleLabel forTextStyle:_formTheme.subtitleTextStyle];
    }
}

@end
