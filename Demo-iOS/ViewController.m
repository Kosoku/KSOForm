//
//  ViewController.m
//  Demo-iOS
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

#import "ViewController.h"
#import "MapViewController.h"
#import "BluetoothTableViewController.h"
#import "ImagePickerView.h"
#import "LoremIpsum.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <KSOTextValidation/KSOTextValidation.h>
#import <KSOForm/KSOForm.h>
#import <Loki/Loki.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>
#import <KSOToken/KSOToken.h>
#import <Agamotto/Agamotto.h>

static NSString *const kBluetoothIdentifier = @"kBluetoothIdentifier";
static NSString *const kLongFormIdentifier = @"kLongFormIdentifier";

@interface TagTextAttachment : KSOTokenDefaultTextAttachment

@end

@implementation TagTextAttachment

- (instancetype)initWithRepresentedObject:(id<KSOTokenRepresentedObject>)representedObject text:(NSString *)text tokenTextView:(KSOTokenTextView *)tokenTextView {
    if (!(self = [super initWithRepresentedObject:representedObject text:text tokenTextView:tokenTextView]))
        return nil;
    
    self.tokenCornerRadius = 3.0;
    self.tokenBackgroundColor = tokenTextView.tintColor;
    self.tokenTextColor = self.tokenBackgroundColor.KDI_contrastingColor;
    self.tokenHighlightedTextColor = self.tokenBackgroundColor;
    self.tokenHighlightedBackgroundColor = self.tokenTextColor;
    self.tokenDisabledBackgroundColor = tokenTextView.textColor;
    self.tokenDisabledTextColor = self.tokenDisabledBackgroundColor.KDI_contrastingColor;
    self.respondsToTintColorChanges = NO;
    
    return self;
}

@end

@interface TagTextView : KSOTokenTextView <KSOFormRowView, KSOTokenTextViewDelegate>

@end

@implementation TagTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (!(self = [super initWithFrame:frame textContainer:textContainer]))
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = UIColor.clearColor;
    self.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    self.textAlignment = NSTextAlignmentRight;
    self.scrollEnabled = NO;
    self.placeholder = @"Enter some tags";
    self.tokenTextAttachmentClass = TagTextAttachment.class;
    
    [self KAG_addObserverForNotificationNames:@[KDIUIResponderNotificationDidBecomeFirstResponder,KDIUIResponderNotificationDidResignFirstResponder] object:self block:^(NSNotification * _Nonnull notification) {
        [NSNotificationCenter.defaultCenter postNotificationName:[notification.name isEqualToString:KDIUIResponderNotificationDidBecomeFirstResponder] ? KSOFormRowViewNotificationDidBeginEditing : KSOFormRowViewNotificationDidEndEditing object:notification.object];
    }];
    
    return self;
}

@synthesize formRow=_formRow;
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
    
    self.representedObjects = formRow.value;
}

@end

@interface TagScrollView : UIScrollView <KSOFormRowView, KSOTokenTextViewDelegate>
@property (strong,nonatomic) TagTextView *textView;
@end

@implementation TagScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView = [[TagTextView alloc] initWithFrame:CGRectZero textContainer:nil];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.textView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.textView}]];
    [NSLayoutConstraint activateConstraints:@[[self.textView.widthAnchor constraintEqualToAnchor:self.widthAnchor]]];
    
    NSLayoutConstraint *height = [self.heightAnchor constraintEqualToAnchor:self.textView.heightAnchor];
    
    height.priority = UILayoutPriorityDefaultLow;
    
    [NSLayoutConstraint activateConstraints:@[height]];
    
    return self;
}

@synthesize formRow=_formRow;
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
    
    self.textView.formRow = _formRow;
}

- (BOOL)canEditFormRow {
    return self.textView.canBecomeFirstResponder;
}
- (BOOL)isEditingFormRow {
    return self.textView.isFirstResponder;
}
- (void)beginEditingFormRow {
    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
//    [self.formRow setValue:self.textView.text notify:YES];
    
    [self.formRow reloadHeightAnimated:NO];
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    [self scrollRectToVisible:rect animated:NO];
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
                                                               KSOFormRowKeyPlaceholder: @"Enter your notes",
                                                               KSOFormRowKeyValue: [LoremIpsum paragraphsWithNumber:2],
                                                               KSOFormRowKeyMaximumNumberOfLines: @5
                                                               },
                                                             @{KSOFormRowKeyTitle: @"Tags",
                                                               KSOFormRowKeyCellTrailingView: [[TagScrollView alloc] initWithFrame:CGRectZero],
                                                               KSOFormRowKeyCellWantsLeadingViewCenteredVertically: @NO,
                                                               KSOFormRowKeyValue: [[LoremIpsum wordsWithNumber:20] componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet]
                                                               }]];
    KSOFormModel *controlsModel = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Controls"}];
    
    [controlsModel addSectionFromDictionary:@{KSOFormSectionKeyHeaderTitle: @"Control examples",
                                              KSOFormSectionKeyFooterTitle: @"Footer for control examples"
                                              }];
    
    UIImage*(^optionRowImageBlock)(UIColor *) = ^UIImage*(UIColor *color) {
        CGSize size = CGSizeMake(32.0, 32.0);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [color setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, size.width, size.height)] fill];
        
        UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return retval;
    };
    
    NSArray *optionRows = @[[KSOFormRow formRowWithDictionary:@{KSOFormRowKeyTitle: @"Red", KSOFormRowKeySubtitle: @"The color red", KSOFormRowKeyImage: optionRowImageBlock(UIColor.redColor)}],
                            [KSOFormRow formRowWithDictionary:@{KSOFormRowKeyTitle: @"Green", KSOFormRowKeySubtitle: @"The color green", KSOFormRowKeyImage: optionRowImageBlock(UIColor.greenColor)}],
                            [KSOFormRow formRowWithDictionary:@{KSOFormRowKeyTitle: @"Blue", KSOFormRowKeySubtitle: @"The color blue", KSOFormRowKeyImage: optionRowImageBlock(UIColor.blueColor)}]];
    
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
                                                                   KSOFormRowKeyOptionRows: optionRows,
                                                                   KSOFormRowKeyValue: optionRows.firstObject,
                                                                   KSOFormRowKeyPlaceholder: @"N/A"
                                                                   },
                                                                 @{KSOFormRowKeyType: @(KSOFormRowTypeOptionsInline),
                                                                   KSOFormRowKeyTitle: @"Options Inline",
                                                                   KSOFormRowKeyOptionRows: optionRows,
                                                                   KSOFormRowKeyValue: optionRows.firstObject,
                                                                   KSOFormRowKeyPlaceholder: @"N/A"
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
                                                                   KSOFormSectionKeyRows: @[@{KSOFormRowKeyTitle: @"Map View",
                                                                                              KSOFormRowKeyActionViewControllerClass: MapViewController.class
                                                                                              }
                                                                                            ]
                                                                   }]];
    [self setBluetoothRow:[[KSOFormRow alloc] initWithDictionary:@{KSOFormRowKeyTitle: @"Bluetooth",
                                                                   KSOFormRowKeyValue: @"Unknown",
                                                                   KSOFormRowKeyActionDelegate: self,
                                                                   KSOFormRowKeyIdentifier: kBluetoothIdentifier
                                                                   }]];
    [model.sections.lastObject addRow:self.bluetoothRow];
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Tap to choose image…", KSOFormRowKeyCellTrailingView: [[ImagePickerView alloc] initWithFrame:CGRectZero], KSOFormRowKeyThemeTitleColor: self.view.tintColor}];
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Tags", KSOFormRowKeyCellTrailingView: [[TagScrollView alloc] initWithFrame:CGRectZero], KSOFormRowKeyCellWantsLeadingViewCenteredVertically: @NO}];
    [model.sections.lastObject addRowFromDictionary:@{KSOFormRowKeyTitle: @"Long Form",
                                                      KSOFormRowKeyActionDelegate: self,
                                                      KSOFormRowKeyIdentifier: kLongFormIdentifier
                                                      }];
    
    [self setModel:model];
}

- (KSOFormModel *)actionFormModelForFormRow:(KSOFormRow *)formRow {
    if ([formRow.identifier isEqualToString:kLongFormIdentifier]) {
        KSOFormModel *retval = [[KSOFormModel alloc] initWithDictionary:@{KSOFormModelKeyTitle: @"Long Form"}];
        
        for (NSInteger i=0; i<10; i++) {
            KSOFormSection *section = [[KSOFormSection alloc] init];
            
            section.headerTitle = [NSNumberFormatter localizedStringFromNumber:@(i) numberStyle:NSNumberFormatterSpellOutStyle];
            
            for (NSInteger j=0; j<10; j++) {
                KSOFormRow *row = [[KSOFormRow alloc] initWithDictionary:@{KSOFormRowKeyType: @(KSOFormRowTypePickerView)}];
                
                row.title = [NSNumberFormatter localizedStringFromNumber:@(j) numberStyle:NSNumberFormatterSpellOutStyle];
                
                NSMutableArray *optionRows = [[NSMutableArray alloc] init];
                NSInteger count = j + 1;
                
                for (NSInteger o=0; o<count; o++) {
                    [optionRows addObject:[NSNumberFormatter localizedStringFromNumber:@(o) numberStyle:NSNumberFormatterOrdinalStyle]];
                }
                
                row.pickerViewRows = optionRows;
                
                [section addRow:row];
            }
            
            [retval addSection:section];
        }
        
        return retval;
    }
    return nil;
}
- (UIViewController *)actionViewControllerForFormRow:(KSOFormRow *)formRow {
    if ([formRow.identifier isEqualToString:kBluetoothIdentifier]) {
        return [[BluetoothTableViewController alloc] initWithFormRow:self.bluetoothRow];
    }
    return nil;
}

@end
