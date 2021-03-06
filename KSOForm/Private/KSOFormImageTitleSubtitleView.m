//
//  KSOFormIconTitleSubtitleView.m
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

#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

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
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
    
    if (_formRow.themeTitleColor != nil) {
        [self.titleLabel setTextColor:_formRow.themeTitleColor];
    }
}
@synthesize formTheme=_formTheme;
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    [self.imageView setTintColor:_formTheme.titleColor];
    
    [self.titleLabel setFont:_formTheme.titleFont];
    if (self.formRow.themeTitleColor == nil) {
        [self.titleLabel setTextColor:_formTheme.titleColor];
    }
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
