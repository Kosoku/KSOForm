//
//  CustomTableViewCell.m
//  Demo-iOS
//
//  Created by William Towe on 9/28/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CustomTableViewCell.h"

#import <Ditko/Ditko.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

static CGSize const kImageSize = {.width=25, .height=25};

@interface CustomTableViewCell ()
@property (weak,nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UIButton *lockButton;
@property (weak,nonatomic) IBOutlet UIButton *signalButton;
@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(>=height@priority)]" options:0 metrics:@{@"height": @44.0, @"priority": @(UILayoutPriorityDefaultHigh)} views:@{@"view": self.contentView}]];
    
    [self.checkboxButton setImage:[UIImage KSO_fontAwesomeImageWithString:@"\uf00c" size:kImageSize].KDI_templateImage forState:UIControlStateNormal];
    [self.lockButton setImage:[UIImage KSO_fontAwesomeImageWithString:@"\uf023" foregroundColor:UIColor.blackColor size:kImageSize] forState:UIControlStateNormal];
    [self.signalButton setImage:[UIImage KSO_fontAwesomeImageWithString:@"\uf1eb" foregroundColor:UIColor.blackColor size:kImageSize] forState:UIControlStateNormal];
}

@synthesize formRow=_formRow;
- (void)setFormRow:(KSOFormRow *)formRow {
    _formRow = formRow;
    
    [self.nameLabel setText:_formRow.value[@"name"]];
    [self.checkboxButton setHidden:![_formRow.value[@"selected"] boolValue]];
}
@synthesize formTheme=_formTheme;

@end
