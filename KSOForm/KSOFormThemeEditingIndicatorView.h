//
//  KSOFormThemeFirstResponderIndicatorView.h
//  KSOForm-iOS
//
//  Created by William Towe on 10/1/17.
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

#import <Foundation/Foundation.h>

/**
 The animation duration you should use when indicating first responder status for the sake of consistency.
 */
FOUNDATION_EXTERN NSTimeInterval const KSOFormThemeEditingIndicatorViewAnimationDuration;

/**
 Protocol for an object (usually a UIView subclass) that indicates first responder status.
 */
@protocol KSOFormThemeEditingIndicatorView <NSObject>
@required
/**
 Set to YES when the receiver should indicate first responder status, otherwise NO.
 */
@property (assign,nonatomic) BOOL shouldIndicateFirstResponder;
@end
