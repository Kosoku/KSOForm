//
//  KSOFormPickerViewTableViewCell.m
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

#import "KSOFormPickerViewTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOFormPickerViewTableViewCell () <KDIPickerViewButtonDataSource,KDIPickerViewButtonDelegate>
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KDIPickerViewButton *trailingView;
@end

@implementation KSOFormPickerViewTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    [self setTrailingView:[KDIPickerViewButton buttonWithType:UIButtonTypeSystem]];
    [self.trailingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.trailingView setDataSource:self];
    [self.trailingView setDelegate:self];
    [self.contentView addSubview:self.trailingView];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,formRow.value),@kstKeypath(self,formRow.enabled),@kstKeypath(self,formRow.pickerViewColumnsAndRows),@kstKeypath(self,formRow.pickerViewRows)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,formRow.pickerViewColumnsAndRows)] ||
                [keyPath isEqualToString:@kstKeypath(self,formRow.pickerViewRows)]) {
                
                [self.trailingView reloadData];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.enabled)]) {
                [self.trailingView setUserInteractionEnabled:self.formRow.isEnabled];
                [self.trailingView setTintColor:self.formRow.isEnabled ? self.formTheme.textColor : self.formTheme.valueColor];
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,formRow.value)]) {
                if ([self.formRow.value isKindOfClass:NSArray.class]) {
                    [(NSArray *)self.formRow.value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSInteger row = [self.formRow.pickerViewColumnsAndRows[idx] indexOfObject:obj];
                        
                        if (row == NSNotFound) {
                            return;
                        }
                        
                        [self.trailingView selectRow:row inComponent:idx];
                    }];
                }
                else {
                    NSInteger row = [self.formRow.pickerViewRows indexOfObject:self.formRow.value];
                    
                    if (row != NSNotFound) {
                        [self.trailingView selectRow:row inComponent:0];
                    }
                }
            }
        });
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.trailingView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
- (BOOL)wantsTrailingViewTopBottomLayoutMargins {
    return NO;
}
#pragma mark KSOFormRowView
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setSelectedComponentsJoinString:formRow.pickerViewSelectedComponentsJoinString];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    [self.trailingView.titleLabel setFont:formTheme.valueFont];
    
    if (formTheme.textColor != nil) {
        [self.trailingView setTintColor:formTheme.textColor];
    }
    
    if (formTheme.valueTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.trailingView.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.trailingView.titleLabel forTextStyle:formTheme.valueTextStyle];
    }
}
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return self.trailingView.isPresentingPickerView;
}
- (void)beginEditingFormRow {
    [self.trailingView presentPickerView];
}
#pragma mark KDIPickerViewButtonDataSource
- (NSInteger)numberOfComponentsInPickerViewButton:(KDIPickerViewButton *)pickerViewButton {
    return self.formRow.pickerViewColumnsAndRows.count > 0 ? self.formRow.pickerViewColumnsAndRows.count : 1;
}
- (NSInteger)pickerViewButton:(KDIPickerViewButton *)pickerViewButton numberOfRowsInComponent:(NSInteger)component {
    return self.formRow.pickerViewColumnsAndRows.count > 0 ? self.formRow.pickerViewColumnsAndRows[component].count : self.formRow.pickerViewRows.count;
}
- (NSAttributedString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<KSOFormPickerViewRow> pickerViewRow = nil;
    
    if (component < self.formRow.pickerViewColumnsAndRows.count &&
        row < self.formRow.pickerViewColumnsAndRows[component].count) {
        
        pickerViewRow = self.formRow.pickerViewColumnsAndRows[component][row];
    }
    else if (row < self.formRow.pickerViewRows.count) {
        pickerViewRow = self.formRow.pickerViewRows[row];
    }
    
    if (pickerViewRow == nil) {
        return nil;
    }
    
    if (self.formRow.valueFormatter != nil) {
        return [[NSAttributedString alloc] initWithString:[self.formRow.valueFormatter stringForObjectValue:pickerViewRow] ?: @""];
    }
    else if (self.formRow.valueTransformer != nil) {
        return [[NSAttributedString alloc] initWithString:[self.formRow.valueTransformer transformedValue:pickerViewRow] ?: @""];
    }
    else if ([pickerViewRow conformsToProtocol:@protocol(KSOFormPickerViewRow)]) {
        return [pickerViewRow respondsToSelector:@selector(formPickerViewRowAttributedTitle)] ? pickerViewRow.formPickerViewRowAttributedTitle : [[NSAttributedString alloc] initWithString:pickerViewRow.formPickerViewRowTitle ?: @""];
    }
    else {
        return [[NSAttributedString alloc] initWithString:[pickerViewRow description] ?: @""];
    }
}
#pragma mark KDIPickerViewButtonDelegate
- (void)pickerViewButton:(KDIPickerViewButton *)pickerViewButton didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.formRow.pickerViewColumnsAndRows.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.formRow.value];
        id<KSOFormPickerViewRow> pickerViewRow = self.formRow.pickerViewColumnsAndRows[component][row];
        
        if (temp.count <= component) {
            for (NSInteger i=0; i<=component; i++) {
                [temp insertObject:NSNull.null atIndex:i];
            }
        }
        
        [temp replaceObjectAtIndex:component withObject:pickerViewRow];
        
        [self.formRow setValue:[temp copy] notify:YES];
    }
    else {
        [self.formRow setValue:self.formRow.pickerViewRows[row] notify:YES];
    }
}
@end
