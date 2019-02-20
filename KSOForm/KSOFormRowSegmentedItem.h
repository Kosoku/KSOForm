//
//  KSOFormRowSegmentedItem.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/30/17.
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for an object that represents a single item in a UISegmentedControl.
 */
@protocol KSOFormRowSegmentedItem <NSObject>
@optional
/**
 The image for the item.
 
 @warning Either formRowSegmentedItemImage or formRowSegmentedItemTitle must be non-nil
 */
@property (readonly,nonatomic,nullable) UIImage *formRowSegmentedItemImage;
/**
 The title for the item.
 
 @warning Either formRowSegmentedItemImage or formRowSegmentedItemTitle must be non-nil
 */
@property (readonly,nonatomic,nullable) NSString *formRowSegmentedItemTitle;
@end

/**
 Adds support for KSOFormRowSegmentedItem to UIImage.
 */
@interface UIImage (KSOFormRowSegmentedItemExtensions) <KSOFormRowSegmentedItem>
@end

/**
 Adds support for KSOFormRowSegmentedItem to NSString.
 */
@interface NSString (KSOFormRowSegmentedItemExtensions) <KSOFormRowSegmentedItem>
@end

NS_ASSUME_NONNULL_END
