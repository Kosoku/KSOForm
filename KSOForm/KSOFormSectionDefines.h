//
//  KSOFormSectionDefines.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/30/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __KSO_FORM_SECTION_DEFINES__
#define __KSO_FORM_SECTION_DEFINES__

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 String type that should be used for keys of a dictionary used to initialize the receiver.
 */
typedef NSString* KSOFormSectionKey NS_EXTENSIBLE_STRING_ENUM;

/**
 The identifier of the section. This allows you to specify a specific identifier to refer to the section later.
 
 @see [KSOFormSection identifier]
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyIdentifier;
/**
 The context associated with the section. This can be any object and is not retained by the section itself.
 
 @see [KSOFormSection context]
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyContext;
/**
 The KSOFormRow objects owned by the receiver. These can be either KSOFormRow objects or NSDictionary objects.
 
 @see rows
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyRows;
/**
 The title of the section header in the UITableView displaying the form.
 
 @see headerTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderTitle;
/**
 The title of the section footer in the UITableView displaying the form.
 
 @see footerTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterTitle;
/**
 The attributed title of the section header in the UITableView displaying the form.
 
 @see headerAttributedTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderAttributedTitle;
/**
 The attributed title of the section footer in the UITableView displaying the form.
 
 @see footerAttributedTitle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterAttributedTitle;
/**
 The custom section header class that should be used for this section.
 
 @see headerViewClass
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderViewClass;
/**
 The custom section header class bundle used to create the header view from a XIB.
 
 @see [KSOFormSection headerViewClassBundle]
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyHeaderViewClassBundle;
/**
 The custom section footer class that should be used for this section.
 
 @see footerViewClass
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterViewClass;
/**
 The custom section footer class bundle that should be used to create the footer view from a XIB.
 
 @see footerViewClassBundle
 */
FOUNDATION_EXTERN KSOFormSectionKey const KSOFormSectionKeyFooterViewClassBundle;

NS_ASSUME_NONNULL_END

#endif
