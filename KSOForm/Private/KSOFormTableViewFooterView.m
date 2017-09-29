//
//  KSOFormTableViewFooterView.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/28/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormTableViewFooterView.h"
#import "KSOFormTableViewHeaderFooterTextView.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormTableViewFooterView ()
@property (strong,nonatomic) KSOFormTableViewHeaderFooterTextView *formSectionView;
@end

@implementation KSOFormTableViewFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithReuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setFormSectionView:[[KSOFormTableViewHeaderFooterTextView alloc] initWithFrame:CGRectZero textContainer:nil]];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formTheme),@kstKeypath(self,formSection.footerTitle),@kstKeypath(self,formSection.footerAttributedTitle)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formSection.footerTitle)] ||
                [keyPath isEqualToString:@kstKeypath(self,formSection.footerAttributedTitle)]) {
                
                if (self.formSection.footerAttributedTitle == nil) {
                    [self.formSectionView setText:self.formSection.footerTitle];
                }
                else {
                    [self.formSectionView setAttributedText:self.formSection.footerAttributedTitle];
                }
            }
            
            if (self.formTheme == nil) {
                return;
            }
            
            if ([keyPath isEqualToString:@kstKeypath(self,formTheme)]) {
                if (self.formSection.footerAttributedTitle == nil) {
                    [self.formSectionView setTextColor:self.formTheme.footerTitleColor];
                }
                [self.formSectionView setFont:self.formTheme.footerTitleFont];
                
                if (self.formTheme.footerTitleTextStyle == nil) {
                    [NSObject KDI_unregisterDynamicTypeObject:self.formSectionView];
                }
                else {
                    [NSObject KDI_registerDynamicTypeObject:self.formSectionView forTextStyle:self.formTheme.footerTitleTextStyle];
                }
            }
        });
    }];
    
    return self;
}

@dynamic formSectionView;

@end
