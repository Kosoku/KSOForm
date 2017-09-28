//
//  KSOFormTableViewController.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOFormTableViewController.h"
#import "KSOFormLabelTableViewCell.h"
#import "KSOFormTextTableViewCell.h"
#import "KSOFormSwitchTableViewCell.h"
#import "KSOFormPickerViewTableViewCell.h"
#import "KSOFormDatePickerTableViewCell.h"
#import "KSOFormStepperTableViewCell.h"
#import "KSOFormSliderTableViewCell.h"
#import "KSOFormButtonTableViewCell.h"
#import "KSOFormSegmentedTableViewCell.h"
#import "KSOFormTableViewHeaderView.h"
#import "KSOFormTableViewFooterView.h"
#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

#import <Ditko/Ditko.h>
#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOFormTableViewController ()

- (void)_KSOFormTableViewControllerInit;
@end

@implementation KSOFormTableViewController
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    [self _KSOFormTableViewControllerInit];
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _KSOFormTableViewControllerInit];
    
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (!(self = [super initWithStyle:style]))
        return nil;
    
    [self _KSOFormTableViewControllerInit];
    
    return self;
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEstimatedRowHeight:44.0];
    [self.tableView registerClass:KSOFormLabelTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormLabelTableViewCell.class)];
    [self.tableView registerClass:KSOFormTextTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormTextTableViewCell.class)];
    [self.tableView registerClass:KSOFormSwitchTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSwitchTableViewCell.class)];
    [self.tableView registerClass:KSOFormPickerViewTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormPickerViewTableViewCell.class)];
    [self.tableView registerClass:KSOFormDatePickerTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormDatePickerTableViewCell.class)];
    [self.tableView registerClass:KSOFormStepperTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormStepperTableViewCell.class)];
    [self.tableView registerClass:KSOFormSliderTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSliderTableViewCell.class)];
    [self.tableView registerClass:KSOFormButtonTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormButtonTableViewCell.class)];
    [self.tableView registerClass:KSOFormSegmentedTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSegmentedTableViewCell.class)];
    
    [self.tableView setEstimatedSectionHeaderHeight:32.0];
    [self.tableView setEstimatedSectionFooterHeight:32.0];
    [self.tableView registerClass:KSOFormTableViewHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(KSOFormTableViewHeaderView.class)];
    [self.tableView registerClass:KSOFormTableViewFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(KSOFormTableViewFooterView.class)];
    
    kstWeakify(self);
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model),@kstKeypath(self,model.title),@kstKeypath(self,model.cellIdentifiersToCellNibs),@kstKeypath(self,model.headerFooterViewIdentifiersToHeaderFooterViewNibs)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([keyPath isEqualToString:@kstKeypath(self,model)]) {
            [self.model setTableView:self.tableView];
            
            [self.tableView reloadData];
            
            [self.tableView setBackgroundView:self.model.backgroundView];
            [self.tableView setTableHeaderView:self.model.headerView];
            [self.tableView setTableFooterView:self.model.footerView];
        }
        else if ([keyPath isEqualToString:@kstKeypath(self,model.title)]) {
            [self setTitle:self.model.title];
        }
        else if ([keyPath isEqualToString:@kstKeypath(self,model.cellIdentifiersToCellNibs)]) {
            [self.model.cellIdentifiersToCellNibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UINib * _Nonnull obj, BOOL * _Nonnull stop) {
                [self.tableView registerNib:obj forCellReuseIdentifier:key];
            }];
        }
        else if ([keyPath isEqualToString:@kstKeypath(self,model.headerFooterViewIdentifiersToHeaderFooterViewNibs)]) {
            [self.model.headerFooterViewIdentifiersToHeaderFooterViewNibs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UINib * _Nonnull obj, BOOL * _Nonnull stop) {
                [self.tableView registerNib:obj forHeaderFooterViewReuseIdentifier:key];
            }];
        }
    }];
    
    [self KAG_addObserverForNotificationNames:@[KDINextPreviousInputAccessoryViewNotificationNext,KDINextPreviousInputAccessoryViewNotificationPrevious] object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        
        UITableViewCell<KSOFormRowView> *cell = [self.tableView.visibleCells KQS_find:^BOOL(__kindof UITableViewCell * _Nonnull object, NSInteger index) {
            return object.isFirstResponder;
        }];
        
        if (cell == nil) {
            return;
        }
        
        NSArray<KSOFormRow *> *formRows = [[self.model.sections KQS_map:^id _Nullable(KSOFormSection * _Nonnull object, NSInteger index) {
            return object.rows;
        }] KQS_flatten];
        NSInteger index = [formRows indexOfObject:cell.formRow];
        KSOFormRow *editableFormRow = nil;
        
        if ([notification.name isEqualToString:KDINextPreviousInputAccessoryViewNotificationNext]) {
            if ((++index) == formRows.count) {
                index = 0;
            }
            
            for (NSInteger i=index; i<formRows.count; i++) {
                if (formRows[i].isEditable) {
                    editableFormRow = formRows[i];
                    break;
                }
            }
            
            if (editableFormRow == nil) {
                for (NSInteger i=0; i<index; i++) {
                    if (formRows[i].isEditable) {
                        editableFormRow = formRows[i];
                        break;
                    }
                }
            }
        }
        else {
            if ((--index) < 0) {
                index = formRows.count - 1;
            }
            
            for (NSInteger i=index; i>=0; i--) {
                if (formRows[i].isEditable) {
                    editableFormRow = formRows[i];
                    break;
                }
            }
            
            if (editableFormRow == nil) {
                for (NSInteger i=formRows.count - 1; i>index; i--) {
                    if (formRows[i].isEditable) {
                        editableFormRow = formRows[i];
                        break;
                    }
                }
            }
        }
        
        if (editableFormRow == nil) {
            return;
        }
        
        NSIndexPath *indexPath = [self.model indexPathForRow:editableFormRow];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        [[self.tableView cellForRowAtIndexPath:indexPath] becomeFirstResponder];
    }];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.sections.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.sections[section].rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSOFormRow *formRow = [self.model rowForIndexPath:indexPath];
    UITableViewCell<KSOFormRowView> *retval = nil;
    
    if (formRow.cellClass != Nil) {
        retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(formRow.cellClass) forIndexPath:indexPath];
        
        if (retval == nil) {
            [tableView registerClass:formRow.cellClass forCellReuseIdentifier:NSStringFromClass(formRow.cellClass)];
            
            retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(formRow.cellClass) forIndexPath:indexPath];
        }
    }
    else if (formRow.cellIdentifier != nil) {
        retval = [tableView dequeueReusableCellWithIdentifier:formRow.cellIdentifier forIndexPath:indexPath];
    }
    else {
        switch (formRow.type) {
            case KSOFormRowTypeLabel:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormLabelTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeText:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormTextTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeSwitch:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormSwitchTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypePickerView:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormPickerViewTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeDatePicker:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormDatePickerTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeStepper:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormStepperTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeSlider:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormSliderTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeButton:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormButtonTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeSegmented:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormSegmentedTableViewCell.class) forIndexPath:indexPath];
                break;
            default:
                break;
        }
    }
    
    NSAssert([retval conformsToProtocol:@protocol(KSOFormRowView)], @"table view cell must conform to KSOFormRowView protocol!");
    
    [retval setFormRow:formRow];
    if ([retval respondsToSelector:@selector(setFormTheme:)]) {
        [retval setFormTheme:self.theme];
    }
    
    return retval;
}
#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSOFormSection *formSection = self.model.sections[section];
    UITableViewHeaderFooterView<KSOFormSectionView> *retval = nil;
    
    if (formSection.wantsHeaderView) {
        if (formSection.headerViewClass != Nil) {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(formSection.headerViewClass)];
            
            if (retval == nil) {
                [self.tableView registerClass:formSection.headerViewClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(formSection.headerViewClass)];
                
                retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(formSection.headerViewClass)];
            }
        }
        else if (formSection.headerViewIdentifier != nil) {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:formSection.headerViewIdentifier];
        }
        else {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(KSOFormTableViewHeaderView.class)];
        }
        
        NSAssert([retval conformsToProtocol:@protocol(KSOFormSectionView)], @"table view header view must conform to KSOFormSectionView protocol!");
        
        [retval setFormSection:formSection];
        if ([retval respondsToSelector:@selector(setFormTheme:)]) {
            [retval setFormTheme:self.theme];
        }
    }
    
    return retval;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KSOFormSection *formSection = self.model.sections[section];
    UITableViewHeaderFooterView<KSOFormSectionView> *retval = nil;
    
    if (formSection.wantsFooterView) {
        if (formSection.footerViewClass != Nil) {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(formSection.footerViewClass)];
            
            if (retval == nil) {
                [self.tableView registerClass:formSection.footerViewClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(formSection.footerViewClass)];
                
                retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(formSection.footerViewClass)];
            }
        }
        else if (formSection.footerViewIdentifier != nil) {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:formSection.footerViewIdentifier];
        }
        else {
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(KSOFormTableViewFooterView.class)];
        }
        
        NSAssert([retval conformsToProtocol:@protocol(KSOFormSectionView)], @"table view footer view must conform to KSOFormSectionView protocol!");
        
        [retval setFormSection:formSection];
        if ([retval respondsToSelector:@selector(setFormTheme:)]) {
            [retval setFormTheme:self.theme];
        }
    }
    
    return retval;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model rowForIndexPath:indexPath].isSelectable;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model rowForIndexPath:indexPath].isSelectable ? indexPath : nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KSOFormRow *formRow = [self.model rowForIndexPath:indexPath];
    UIViewController *viewController = nil;
    
    if (formRow.actionViewControllerClass != Nil) {
        viewController = [[formRow.actionViewControllerClass alloc] initWithNibName:nil bundle:nil];
    }
    else if (formRow.actionModel != nil) {
        viewController = [[KSOFormTableViewController alloc] initWithStyle:self.tableView.style];
        
        [(KSOFormTableViewController *)viewController setTheme:self.theme];
        [(KSOFormTableViewController *)viewController setModel:formRow.actionModel];
    }
    
    if (viewController != nil) {
        switch (formRow.action) {
            case KSOFormRowActionPush:
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            case KSOFormRowActionPresent:
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                break;
            default:
                break;
        }
    }
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setTheme:(KSOFormTheme *)theme {
    _theme = theme ?: KSOFormTheme.defaultTheme;
}
#pragma mark *** Private Methods ***
- (void)_KSOFormTableViewControllerInit; {
    _theme = KSOFormTheme.defaultTheme;
}

@end
