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

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormImageTitleSubtitleView ()
@property (strong,nonatomic) UIStackView *verticalStackView, *horizontalStackView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) KDILabel *titleLabel;
@property (strong,nonatomic) KDILabel *subtitleLabel;
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
    [_verticalStackView setSpacing:2.0];
    [_horizontalStackView addArrangedSubview:_verticalStackView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_horizontalStackView insertArrangedSubview:_imageView atIndex:0];
    
    _titleLabel = [[KDILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setBorderWidthRespectsScreenScale:YES];
    [_verticalStackView addArrangedSubview:_titleLabel];
    
    _subtitleLabel = [[KDILabel alloc] initWithFrame:CGRectZero];
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_subtitleLabel setNumberOfLines:0];
    [_verticalStackView addArrangedSubview:_subtitleLabel];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _horizontalStackView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _horizontalStackView}]];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.title),@kstKeypath(self,formRow.subtitle),@kstKeypath(self,formRow.image),@kstKeypath(self,formRow.imageAccessibilityLabel)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.image)]) {
                [self.imageView setImage:self.formRow.image];
                [self.imageView setHidden:self.formRow.image == nil];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.imageAccessibilityLabel)]) {
                [self.imageView setAccessibilityLabel:self.formRow.imageAccessibilityLabel];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.title)]) {
                [self.titleLabel setText:self.formRow.title];
                [self.titleLabel setHidden:self.formRow.title == nil];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.subtitle)]) {
                [self.subtitleLabel setText:self.formRow.subtitle];
                [self.subtitleLabel setHidden:self.formRow.subtitle == nil];
            }
        });
    }];
    
    return self;
}

@synthesize formRow=_formRow;
@synthesize formTheme=_formTheme;
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    [self.titleLabel setFont:_formTheme.titleFont];
    [self.titleLabel setTextColor:_formTheme.titleColor];
    [self.titleLabel setBorderColor:_formTheme.firstResponderColor ?: self.tintColor];
    
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

- (UIView *)leadingSeparatorView {
    return self.titleLabel;
}

@synthesize shouldIndicateFirstResponder=_shouldIndicateFirstResponder;
- (void)setShouldIndicateFirstResponder:(BOOL)shouldIndicateFirstResponder {
    _shouldIndicateFirstResponder = shouldIndicateFirstResponder;
    
    if (_shouldIndicateFirstResponder) {
        [self.titleLabel setBorderOptions:KDIBorderOptionsBottom];
    }
    else {
        [self.titleLabel setBorderOptions:KDIBorderOptionsNone];
    }
}

@end
