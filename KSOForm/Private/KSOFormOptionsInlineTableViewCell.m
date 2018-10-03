//
//  KSOFormOptionsInlineTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 10/2/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormOptionsInlineTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormTheme.h"
#import "NSBundle+KSOFormExtensions.h"

#import <Agamotto/Agamotto.h>
#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface KSOFormOptionsInlineButton : KDIButton <KDIUIResponder>
@property (readwrite,nonatomic) UIView *inputView;
@property (readwrite,nonatomic) UIView *inputAccessoryView;
@end

@implementation KSOFormOptionsInlineButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    kstWeakify(self);
    [self KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        if (self.isFirstResponder) {
            [self resignFirstResponder];
        }
        else {
            [self becomeFirstResponder];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    [self willChangeValueForKey:@kstKeypath(self,isFirstResponder)];
    
    BOOL retval = [super becomeFirstResponder];
    
    [self didChangeValueForKey:@kstKeypath(self,isFirstResponder)];
    
    [self firstResponderDidChange];
    
    [NSNotificationCenter.defaultCenter postNotificationName:KDIUIResponderNotificationDidBecomeFirstResponder object:self];
    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.inputView);
    
    return retval;
}
- (BOOL)resignFirstResponder {
    [self willChangeValueForKey:@kstKeypath(self,isFirstResponder)];
    
    BOOL retval = [super resignFirstResponder];
    
    [self didChangeValueForKey:@kstKeypath(self,isFirstResponder)];
    
    [self firstResponderDidChange];
    
    [NSNotificationCenter.defaultCenter postNotificationName:KDIUIResponderNotificationDidResignFirstResponder object:self];
    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    
    return retval;
}

- (void)firstResponderDidChange {
    
}

@end

@interface KSOFormOptionRowTableViewCell : KDITableViewCell

@end

@implementation KSOFormOptionRowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    self.backgroundColor = UIColor.clearColor;
    self.showsSelectionUsingAccessoryType = YES;
    
    return self;
}

@end

@interface KSOFormOptionsInlineTableView : UITableView

@end

@implementation KSOFormOptionsInlineTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (!(self = [super initWithFrame:frame style:style]))
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;
    self.separatorColor = KDIColorW(1.0);
    self.estimatedRowHeight = 44.0;
    [self registerClass:KSOFormOptionRowTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormOptionRowTableViewCell.class)];
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * 0.33));
}

@end

@interface KSOFormOptionsInlineTableViewCell () <UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) KSOFormOptionsInlineButton *trailingView;

@property (strong,nonatomic) UITableView *tableView;

@property (readonly,nonatomic) UIBarButtonItem *selectAllBarButtonItem;
@property (readonly,nonatomic) UIBarButtonItem *selectNoneBarButtonItem;

- (NSArray<id<KSOFormOptionRow>> *)_initiallySelectedFormOptionRows;
- (NSArray<id<KSOFormOptionRow>> *)_selectedFormOptionRows;
- (NSString *)_titleForSelectedFormOptionRows:(NSArray<id<KSOFormOptionRow>> *)rows;
- (void)_reloadTableWithSelectedFormOptionRows:(NSArray<id<KSOFormOptionRow>> *)rows;
- (void)_selectAllFormOptionRows;
- (void)_deselectAllFormOptionRows;
@end

@implementation KSOFormOptionsInlineTableViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    self.tableView = [[KSOFormOptionsInlineTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.leadingView = [[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero];
    self.leadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    self.trailingView = [KSOFormOptionsInlineButton buttonWithType:UIButtonTypeSystem];
    self.trailingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailingView.inputView = ({
        UIInputView *retval = [[UIInputView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard];
        
        retval.translatesAutoresizingMaskIntoConstraints = NO;
        retval.allowsSelfSizing = YES;
        [retval addSubview:self.tableView];
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
        
        retval;
    });
    self.trailingView.inputAccessoryView = [[KDINextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero responder:self.trailingView];
    [self.trailingView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.trailingView];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self.trailingView block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}

@dynamic leadingView;
@dynamic trailingView;
- (BOOL)wantsTrailingViewTopBottomLayoutMargins {
    return NO;
}

- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    NSArray *rows = [self  _initiallySelectedFormOptionRows];
    
    [self.trailingView setTitle:[self _titleForSelectedFormOptionRows:rows] forState:UIControlStateNormal];
    [self _reloadTableWithSelectedFormOptionRows:rows];
    
    KDINextPreviousInputAccessoryView *inputAccessoryView = (KDINextPreviousInputAccessoryView *)self.trailingView.inputAccessoryView;
    
    inputAccessoryView.toolbarItems = formRow.allowsMultipleSelection ? @[inputAccessoryView.previousItem, inputAccessoryView.nextItem, [UIBarButtonItem KDI_flexibleSpaceBarButtonItem], self.selectNoneBarButtonItem, self.selectAllBarButtonItem, inputAccessoryView.doneItem] : @[inputAccessoryView.previousItem, inputAccessoryView.nextItem, [UIBarButtonItem KDI_flexibleSpaceBarButtonItem], inputAccessoryView.doneItem];
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
    return self.trailingView.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self.trailingView becomeFirstResponder];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formRow.optionRows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDITableViewCell *retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormOptionRowTableViewCell.class) forIndexPath:indexPath];
    id<KSOFormOptionRow> row = self.formRow.optionRows[indexPath.row];
    
    retval.title = row.formOptionRowTitle;
    retval.icon = [row respondsToSelector:@selector(formOptionRowImage)] ? row.formOptionRowImage : nil;
    retval.subtitle = [row respondsToSelector:@selector(formOptionRowSubtitle)] ? row.formOptionRowSubtitle : nil;
    retval.info = [row respondsToSelector:@selector(formOptionRowInfo)] ? row.formOptionRowInfo : nil;
    
    return retval;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rows = [self _selectedFormOptionRows];
    
    [self.trailingView setTitle:[self _titleForSelectedFormOptionRows:rows] forState:UIControlStateNormal];
    
    [self.formRow setValue:rows notify:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.formRow.allowsMultipleSelection) {
        NSArray *rows = [self _selectedFormOptionRows];
        
        [self.trailingView setTitle:[self _titleForSelectedFormOptionRows:rows] forState:UIControlStateNormal];
        
        [self.formRow setValue:rows notify:YES];
    }
}
#pragma mark *** Private Methods ***
- (NSArray<id<KSOFormOptionRow>> *)_initiallySelectedFormOptionRows; {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    id value = self.formRow.value;
    
    if (!KSTIsEmptyObject(value)) {
        if ([value isKindOfClass:NSArray.class]) {
            [retval addObjectsFromArray:value];
        }
        else {
            [retval addObject:value];
        }
    }
    
    return retval;
}
- (NSArray<id<KSOFormOptionRow>> *)_selectedFormOptionRows; {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSArray *optionRows = self.formRow.optionRows;
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [retval addObject:optionRows[indexPath.row]];
    }
    
    return retval;
}
- (NSString *)_titleForSelectedFormOptionRows:(NSArray<id<KSOFormOptionRow>> *)rows; {
    if (KSTIsEmptyObject(rows)) {
        return NSLocalizedStringWithDefaultValue(@"options-inline.title-empty", nil, NSBundle.KSO_formFrameworkBundle, @"\u2014", @"options inline title empty (em dash)");
    }
    else {
        return [rows componentsJoinedByString:NSLocalizedStringWithDefaultValue(@"options-inline.title-join-string", nil, NSBundle.KSO_formFrameworkBundle, @", ", @"options inline title join string (e.g. x, y, z)")];
    }
}
- (void)_reloadTableWithSelectedFormOptionRows:(NSArray<id<KSOFormOptionRow>> *)rows; {
    [self.tableView reloadData];
    [self.tableView setAllowsMultipleSelection:self.formRow.allowsMultipleSelection];
    
    for (id row in rows) {
        NSInteger index = [self.formRow.optionRows indexOfObject:row];
        
        if (index == NSNotFound) {
            continue;
        }
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
- (void)_selectAllFormOptionRows; {
    for (NSInteger i=0; i<self.formRow.optionRows.count; i++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    NSArray *rows = [self _selectedFormOptionRows];
    
    [self.trailingView setTitle:[self _titleForSelectedFormOptionRows:rows] forState:UIControlStateNormal];
    
    [self.formRow setValue:rows notify:YES];
}
- (void)_deselectAllFormOptionRows; {
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    NSArray *rows = [self _selectedFormOptionRows];
    
    [self.trailingView setTitle:[self _titleForSelectedFormOptionRows:rows] forState:UIControlStateNormal];
    
    [self.formRow setValue:rows notify:YES];
}

- (UIBarButtonItem *)selectAllBarButtonItem {
    kstWeakify(self);
    return [UIBarButtonItem KDI_barButtonItemWithTitle:NSLocalizedStringWithDefaultValue(@"options-inline.select-all", nil, NSBundle.KSO_formFrameworkBundle, @"All", @"options inline select all") style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        [self _selectAllFormOptionRows];
    }];
}
- (UIBarButtonItem *)selectNoneBarButtonItem {
    kstWeakify(self);
    return [UIBarButtonItem KDI_barButtonItemWithTitle:NSLocalizedStringWithDefaultValue(@"options-inline.select-none", nil, NSBundle.KSO_formFrameworkBundle, @"None", @"options inline select none") style:UIBarButtonItemStylePlain block:^(__kindof UIBarButtonItem * _Nonnull barButtonItem) {
        kstStrongify(self);
        [self _deselectAllFormOptionRows];
    }];
}

@end
