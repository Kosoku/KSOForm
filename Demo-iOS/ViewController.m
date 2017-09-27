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

@interface TableBackgroundView : UIView
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation TableBackgroundView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kosoku-logo"].KDI_templateImage]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setTintColor:[KDIColorHexadecimal(@"ebebf0") KDI_colorByAdjustingBrightnessBy:0.05]];
    [self addSubview:self.imageView];
    
    [self sizeToFit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setFrame:self.bounds];
}
@end

@interface TableHeaderView : UIView
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation TableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kosoku-logo"]]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.imageView];
    
    [self sizeToFit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(0, 8, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 8)];
}
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), 50 + 8);
}
@end

@interface TableFooterView : UIView
@property (strong,nonatomic) UILabel *label;
@end

@implementation TableFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.label setText:@"Kosoku Interactive, LLC."];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.label];
    
    [self sizeToFit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:self.bounds];
}
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), ceil(self.label.font.lineHeight));
}
@end

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
    
    KSOFormModel *readOnlyModel = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Read Only Values"}];
    
    [readOnlyModel addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Read Only Values",
                                              KSOFormSectionKeyFooterTitle: @"Footer for read only values"
                                              }];
    [readOnlyModel.sections.lastObject addRowsFromDictionaries:@[@{KSOFormRowKeyTitle: @"Title",
                                                                   KSOFormRowKeyValue: @"Value"},
                                                                 @{KSOFormRowKeyTitle: @"Title",
                                                                   KSOFormRowKeySubtitle: @"Subtitle",
                                                                   KSOFormRowKeyValue: @"Value"},
                                                                 @{KSOFormRowKeyTitle: @"Title",
                                                                   KSOFormRowKeySubtitle: @"Subtitle",
                                                                   KSOFormRowKeyImage: [UIImage imageNamed:@"recycle"],
                                                                   KSOFormRowKeyValue: @"Value"}]];
    KSOFormModel *textModel = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Text Entry"}];
    
    [textModel addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Text entry examples",
                                          KSOFormSectionKeyFooterTitle: @"Footer for text entry examples"
                                          }];
    [textModel.sections.lastObject addRowsFromDictionaries:@[@{KSOFormRowKeyType: @(KSOFormRowTypeText),
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
                                                               }]];
    KSOFormModel *controlsModel = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Controls"}];
    
    [controlsModel addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Control examples",
                                              KSOFormSectionKeyFooterTitle: @"Footer for control examples"
                                              }];
    [controlsModel.sections.lastObject addRowsFromDictionaries:@[@{KSOFormRowKeyType: @(KSOFormRowTypeSegmented),
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
                                                                   }]];
    
    KSOFormModel *wifiModel = [[KSOFormModel alloc] init];
    
    [wifiModel setTitle:@"Wi-Fi"];
    [wifiModel addSectionFromDictionary:@{KSOFormSectionKeyRows: @[@{KSOFormRowKeyType: @(KSOFormRowTypeSwitch),
                                                                     KSOFormRowKeyTitle: @"Wi-Fi"
                                                                     }]}];
    
    KSOFormModel *model = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Demo-iOS",
                                                                     KSOFormModelKeyHeaderView: [[TableHeaderView alloc] initWithFrame:CGRectZero]
                                                                     }];
    
    [model addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Section header title",
                                      KSOFormSectionKeyFooterTitle: @"Section footer title"
                                      }];
    [model.sections.lastObject addRowsFromDictionaries:@[@{KSOFormRowKeyTitle: @"Read Only Values",
                                                           KSOFormRowKeyActionModel: readOnlyModel
                                                           },
                                                         @{KSOFormRowKeyTitle: @"Text Entry",
                                                           KSOFormRowKeyActionModel: textModel
                                                           },
                                                         @{KSOFormRowKeyTitle: @"Controls",
                                                           KSOFormRowKeyActionModel: controlsModel
                                                           },
                                                         @{KSOFormRowKeyTitle: @"Wi-Fi",
                                                           KSOFormRowKeyValue: @"Network Name",
                                                           KSOFormRowKeyActionModel: wifiModel
                                                           }]];
    
    [self setModel:model];
}

@end
