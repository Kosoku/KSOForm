//
//  KSOFormSegmentedTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/27/17.
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

#import "KSOFormSegmentedTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormSegmentedTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) UISegmentedControl *trailingView;
@end

@implementation KSOFormSegmentedTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[[UISegmentedControl alloc] initWithFrame:CGRectZero]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setApportionsSegmentWidthsByContent:YES];
    [self.trailingView KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        [self.formRow setValue:@(self.trailingView.selectedSegmentIndex) notify:YES];
    } forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled),@kstKeypath(self,formRow.segmentedItems)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                NSInteger index = [self.formRow.value integerValue];
                
                if (index < self.trailingView.numberOfSegments) {
                    [self.trailingView setSelectedSegmentIndex:index];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setEnabled:self.formRow.isEnabled];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.segmentedItems)]) {
                [self.trailingView removeAllSegments];
                
                [self.formRow.segmentedItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj respondsToSelector:@selector(formRowSegmentedItemImage)]) {
                        [self.trailingView insertSegmentWithImage:[obj formRowSegmentedItemImage] atIndex:idx animated:NO];
                    }
                    else {
                        [self.trailingView insertSegmentWithTitle:self.formRow.valueFormatter == nil ? [obj formRowSegmentedItemTitle] : [self.formRow.valueFormatter stringForObjectValue:obj] atIndex:idx animated:NO];
                    }
                }];
                
                NSInteger index = [self.formRow.value integerValue];
                
                if (index < self.trailingView.numberOfSegments) {
                    [self.trailingView setSelectedSegmentIndex:index];
                }
            }
        });
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    
    [self.trailingView setTitleTextAttributes:@{NSFontAttributeName: formTheme.valueFont} forState:UIControlStateNormal];
    
    if (formTheme.textColor != nil) {
        [self.trailingView setTintColor:formTheme.textColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.trailingView];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.trailingView forTextStyle:formTheme.valueTextStyle];
    }
}
@end
