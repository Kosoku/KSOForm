//
//  KSOFormOptionRow.h
//  KSOForm
//
//  Created by William Towe on 10/2/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
