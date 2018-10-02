//
//  ViewController.m
//  Demo-iOS
//
//  Created by William Towe on 9/24/17.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewController.h"
#import "MapViewController.h"
#import "BluetoothTableViewController.h"
#import "ImagePickerView.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOTextValidation/KSOTextValidation.h>
#import <KSOForm/KSOForm.h>
#import <Loki/Loki.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>
#import <KSOToken/KSOToken.h>
#import <Agamotto/Agamotto.h>

@interface TagTextView : KSOTokenTextView <KSOFormRowView>

@end

@implementation TagTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (!(self = [super initWithFrame:frame textContainer:textContainer]))
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;
    self.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    self.textAlignment = NSTextAlignmentRight;
    self.placeholder = @"Enter some tags";
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_tagTextView_textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}

@synthesize formRow=_formRow;
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
}

- (BOOL)canEditFormRow {
    return self.canBecomeFirstResponder;
}
- (BOOL)isEditingFormRow {
    return self.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self becomeFirstResponder];
}

- (void)_tagTextView_textDidChange:(NSNotification *)note {
    UIView *view = self.superview;
    
    while (view != nil) {
        if ([view isKindOfClass:UITableViewCell.class]) {
            [view setNeedsUpdateConstraints];
            break;
        }
        view = view.superview;
    }
    
    [self.formRow reloadHeightAnimated:NO];
}

@end

@interface TableHeaderView : UIView
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation TableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setImageView:[[UIImageView alloc] initWithImage:[UIImage KLO_imageWithPDFNamed:@"kosoku-logo" size:CGSizeMake(96, 96)].KDI_templateImage]];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
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

@interface ViewController () <KSOFormRowValueDataSource,KSOFormRowActionDelegate>
@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *password;
@property (copy,nonatomic) NSString *phoneNumber;
@property (strong,nonatomic) KSOFormRow *bluetoothRow;
@end

@implementation ViewController

+ (void)initialize {
    if (self == ViewController.class) {
        KSOFormTheme *theme = [KSOFormTheme.defaultTheme copy];
        
//        [theme setTitleColor:KDIColorRandomRGB()];
//        [theme setSubtitleColor:KDIColorRandomRGB()];
//        [theme setValueColor:KDIColorRandomRGB()];
//        [theme setTextColor:KDIColorRandomRGB()];
//        [theme setTextSelectionColor:theme.textColor];
//        [theme setFirstResponderColor:[KDIColorRandomRGB() colorWithAlphaComponent:0.1]];
        
        [KSOFormTheme setDefaultTheme:theme];
    }
}

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
                                                                   KSOFormRowKeyImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf641" size:imageSize].KDI_templateImage,
                                                                   KSOFormRowKeyValue: @"Value"},
                                                                 @{KSOFormRowKeyTitle: @"Title",
                                                                   KSOFormRowKeySubtitle: @"Subtitle",
                                                                   KSOFormRowKeyImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf641" size:imageSize].KDI_templateImage,
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
                                                               },
                                                             @{KSOFormRowKeyType: @(KSOFormRowTypeTextMultiline),
                                                               KSOFormRowKeyTitle: @"Notes",
                                                               KSOFormRowKeyPlaceholder: @"Enter your notes"
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
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeSwitch),
                                                                   KSOFormRowKeyTitle: @"Toggle Something",
                                                                   KSOFormRowKeySubtitle: @"This is a subtitle that should wrap because it is too long to fit on a single line"
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypePickerView),
                                                                   KSOFormRowKeyTitle: @"Picker View",
                                                                   KSOFormRowKeyValue: @[@"Blue",@"Two"],
                                                                   KSOFormRowKeyPickerViewColumnsAndRows: @[@[@"Red",@"Green",@"Blue"],@[@"One",@"Two",@"Three"]],
                                                                   KSOFormRowKeyPickerViewSelectedComponentsJoinString: @", "
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeOptions),
                                                                   KSOFormRowKeyTitle: @"Options",
                                                                   KSOFormRowKeyOptionRows: @[@"Red",@"Green",@"Blue"],
                                                                   KSOFormRowKeyValue: @"Red"
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
                                                                   KSOFormRowKeySliderMinimumValueImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf042" size:imageSize].KDI_templateImage,
                                                                   KSOFormRowKeySliderMaximumValueImage: [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf042" size:imageSize].KDI_templateImage
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
    
    [model addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Section header title that should wrap to multiple lines because it is too long",
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
                                                                   KSOFormSectionKeyRows: @[@{KSOFormRowKeyTitle: @"Map View",
                                                                                              KSOFormRowKeyActionViewControllerClass: MapViewController.class
                                                                                              }
                                                                                            ]
                                                                   }]];
    [self setBluetoothRow:[[KSOFormRow alloc] initWithDictionary:@{KSOFormRowKeyTitle: @"Bluetooth",
                                                                   KSOFormRowKeyValue: @"Unknown",
                                                                   KSOFormRowKeyActionDelegate: self
                                                                   }]];
    [model.sections.lastObject addRow:self.bluetoothRow];
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Tap to choose image…", KSOFormRowKeyCellTrailingView: [[ImagePickerView alloc] initWithFrame:CGRectZero], KSOFormRowKeyThemeTitleColor: self.view.tintColor}];
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Tags", KSOFormRowKeyCellTrailingView: [[TagTextView alloc] initWithFrame:CGRectZero textContainer:nil], KSOFormRowKeyCellWantsLeadingViewCenteredVertically: @NO}];
    
    [self setModel:model];
}

- (UIViewController *)actionViewControllerForFormRow:(KSOFormRow *)formRow {
    return [[BluetoothTableViewController alloc] initWithFormRow:self.bluetoothRow];
}

@end
