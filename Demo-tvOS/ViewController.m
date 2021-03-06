//
//  ViewController.m
//  Demo-tvOS
//
//  Created by William Towe on 9/12/18.
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

#import "ViewController.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOTextValidation/KSOTextValidation.h>
#import <KSOForm/KSOForm.h>
#import <Loki/Loki.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

@interface TableHeaderView : UIView
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation TableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithImage:[UIImage KLO_imageWithPDFNamed:@"kosoku-logo" size:CGSizeMake(128, 128)].KDI_templateImage]];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.tintColor = KDIColorW(0.1);
    [self addSubview:self.imageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.imageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|" options:0 metrics:nil views:@{@"view": self.imageView}]];
    
    return self;
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
    
    [self setEmail:@"a@b.com"];
    
    CGSize imageSize = CGSizeMake(24, 24);
    
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
                                                                   KSOFormRowKeyImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf26c" size:imageSize].KDI_templateImage,
                                                                   KSOFormRowKeyValue: @"Value"},
                                                                 @{KSOFormRowKeyTitle: @"Title",
                                                                   KSOFormRowKeySubtitle: @"Subtitle",
                                                                   KSOFormRowKeyImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf26c" size:imageSize].KDI_templateImage,
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
                                                                   KSOFormRowKeyValue: @2,
                                                                   KSOFormRowKeySegmentedItems: @[@1,@2,@3,@4],
                                                                   KSOFormRowKeyValueFormatter: ({
        NSNumberFormatter *retval = [[NSNumberFormatter alloc] init];
        
        [retval setNumberStyle:NSNumberFormatterOrdinalStyle];
        
        retval;
    })
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeOptions),
                                                                   KSOFormRowKeyTitle: @"Options",
                                                                   KSOFormRowKeyOptionRows: @[@"Red",@"Green",@"Blue"],
                                                                   KSOFormRowKeyValue: @"Red"
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeButton),
                                                                   KSOFormRowKeyTitle: @"Show Alert…",
                                                                   KSOFormRowKeyControlBlock: ^(__kindof UIControl *control, UIControlEvents controlEvents){
        [UIAlertController KDI_presentAlertControllerWithTitle:@"Oh Noes!" message:@"Did you see that Morty?!?" cancelButtonTitle:nil otherButtonTitles:nil completion:nil];
    }
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeButton),
                                                                   KSOFormRowKeyTitle: @"Delete Things…",
                                                                   KSOFormRowKeyThemeTextColor: UIColor.redColor,
                                                                   KSOFormRowKeyControlBlock: ^(__kindof UIControl *control, UIControlEvents controlEvents){
        [UIAlertController KDI_presentAlertControllerWithTitle:@"Oh Noes!" message:@"Did you see that Morty?!?" cancelButtonTitle:nil otherButtonTitles:@[@"Delete"] completion:nil];
    }
                                                                   }]];
    
    KSOFormModel *model = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Demo-iOS",
                                                                     KSOFormModelKeyHeaderView: ({
        UIView *retval = [[TableHeaderView alloc] initWithFrame:CGRectZero];
        CGSize size = [retval systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        retval.frame = CGRectMake(0, 0, size.width, size.height);
        
        retval;
    })
                                                                     }];
    
    [model addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Section header title",
                                      KSOFormSectionKeyFooterAttributedTitle: ({
        NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] init];
        
        [retval appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is a attributed footer title with a " attributes:nil]];
        [retval appendAttributedString:[[NSAttributedString alloc] initWithString:@"link to Kosoku" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://www.kosoku.com/"]}]];
        [retval appendAttributedString:[[NSAttributedString alloc] initWithString:@" that you can tap on to open the link in Safari." attributes:nil]];
        
        retval;
    })
                                      }];
    [model.sections.lastObject addRowsFromDictionaries:@[@{KSOFormRowKeyTitle: @"Read Only Values",
                                                           KSOFormRowKeyActionModel: readOnlyModel
                                                           },
                                                         @{KSOFormRowKeyTitle: @"Text Entry",
                                                           KSOFormRowKeyActionModel: textModel
                                                           },
                                                         @{KSOFormRowKeyTitle: @"Controls",
                                                           KSOFormRowKeyActionModel: controlsModel
                                                           }
                                                         ]];
    [model addSection:[[KSOFormSection alloc] initWithDictionary:@{KSOFormSectionKeyHeaderTitle: @"Custom Examples",
                                                                   KSOFormSectionKeyFooterAttributedTitle: ({
        NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:@"This is another attributed string being used as footer text and it is very colorful." attributes:nil];
        
        [retval.string enumerateSubstringsInRange:NSMakeRange(0, retval.length) options:NSStringEnumerationByWords|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            [retval addAttributes:@{NSForegroundColorAttributeName: KDIColorRandomRGB()} range:substringRange];
        }];
        
        retval;
    }),
                                                                   KSOFormSectionKeyRows: @[@{KSOFormRowKeyTitle: @"Map View"}
                                                                                            ]
                                                                   }]];
    
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Tap to choose image…"}];
    
    [self setModel:model];
}


@end
