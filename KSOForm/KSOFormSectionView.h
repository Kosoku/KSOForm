//
//  KSOFormSectionView.h
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

#import <KSOForm/KSOFormSection.h>
#import <KSOForm/KSOFormTheme.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for an object that displays a single KSOFormSection object.
 */
@protocol KSOFormSectionView <NSObject>
@required
/**
 The form section to display.
 */
@property (strong,nonatomic,nullable) KSOFormSection *formSection;
@optional
/**
 The form theme to control display.
 */
@property (strong,nonatomic,nullable) KSOFormTheme *formTheme;
@end

NS_ASSUME_NONNULL_END
