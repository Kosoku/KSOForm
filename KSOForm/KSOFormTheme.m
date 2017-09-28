//
//  KSOFormTheme.m
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

#import "KSOFormTheme.h"

#import <Ditko/Ditko.h>

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
    
    _headerTitleTextStyle = UIFontTextStyleCaption1;
    _footerTitleTextStyle = UIFontTextStyleCaption1;
    _titleTextStyle = UIFontTextStyleBody;
    _subtitleTextStyle = UIFontTextStyleFootnote;
    _valueTextStyle = UIFontTextStyleBody;
    
    return self;
}

+ (KSOFormTheme *)defaultTheme {
    return [[KSOFormTheme alloc] initWithIdentifier:@"com.kosoku.ksoform.theme.default"];
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
    return UIColor.blackColor;
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
    return [UIFont systemFontOfSize:13.0];
}
+ (UIFont *)_defaultValueFont; {
    return [UIFont systemFontOfSize:17.0];
}
@end
