//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"

#import <Ditko/Ditko.h>
#import <KSOForm/KSOForm.h>

@interface ViewController ()
@property (strong,nonatomic) KSOFormTableViewController *tableViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewController:[[KSOFormTableViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    [self addChildViewController:self.tableViewController];
    [self.tableViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableViewController.view}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.tableViewController.view}]];
    
    KSOFormTheme *theme = [KSOFormTheme.defaultTheme copy];
    
    [theme setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self.tableViewController setTheme:theme];
    
    NSArray *section1 = @[@{KSOFormRowKeyTitle: @"Title",
                            KSOFormRowKeyValue: @"Value"},
                          @{KSOFormRowKeyTitle: @"Title",
                            KSOFormRowKeySubtitle: @"Subtitle",
                            KSOFormRowKeyValue: @"Value"},
                          @{KSOFormRowKeyTitle: @"Title",
                            KSOFormRowKeyImage: [UIImage imageNamed:@"recycle"],
                            KSOFormRowKeyValue: @"Value"},
                          @{KSOFormRowKeyTitle: @"Title",
                            KSOFormRowKeySubtitle: @"Subtitle",
                            KSOFormRowKeyImage: [UIImage imageNamed:@"recycle"],
                            KSOFormRowKeyValue: @"Value"}];
    NSArray *section2 = @[@{KSOFormRowKeyType: @(KSOFormRowTypeText),
                            KSOFormRowKeyTitle: @"Email",
                            KSOFormRowKeyPlaceholder: @"Enter your email address",
                            KSOFormRowKeyKeyboardType: @(UIKeyboardTypeEmailAddress),
                            KSOFormRowKeyTextContentType: UITextContentTypeEmailAddress
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeText),
                            KSOFormRowKeyTitle: @"Password",
                            KSOFormRowKeyPlaceholder: @"Enter your password",
                            KSOFormRowKeySecureTextEntry: @YES
                            }];
    
    NSDictionary *dictionary = @{KSOFormModelKeySections: @[@{KSOFormSectionKeyRows: section1,
                                                              KSOFormSectionKeyHeaderTitle: @"Read only values",
                                                              KSOFormSectionKeyFooterTitle: @"Additional info in the footer title"
                                                              },
                                                            @{KSOFormSectionKeyRows: section2,
                                                              KSOFormSectionKeyHeaderTitle: @"Login details",
                                                              KSOFormSectionKeyFooterTitle: @"Info about the password field if relevant"
                                                              }]};
    
    [self.tableViewController setModel:[[KSOFormModel alloc] initWithDictionary:dictionary]];
}

@end
