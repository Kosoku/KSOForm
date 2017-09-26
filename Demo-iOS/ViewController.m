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
#import <Stanley/Stanley.h>
#import <KSOTextValidation/KSOTextValidation.h>
#import <KSOForm/KSOForm.h>

@interface ViewController () <KSOFormRowValueDataSource>
@property (strong,nonatomic) KSOFormTableViewController *tableViewController;

@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *password;
@property (copy,nonatomic) NSString *phoneNumber;
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
    
    NSArray *readonly = @[@{KSOFormRowKeyTitle: @"Title",
                            KSOFormRowKeySubtitle: @"Subtitle",
                            KSOFormRowKeyImage: [UIImage imageNamed:@"recycle"],
                            KSOFormRowKeyValue: @"Value"}];
    NSArray *textEntry = @[@{KSOFormRowKeyType: @(KSOFormRowTypeText),
                            KSOFormRowKeyTitle: @"Email",
                            KSOFormRowKeyPlaceholder: @"Enter your email address",
                            KSOFormRowKeyKeyboardType: @(UIKeyboardTypeEmailAddress),
                            KSOFormRowKeyTextContentType: UITextContentTypeEmailAddress,
                            KSOFormRowKeyValueKey: @kstKeypath(self,email),
                            KSOFormRowKeyValueDataSource: self,
                            KSOFormRowKeyTextValidator: [KSOEmailAddressValidator emailAddressValidator]
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeText),
                            KSOFormRowKeyTitle: @"Password",
                            KSOFormRowKeyPlaceholder: @"Enter your password",
                            KSOFormRowKeySecureTextEntry: @YES,
                            KSOFormRowKeyTextContentType: UITextContentTypePassword,
                            KSOFormRowKeyValueKey: @kstKeypath(self,password),
                            KSOFormRowKeyValueDataSource: self
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeText),
                            KSOFormRowKeyTitle: @"Phone Number",
                            KSOFormRowKeyPlaceholder: @"Enter phone number",
                            KSOFormRowKeyKeyboardType: @(UIKeyboardTypePhonePad),
                            KSOFormRowKeyTextContentType: UITextContentTypeTelephoneNumber,
                            KSOFormRowKeyValueKey: @kstKeypath(self,phoneNumber),
                            KSOFormRowKeyValueDataSource: self,
                            KSOFormRowKeyTextValidator: [KSOPhoneNumberValidator phoneNumberValidator],
                            KSOFormRowKeyTextFormatter: [[KSTPhoneNumberFormatter alloc] init]
                            }];
    NSArray *controls = @[@{KSOFormRowKeyType: @(KSOFormRowTypeSwitch),
                            KSOFormRowKeyTitle: @"Toggle Something"
                            }];
    
    NSDictionary *dictionary = @{KSOFormModelKeySections: @[@{KSOFormSectionKeyRows: readonly,
                                                              KSOFormSectionKeyHeaderTitle: @"Read only values",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              },
                                                            @{KSOFormSectionKeyRows: textEntry,
                                                              KSOFormSectionKeyHeaderTitle: @"Text entry",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              },
                                                            @{KSOFormSectionKeyRows: controls,
                                                              KSOFormSectionKeyHeaderTitle: @"Controls",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              }]};
    
    [self.tableViewController setModel:[[KSOFormModel alloc] initWithDictionary:dictionary]];
}

@end
