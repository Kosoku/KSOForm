//
//  KSOFormLeadingTrailingTableViewCell.h
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

#import "KSOFormRowTableViewCell.h"
#import "KSOFormLeadingView.h"

@interface KSOFormLeadingTrailingTableViewCell : KSOFormRowTableViewCell

@property (strong,nonatomic) __kindof UIView<KSOFormLeadingView> *leadingView;
@property (strong,nonatomic) __kindof UIView *trailingView;

@property (readonly,nonatomic) BOOL wantsLeadingViewCenteredVertically;
@property (readonly,nonatomic) NSNumber *leadingToTrailingMargin;
@property (readonly,nonatomic) BOOL wantsLeadingViewTopBottomLayoutMargins;
@property (readonly,nonatomic) BOOL wantsTrailingViewTopBottomLayoutMargins;
@property (readonly,nonatomic) CGFloat minimumTrailingViewHeight;
@property (readonly,nonatomic) NSArray<NSLayoutConstraint *> *customLayoutConstraints;

@end
