//
//  KSOFormPickerViewTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/26/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormPickerViewTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"

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
    
    return self;
}
#pragma mark -
- (BOOL)canBecomeFirstResponder {
    return [self.trailingView canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [self.trailingView canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [self.trailingView becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [self.trailingView resignFirstResponder];
}
#pragma mark -
@dynamic leadingView;
@dynamic trailingView;
#pragma mark -
- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self.trailingView setSelectedComponentsJoinString:formRow.pickerViewSelectedComponentsJoinString];
    [self.trailingView reloadData];
    
    if ([formRow.value isKindOfClass:NSArray.class] &&
        [(NSArray *)formRow.value KQS_all:^BOOL(id  _Nonnull object, NSInteger index) {
        return [object conformsToProtocol:@protocol(KSOFormPickerViewRow)];
    }]) {
        [(NSArray *)formRow.value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger row = [formRow.pickerViewColumnsAndRows[idx] indexOfObject:obj];
            
            if (row == NSNotFound) {
                return;
            }
            
            [self.trailingView selectRow:row inComponent:idx];
        }];
    }
    else if ([formRow.value conformsToProtocol:@protocol(KSOFormPickerViewRow)]) {
        NSInteger row = [formRow.pickerViewRows indexOfObject:formRow.value];
        
        if (row != NSNotFound) {
            [self.trailingView selectRow:row inComponent:0];
        }
    }
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
#pragma mark KDIPickerViewButtonDataSource
- (NSInteger)numberOfComponentsInPickerViewButton:(KDIPickerViewButton *)pickerViewButton {
    return self.formRow.pickerViewColumnsAndRows.count > 0 ? self.formRow.pickerViewColumnsAndRows.count : 1;
}
- (NSInteger)pickerViewButton:(KDIPickerViewButton *)pickerViewButton numberOfRowsInComponent:(NSInteger)component {
    return self.formRow.pickerViewColumnsAndRows.count > 0 ? self.formRow.pickerViewColumnsAndRows[component].count : self.formRow.pickerViewRows.count;
}
- (NSString *)pickerViewButton:(KDIPickerViewButton *)pickerViewButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<KSOFormPickerViewRow> pickerViewRow = self.formRow.pickerViewColumnsAndRows.count > 0 ? self.formRow.pickerViewColumnsAndRows[component][row] : self.formRow.pickerViewRows[row];
    
    return pickerViewRow.formPickerViewRowTitle;
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
        
        [self.formRow setValue:[temp copy]];
    }
    else {
        [self.formRow setValue:self.formRow.pickerViewRows[row]];
    }
}
@end
