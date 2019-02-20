//
//  KSOFormTableViewHeaderFooterView.m
//  KSOForm-iOS
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

#import "KSOFormTableViewHeaderFooterView.h"

@interface KSOFormTableViewHeaderFooterView ()
@property (copy,nonatomic) NSArray<NSLayoutConstraint *> *activeConstraints;

- (NSArray<NSLayoutConstraint *> *)_constraintsForFormSectionView;
@end

@implementation KSOFormTableViewHeaderFooterView

- (void)updateConstraints {
    [self setActiveConstraints:[self _constraintsForFormSectionView]];
    
    [super updateConstraints];
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self setNeedsUpdateConstraints];
}

- (void)setFormSectionView:(__kindof UIView *)formSectionView {
    _formSectionView = formSectionView;
    
    [_formSectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_formSectionView];
    
    [self setActiveConstraints:[self _constraintsForFormSectionView]];
}

@synthesize formSection=_formSection;
@synthesize formTheme=_formTheme;

- (NSArray<NSLayoutConstraint *> *)_constraintsForFormSectionView; {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:0 metrics:nil views:@{@"view": self.formSectionView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:@{@"top": @(self.layoutMargins.top), @"bottom": @(self.layoutMargins.bottom)} views:@{@"view": self.formSectionView}]];
    
    return constraints;
}

- (void)setActiveConstraints:(NSArray<NSLayoutConstraint *> *)activeConstraints {
    [NSLayoutConstraint deactivateConstraints:_activeConstraints];
    
    _activeConstraints = activeConstraints;
    
    [NSLayoutConstraint activateConstraints:_activeConstraints];
}

@end
