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
@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *password;
@property (copy,nonatomic) NSString *phoneNumber;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KSOFormTheme *theme = [KSOFormTheme.defaultTheme copy];
    
    [theme setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self setTheme:theme];
    
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
    NSArray *controls = @[@{KSOFormRowKeyType: @(KSOFormRowTypeSegmented),
                            KSOFormRowKeyTitle: @"Segmented",
                            KSOFormRowKeySegmentedItems: @[@"First",@"Second",@"Third",@"Fourth"]
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeSwitch),
                            KSOFormRowKeyTitle: @"Toggle Something"
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypePickerView),
                            KSOFormRowKeyTitle: @"Picker View",
                            KSOFormRowKeyPickerViewColumnsAndRows: @[@[@"Red",@"Green",@"Blue"],@[@"One",@"Two",@"Three"]],
                            KSOFormRowKeyPickerViewSelectedComponentsJoinString: @", "
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeDatePicker),
                            KSOFormRowKeyTitle: @"Date Picker",
                            KSOFormRowKeyDatePickerMode: @(UIDatePickerModeDateAndTime),
                            KSOFormRowKeyDatePickerMinimumDate: NSDate.date,
                            KSOFormRowKeyDatePickerDateFormatter: ({
                                NSDateFormatter *retval = [[NSDateFormatter alloc] init];
                                
                                [retval setDateStyle:NSDateFormatterShortStyle];
                                [retval setTimeStyle:NSDateFormatterShortStyle];
                                
                                retval;
                            })
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeStepper),
                            KSOFormRowKeyTitle: @"Stepper",
                            KSOFormRowKeyStepperStepValue: @0.05,
                            KSOFormRowKeyMinimumValue: @-1.0,
                            KSOFormRowKeyValueFormatter: ({
                                NSNumberFormatter *retval = [[NSNumberFormatter alloc] init];
                                
                                [retval setNumberStyle:NSNumberFormatterDecimalStyle];
                                [retval setMinimumFractionDigits:2];
                                
                                retval;
                            })
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeSlider),
                            KSOFormRowKeyTitle: @"Slider",
                            KSOFormRowKeySliderMinimumValueImage: [UIImage imageNamed:@"bag"],
                            KSOFormRowKeySliderMaximumValueImage: [UIImage imageNamed:@"socket"]
                            },
                          @{KSOFormRowKeyType: @(KSOFormRowTypeButton),
                            KSOFormRowKeyTitle: @"Show Alert",
                            KSOFormRowKeyControlBlock: ^(__kindof UIControl *control, UIControlEvents controlEvents){
                                [UIAlertController KDI_presentAlertControllerWithTitle:@"Oh Noes!" message:@"Did you see that Morty?!?" cancelButtonTitle:nil otherButtonTitles:nil completion:nil];
                            }
                            }];
    
    NSDictionary *dictionary = @{KSOFormModelKeyTitle: @"Demo-iOS",
                                 KSOFormModelKeySections: @[@{KSOFormSectionKeyRows: readonly,
                                                              KSOFormSectionKeyHeaderTitle: @"Read only",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              },
                                                            @{KSOFormSectionKeyRows: textEntry,
                                                              KSOFormSectionKeyHeaderTitle: @"Text fields",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              },
                                                            @{KSOFormSectionKeyRows: controls,
                                                              KSOFormSectionKeyHeaderTitle: @"Controls",
                                                              KSOFormSectionKeyFooterTitle: @"Section footer title"
                                                              }]};
    
    [self setModel:[[KSOFormModel alloc] initWithDictionary:dictionary]];
}

@end
