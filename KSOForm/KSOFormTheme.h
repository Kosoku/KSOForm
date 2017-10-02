//
//  KSOFormTheme.h
//  KSOForm-iOS
//
//  Created by William Towe on 9/25/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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
 Enum for possible first responder styles. This affects how first responder status is indicated within the form.
 */
typedef NS_ENUM(NSInteger, KSOFormThemeFirstResponderStyle) {
    /**
     No indication is made (excluding system indicators like keyboard, caret, etc.).
     */
    KSOFormThemeFirstResponderStyleNone = 0,
    /**
     The cells backgroundView is animated to/from firstResponderColor and UIColor.clear.
     */
    KSOFormThemeFirstResponderStyleBackgroundView,
    /**
     The cells title is underlined using firstResponderColor.
     */
    KSOFormThemeFirstResponderStyleUnderlineTitle,
    /**
     A custom view should be provided within the cells contentView that conforms to KSOFormThemeFirstResponderIndicatorView. Its shouldIndicateFirstResponder property will be set appropriately.
     */
    KSOFormThemeFirstResponderStyleCustom
};

/**
 KSOFormTheme controls the appearance of form UI elements. To create your own theme, copy the defaultTheme and modify its properties.
 */
@interface KSOFormTheme : NSObject <NSCopying>

/**
 Set and get the default theme.
 
 The default is an appropriately configured theme.
 */
@property (class,strong,nonatomic,null_resettable) KSOFormTheme *defaultTheme;

/**
 Get the identifier of the receiver. Useful for debugging purposes.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 The header title color, used to display section header text.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *headerTitleColor;
/**
 The footer title color, used to display section footer text.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *footerTitleColor;
/**
 The title color, used to display the title property of KSOFormRow objects.
 
 The default is UIColor.blackColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *titleColor;
/**
 The subtitle color, used to display the subtitle property of KSOFormRow objects.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *subtitleColor;
/**
 The value color, used to display the formatted value of KSOFormRow objects.
 
 The default is UIColor.lightGrayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *valueColor;
/**
 The text color, used to display the value of KSOFormRow objects when it is editable (i.e. inside a control that requires user interaction to change).
 
 The default is nil, which means use the current tintColor.
 */
@property (strong,nonatomic,nullable) UIColor *textColor;
/**
 The text selection color, used to display the caret and selection indicator.
 
 The default is nil, which means use the current tintColor.
 */
@property (strong,nonatomic,nullable) UIColor *textSelectionColor;

/**
 The header title font, used to display section header text.
 
 The default is [UIFont systemFontOfSize:13.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *headerTitleFont;
/**
 The footer title font, used to display section footer text.
 
 The default is [UIFont systemFontOfSize:13.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *footerTitleFont;
/**
 The title font, used to display the title of KSOFormRow objects.
 
 The default is [UIFont systemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *titleFont;
/**
 The subtitle font, used to display the subtitle of KSOFormRow objects.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *subtitleFont;
/**
 The value font, used to display the value of KSOFormRow objects when formatted as text.
 
 The default is [UIFont systemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *valueFont;

/**
 The header title text style. Setting this to non-nil will cause the display to automatically update in response to the user changing their preferred text size in General -> Accessibility -> Larger Text.
 
 The default is UIFontTextStyleFootnote.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle headerTitleTextStyle;
/**
 The footer title text style. Setting this to non-nil will cause the display to automatically update in response to the user changing their preferred text size in General -> Accessibility -> Larger Text.
 
 The default is UIFontTextStyleFootnote.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle footerTitleTextStyle;
/**
 The title text style. Setting this to non-nil will cause the display to automatically update in response to the user changing their preferred text size in General -> Accessibility -> Larger Text.
 
 The default is UIFontTextStyleBody.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle titleTextStyle;
/**
 The subtitle text style. Setting this to non-nil will cause the display to automatically update in response to the user changing their preferred text size in General -> Accessibility -> Larger Text.
 
 The default is UIFontTextStyleCaption1.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle subtitleTextStyle;
/**
 The value text style. Setting this to non-nil will cause the display to automatically update in response to the user changing their preferred text size in General -> Accessibility -> Larger Text.
 
 The default is UIFontTextStyleBody.
 */
@property (copy,nonatomic,nullable) UIFontTextStyle valueTextStyle;

/**
 The keyboard appearance for all text controls in the form. This can be overriden for each KSOFormRow object.
 
 The default is UIKeyboardAppearanceDefault.
 */
@property (assign,nonatomic) UIKeyboardAppearance keyboardAppearance;

/**
 The style used to indicate first responder status.
 
 The default is KSOFormThemeFirstResponderStyleBackgroundView.
 
 @see KSOFormThemeFirstResponderStyle
 */
@property (assign,nonatomic) KSOFormThemeFirstResponderStyle firstResponderStyle;
/**
 The color used to indicate first responder status.
 
 The default is nil, which means use the current tintColor.
 */
@property (strong,nonatomic,nullable) UIColor *firstResponderColor;

/**
 The designated initializer.
 
 @param identifier The unique identifier for the theme
 @return The initialized instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
