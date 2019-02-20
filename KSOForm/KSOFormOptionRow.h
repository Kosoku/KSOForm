//
//  KSOFormOptionRow.h
//  KSOForm
//
//  Created by William Towe on 10/2/18.
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
 Protocol describing an object that can be displayed using a KSOFormRowTypeOptions or KSOFormRowTypeOptionsInline row.
 */
@protocol KSOFormOptionRow <NSObject>
@required
/**
 The title of the option row. This will map to the KSOFormRowKeyValue of the pushed row.
 */
@property (readonly,nonatomic) NSString *formOptionRowTitle;
@optional
/**
 The image of the option row. This will map to the KSOFormRowKeyImage of the pushed row.
 */
@property (readonly,nonatomic,nullable) UIImage *formOptionRowImage;
/**
 The subtitle of the option row. This will map to the KSOFormRowKeySubtitle of the pushed row.
 */
@property (readonly,nonatomic,nullable) NSString *formOptionRowSubtitle;
/**
 The info of the option row. This is only applicable when being presented as part of a KSOFormRowTypeOptionsInline row and will be aligned to the trailing edge, centered vertically.
 */
@property (readonly,nonatomic,nullable) NSString *formOptionRowInfo;
@end

/**
 Add support for KSOFormOptionRow to NSString.
 */
@interface NSString (KSOFormOptionRowExtensions) <KSOFormOptionRow>
@end

/**
 Add support for KSOFormOptionRow to NSAttributedString.
 */
@interface NSAttributedString (KSOFormOptionRowExtensions) <KSOFormOptionRow>
@end

/**
 Add support for KSOFormOptionRow to NSURL.
 */
@interface NSURL (KSOFormOptionRowExtensions) <KSOFormOptionRow>
@end

NS_ASSUME_NONNULL_END
