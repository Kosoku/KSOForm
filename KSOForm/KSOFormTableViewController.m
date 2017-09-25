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
#import "KSOFormTextTableViewCell.h"
#import "KSOFormModel.h"
#import "KSOFormSection.h"
#import "KSOFormRow.h"

@interface KSOFormTableViewController ()

@end

@implementation KSOFormTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEstimatedRowHeight:44.0];
    [self.tableView registerClass:KSOFormTextTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOFormTextTableViewCell.class)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.sections.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.sections[section].rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSOFormRow *formRow = self.model.sections[indexPath.section].rows[indexPath.row];
    KSOFormRowTableViewCell *retval = nil;
    
    switch (formRow.type) {
        case KSOFormRowTypeText:
            retval = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSOFormRowTableViewCell.class) forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    [retval setFormRow:formRow];
    
    return retval;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
