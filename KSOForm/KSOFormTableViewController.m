//
//  KSOFormTableViewController.m
//  KSOForm-iOS
//
//  Created by William Towe on 9/24/17.
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

#import "KSOFormTableViewController.h"
#import "KSOFormCustomTrailingViewTableViewCell.h"
#import "KSOFormLabelTableViewCell.h"
#import "KSOFormTextTableViewCell.h"
#import "KSOFormButtonTableViewCell.h"
#import "KSOFormSegmentedTableViewCell.h"
#import "KSOFormTableViewHeaderView.h"
#import "KSOFormTableViewFooterView.h"
#import "KSOFormModel+KSOExtensionsPrivate.h"
#import "KSOFormSection.h"
#import "KSOFormRow+KSOExtensionsPrivate.h"
#import "KSOFormTheme.h"
#if (!TARGET_OS_TV)
#import "KSOFormSwitchTableViewCell.h"
#import "KSOFormPickerViewTableViewCell.h"
#import "KSOFormDatePickerTableViewCell.h"
#import "KSOFormStepperTableViewCell.h"
#import "KSOFormSliderTableViewCell.h"
#import "KSOFormTextMultilineTableViewCell.h"
#import "KSOFormOptionsInlineTableViewCell.h"
#endif

#import <Ditko/Ditko.h>
#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOFormTableViewController ()
@property (strong,nonatomic) NSMutableSet<NSString *> *formCellIdentifiers;
@property (strong,nonatomic) NSMutableSet<NSString *> *formHeaderViewIdentifiers;
@property (strong,nonatomic) NSMutableSet<NSString *> *formFooterViewIdentifiers;

@end

@implementation KSOFormTableViewController
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    [self setup];
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self setup];
    
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (!(self = [super initWithStyle:style]))
        return nil;
    
    [self setup];
    
    return self;
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEstimatedRowHeight:44.0];
    [self.tableView registerClass:KSOFormCustomTrailingViewTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormCustomTrailingViewTableViewCell.class)];
    [self.tableView registerClass:KSOFormLabelTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormLabelTableViewCell.class)];
    [self.tableView registerClass:KSOFormTextTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormTextTableViewCell.class)];
    [self.tableView registerClass:KSOFormButtonTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormButtonTableViewCell.class)];
    [self.tableView registerClass:KSOFormSegmentedTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSegmentedTableViewCell.class)];
#if (!TARGET_OS_TV)
    [self.tableView registerClass:KSOFormSwitchTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSwitchTableViewCell.class)];
    [self.tableView registerClass:KSOFormPickerViewTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormPickerViewTableViewCell.class)];
    [self.tableView registerClass:KSOFormDatePickerTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormDatePickerTableViewCell.class)];
    [self.tableView registerClass:KSOFormStepperTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormStepperTableViewCell.class)];
    [self.tableView registerClass:KSOFormSliderTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormSliderTableViewCell.class)];
    [self.tableView registerClass:KSOFormTextMultilineTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormTextMultilineTableViewCell.class)];
    [self.tableView registerClass:KSOFormOptionsInlineTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormOptionsInlineTableViewCell.class)];
#endif
    
    [self.tableView setEstimatedSectionHeaderHeight:32.0];
    [self.tableView setEstimatedSectionFooterHeight:32.0];
    [self.tableView registerClass:KSOFormTableViewHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(KSOFormTableViewHeaderView.class)];
    [self.tableView registerClass:KSOFormTableViewFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(KSOFormTableViewFooterView.class)];
    
    kstWeakify(self);
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model),@kstKeypath(self,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,model)]) {
                [self.model setTableView:self.tableView];
                
                [self.tableView reloadData];
                
                [self.tableView setBackgroundView:self.model.backgroundView];
                [self.tableView setTableHeaderView:self.model.headerView];
                [self.tableView setTableFooterView:self.model.footerView];
                
                if (self.model.parentFormRow.type == KSOFormRowTypeOptions &&
                    self.model.parentFormRow.allowsMultipleSelection) {
                    
                    [self.tableView setAllowsMultipleSelection:YES];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,theme)]) {
                if (self.theme.backgroundColor != nil) {
                    [self.tableView setBackgroundColor:self.theme.backgroundColor];
                }
            }
        });
    }];
    
#if (!TARGET_OS_TV)
    [self KAG_addObserverForNotificationNames:@[KDINextPreviousInputAccessoryViewNotificationNext,KDINextPreviousInputAccessoryViewNotificationPrevious] object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        
        UITableViewCell<KSOFormRowView> *cell = [self.tableView.visibleCells KQS_find:^BOOL(__kindof UITableViewCell<KSOFormRowView> * _Nonnull object, NSInteger index) {
            return [object respondsToSelector:@selector(isEditingFormRow)] && object.isEditingFormRow;
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
        
        [self.model beginEditingRow:editableFormRow];
    }];
#endif
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.model.didAppearBlock != nil) {
        self.model.didAppearBlock(self.model);
    }
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
        NSString *identifier = NSStringFromClass(formRow.cellClass);
        
        if (![self.formCellIdentifiers containsObject:identifier]) {
            if (formRow.cellClassBundle == nil) {
                [tableView registerClass:formRow.cellClass forCellReuseIdentifier:identifier];
            }
            else {
                [tableView registerNib:[UINib nibWithNibName:identifier bundle:formRow.cellClassBundle] forCellReuseIdentifier:identifier];
            }
            
            [self.formCellIdentifiers addObject:identifier];
        }
        
        retval = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    else if (formRow.cellTrailingView != nil) {
        retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormCustomTrailingViewTableViewCell.class) forIndexPath:indexPath];
    }
    else {
        switch (formRow.type) {
            case KSOFormRowTypeLabel:
            case KSOFormRowTypeOptions:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormLabelTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeText:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormTextTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeButton:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormButtonTableViewCell.class) forIndexPath:indexPath];
                break;
            case KSOFormRowTypeSegmented:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormSegmentedTableViewCell.class) forIndexPath:indexPath];
                break;
#if (!TARGET_OS_TV)
            case KSOFormRowTypeTextMultiline:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormTextMultilineTableViewCell.class) forIndexPath:indexPath];
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
            case KSOFormRowTypeOptionsInline:
                retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormOptionsInlineTableViewCell.class) forIndexPath:indexPath];
                break;
#endif
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.model.sections[section].wantsHeaderView ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.model.sections[section].wantsFooterView ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSOFormSection *formSection = self.model.sections[section];
    UITableViewHeaderFooterView<KSOFormSectionView> *retval = nil;
    
    if (formSection.wantsHeaderView) {
        if (formSection.headerViewClass != Nil) {
            NSString *identifier = NSStringFromClass(formSection.headerViewClass);
            
            if (![self.formHeaderViewIdentifiers containsObject:identifier]) {
                if (formSection.headerViewClassBundle == nil) {
                    [tableView registerClass:formSection.headerViewClass forHeaderFooterViewReuseIdentifier:identifier];
                }
                else {
                    [tableView registerNib:[UINib nibWithNibName:identifier bundle:formSection.headerViewClassBundle] forHeaderFooterViewReuseIdentifier:identifier];
                }
                
                [self.formHeaderViewIdentifiers addObject:identifier];
            }
            
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
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
            NSString *identifier = NSStringFromClass(formSection.footerViewClass);
            
            if (![self.formFooterViewIdentifiers containsObject:identifier]) {
                if (formSection.footerViewClassBundle == nil) {
                    [tableView registerClass:formSection.footerViewClass forHeaderFooterViewReuseIdentifier:identifier];
                }
                else {
                    [tableView registerNib:[UINib nibWithNibName:identifier bundle:formSection.footerViewClassBundle] forHeaderFooterViewReuseIdentifier:identifier];
                }
                
                [self.formFooterViewIdentifiers addObject:identifier];
            }
            
            retval = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
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
#pragma mark -
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model rowForIndexPath:indexPath].isSelectable;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model rowForIndexPath:indexPath].isSelectable ? indexPath : nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KSOFormRow *formRow = [self.model rowForIndexPath:indexPath];
    
    if (formRow.isEditable) {
        UITableViewCell<KSOFormRowView> *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(canEditFormRow)] &&
            [cell canEditFormRow] &&
            [cell respondsToSelector:@selector(beginEditingFormRow)]) {
            
            [cell beginEditingFormRow];
        }
    }
    
    UIViewController *viewController = nil;
    
    if (formRow.actionViewControllerClass != Nil) {
        if ([formRow.actionViewControllerClass isSubclassOfClass:UITableViewController.class]) {
            viewController = [[formRow.actionViewControllerClass alloc] initWithStyle:self.tableView.style];
        }
        else {
            viewController = [[formRow.actionViewControllerClass alloc] initWithNibName:nil bundle:nil];
        }
    }
    else if (formRow.actionModel != nil) {
        viewController = [[KSOFormTableViewController alloc] initWithStyle:self.tableView.style];
        
        [(KSOFormTableViewController *)viewController setTheme:self.theme];
        [(KSOFormTableViewController *)viewController setModel:formRow.actionModel];
    }
    else if ([formRow.actionDelegate respondsToSelector:@selector(actionViewControllerForFormRow:)]) {
        viewController = [formRow.actionDelegate actionViewControllerForFormRow:formRow];
    }
    else if ([formRow.actionDelegate respondsToSelector:@selector(executeActionForFormRow:)]) {
        [formRow.actionDelegate executeActionForFormRow:formRow];
    }
    
    if (viewController != nil) {
        switch (formRow.action) {
            case KSOFormRowActionPush:
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            case KSOFormRowActionPresent:
                [self presentViewController:viewController animated:YES completion:nil];
                break;
            default:
                break;
        }
    }
    else if (self.model.parentFormRow.type == KSOFormRowTypeOptions) {
        if (self.model.parentFormRow.allowsMultipleSelection) {
            id currentValue = self.model.parentFormRow.value;
            NSMutableArray *newValue = [[NSMutableArray alloc] init];
            
            if (!KSTIsEmptyObject(currentValue)) {
                if ([currentValue isKindOfClass:NSArray.class]) {
                    [newValue addObjectsFromArray:currentValue];
                }
                else {
                    [newValue addObject:currentValue];
                }
            }
            
            id selectedValue = self.model.parentFormRow.optionRows[indexPath.row];
            
            if ([newValue containsObject:selectedValue]) {
                [newValue removeObject:selectedValue];
            }
            else {
                [newValue addObject:selectedValue];
            }
            
            [self.model.parentFormRow setValue:newValue notify:YES];
        }
        else {
            [self.model.parentFormRow setValue:self.model.parentFormRow.optionRows[indexPath.row] notify:YES];
        }
    }
}
#pragma mark *** Public Methods ***
- (void)setup {
    _formCellIdentifiers = [[NSMutableSet alloc] init];
    _formHeaderViewIdentifiers = [[NSMutableSet alloc] init];
    _formFooterViewIdentifiers = [[NSMutableSet alloc] init];
    
    _theme = KSOFormTheme.defaultTheme;
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model.title),@kstKeypath(self,model.titleView),@kstKeypath(self,model.leftBarButtonItems),@kstKeypath(self,model.rightBarButtonItems)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([keyPath isEqualToString:@kstKeypath(self,model.title)]) {
                if (self.model.title != nil) {
                    [self setTitle:self.model.title];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,model.titleView)]) {
                if (self.model.titleView != nil) {
                    [self.navigationItem setTitleView:self.model.titleView];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,model.leftBarButtonItems)]) {
                if (self.model.leftBarButtonItems != nil) {
                    [self.navigationItem setLeftBarButtonItems:self.model.leftBarButtonItems];
                }
            }
            else if ([keyPath isEqualToString:@kstKeypath(self,model.rightBarButtonItems)]) {
                if (self.model.rightBarButtonItems != nil) {
                    [self.navigationItem setRightBarButtonItems:self.model.rightBarButtonItems];
                }
            }
        });
    }];
}
#pragma mark Properties
- (void)setTheme:(KSOFormTheme *)theme {
    _theme = theme ?: KSOFormTheme.defaultTheme;
}

@end
