//
//  KSOFormTableViewFooterView.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/28/17.
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
                if (self.formSection.footerAttributedTitle == nil ||
                    [self.formSection.footerAttributedTitle attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL] == nil) {
                    
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
