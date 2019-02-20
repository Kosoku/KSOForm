//
//  KSOFormSectionDefines.h
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
