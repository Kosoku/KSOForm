//
//  KSOFormPickerViewRow.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
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

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for an object that represents a single row within a UIPickerView.
 */
@protocol KSOFormPickerViewRow <NSObject>
@optional
/**
 The title for the picker view row.
 */
@property (readonly,nonatomic) NSString *formPickerViewRowTitle;
/**
 The attributed title for the picker view row. If this is implemented, it is preferred over formPickerViewRowTitle.
 */
@property (readonly,nonatomic) NSAttributedString *formPickerViewRowAttributedTitle;
@end

/**
 Adds support for KSOFormPickerViewRow to NSString.
 */
@interface NSString (KSOFormPickerViewRowExtensions) <KSOFormPickerViewRow>
@end

/**
 Adds support for KSOFormPickerViewRow to NSAttributedString.
 */
@interface NSAttributedString (KSOFormPickerViewRowExtensions) <KSOFormPickerViewRow>
@end

NS_ASSUME_NONNULL_END

