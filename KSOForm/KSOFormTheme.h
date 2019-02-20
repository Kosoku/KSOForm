//
//  KSOFormTheme.h
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
 The background color of the form view.
 
 The default is the system default for a grouped table view.
 */
@property (strong,nonatomic,nullable) UIColor *backgroundColor;
/**
 The cell background color for each row in the form.
 
 The default is the system default for a UITableViewCell instance.
 */
@property (strong,nonatomic,nullable) UIColor *cellBackgroundColor;
/**
 The cell selected background color for each row in the form. If this is nil the default UITableViewCell selected style is used with the default background color.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIColor *cellSelectedBackgroundColor;

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
 
 The default is UIColor.darkGrayColor.
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
