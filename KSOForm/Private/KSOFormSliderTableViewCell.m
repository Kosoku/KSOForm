//
//  KSOFormSliderTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
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

#import "KSOFormSliderTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <Loki/Loki.h>

@interface KSOFormSliderTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) UISlider *trailingView;
@end

@implementation KSOFormSliderTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[[UISlider alloc] initWithFrame:CGRectZero]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:@(self.trailingView.value) notify:YES];
    } forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                [self.trailingView setValue:[self.formRow.value floatValue]];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setEnabled:self.formRow.isEnabled];
            }
        });
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
- (NSNumber *)leadingToTrailingMargin {
    return @32.0;
}
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setMinimumValue:formRow.sliderMinimumValue];
    [self.trailingView setMaximumValue:formRow.sliderMaximumValue];
    [self.trailingView setMinimumValueImage:formRow.sliderMinimumValueImage];
    [self.trailingView setMaximumValueImage:formRow.sliderMaximumValueImage];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    if (formTheme.valueColor != nil) {
        if (self.formRow.sliderMinimumValueImage != nil) {
            [self.trailingView setMinimumValueImage:[self.formRow.sliderMinimumValueImage KLO_imageByTintingWithColor:formTheme.valueColor]];
        }
        if (self.formRow.sliderMaximumValueImage != nil) {
            [self.trailingView setMaximumValueImage:[self.formRow.sliderMaximumValueImage KLO_imageByTintingWithColor:formTheme.valueColor]];
        }
    }
    
    if (formTheme.textColor != nil) {
        [self.trailingView setTintColor:formTheme.textColor];
    }
}
@end
