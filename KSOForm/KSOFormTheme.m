//
//  KSOFormTheme.m
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

#import "KSOFormTheme.h"

#import <Ditko/Ditko.h>

#import <objc/runtime.h>

@interface KSOFormTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIColor *)_defaultHeaderTitleColor;
+ (UIColor *)_defaultFooterTitleColor;
+ (UIColor *)_defaultTitleColor;
+ (UIColor *)_defaultSubtitleColor;
+ (UIColor *)_defaultValueColor;

+ (UIFont *)_defaultHeaderTitleFont;
+ (UIFont *)_defaultFooterTitleFont;
+ (UIFont *)_defaultTitleFont;
+ (UIFont *)_defaultSubtitleFont;
+ (UIFont *)_defaultValueFont;
@end

@implementation KSOFormTheme

- (NSUInteger)hash {
    return self.identifier.hash;
}
- (BOOL)isEqual:(id)object {
    return (self == object ||
            ([object isKindOfClass:KSOFormTheme.class] && [self.identifier isEqualToString:[object identifier]]));
}

- (id)copyWithZone:(NSZone *)zone {
    KSOFormTheme *retval = [[KSOFormTheme alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_backgroundColor = _backgroundColor;
    retval->_cellBackgroundColor = _cellBackgroundColor;
    retval->_cellSelectedBackgroundColor = _cellSelectedBackgroundColor;
    
    retval->_headerTitleColor = _headerTitleColor;
    retval->_footerTitleColor = _footerTitleColor;
    retval->_titleColor = _titleColor;
    retval->_subtitleColor = _subtitleColor;
    retval->_valueColor = _valueColor;
    retval->_textColor = _textColor;
    retval->_textSelectionColor = _textSelectionColor;
    
    retval->_headerTitleFont = _headerTitleFont;
    retval->_footerTitleFont = _footerTitleFont;
    retval->_titleFont =_titleFont;
    retval->_subtitleFont = _subtitleFont;
    retval->_valueFont = _valueFont;
    
    retval->_headerTitleTextStyle = _headerTitleTextStyle;
    retval->_footerTitleTextStyle = _footerTitleTextStyle;
    retval->_titleTextStyle = _titleTextStyle;
    retval->_subtitleTextStyle = _subtitleTextStyle;
    retval->_valueTextStyle = _valueTextStyle;
    
    retval->_keyboardAppearance = _keyboardAppearance;
    
    retval->_firstResponderStyle = _firstResponderStyle;
    retval->_firstResponderColor = _firstResponderColor;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    
    _headerTitleColor = [self.class _defaultHeaderTitleColor];
    _footerTitleColor = [self.class _defaultFooterTitleColor];
    _titleColor = [self.class _defaultTitleColor];
    _subtitleColor = [self.class _defaultSubtitleColor];
    _valueColor = [self.class _defaultValueColor];
    
    _headerTitleFont = [self.class _defaultHeaderTitleFont];
    _footerTitleFont = [self.class _defaultFooterTitleFont];
    _titleFont = [self.class _defaultTitleFont];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _valueFont = [self.class _defaultValueFont];
    
    _headerTitleTextStyle = UIFontTextStyleFootnote;
    _footerTitleTextStyle = UIFontTextStyleFootnote;
    _titleTextStyle = UIFontTextStyleBody;
    _subtitleTextStyle = UIFontTextStyleCaption1;
    _valueTextStyle = UIFontTextStyleBody;
    
    _firstResponderStyle = KSOFormThemeFirstResponderStyleBackgroundView;
    
    return self;
}

static void const *kDefaultThemeKey = &kDefaultThemeKey;
+ (KSOFormTheme *)defaultTheme {
    return objc_getAssociatedObject(self, kDefaultThemeKey) ?: [[KSOFormTheme alloc] initWithIdentifier:@"com.kosoku.ksoform.theme.default"];
}
+ (void)setDefaultTheme:(KSOFormTheme *)defaultTheme {
    objc_setAssociatedObject(self, kDefaultThemeKey, defaultTheme, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHeaderTitleColor:(UIColor *)headerTitleColor {
    _headerTitleColor = headerTitleColor ?: [self.class _defaultHeaderTitleColor];
}
- (void)setFooterTitleColor:(UIColor *)footerTitleColor {
    _footerTitleColor = footerTitleColor ?: [self.class _defaultFooterTitleColor];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor ?: [self.class _defaultTitleColor];
}
- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor ?: [self.class _defaultSubtitleColor];
}
- (void)setValueColor:(UIColor *)valueColor {
    _valueColor = valueColor ?: [self.class _defaultValueColor];
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont {
    _headerTitleFont = headerTitleFont ?: [self.class _defaultHeaderTitleFont];
}
- (void)setFooterTitleFont:(UIFont *)footerTitleFont {
    _footerTitleFont = footerTitleFont ?: [self.class _defaultFooterTitleFont];
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
}
- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subtitleFont = subtitleFont ?: [self.class _defaultSubtitleFont];
}
- (void)setValueFont:(UIFont *)valueFont {
    _valueFont = valueFont ?: [self.class _defaultValueFont];
}

+ (UIColor *)_defaultHeaderTitleColor; {
    return UIColor.grayColor;
}
+ (UIColor *)_defaultFooterTitleColor; {
    return UIColor.grayColor;
}
+ (UIColor *)_defaultTitleColor; {
    return UIColor.blackColor;
}
+ (UIColor *)_defaultSubtitleColor; {
    return UIColor.darkGrayColor;
}
+ (UIColor *)_defaultValueColor; {
    return UIColor.lightGrayColor;
}

+ (UIFont *)_defaultHeaderTitleFont; {
    return [UIFont systemFontOfSize:13.0];
}
+ (UIFont *)_defaultFooterTitleFont; {
    return [UIFont systemFontOfSize:13.0];
}
+ (UIFont *)_defaultTitleFont; {
    return [UIFont systemFontOfSize:17.0];
}
+ (UIFont *)_defaultSubtitleFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIFont *)_defaultValueFont; {
    return [UIFont systemFontOfSize:17.0];
}
@end
