//
//  ImagePickerTableViewCell.m
//  Demo-iOS
//
//  Created by William Towe on 10/1/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ImagePickerTableViewCell.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface ImagePickerTableViewCell ()
@property (strong,nonatomic) KDIButton *button;
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@end

@implementation ImagePickerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    kstWeakify(self);
    
    _button = [KDIButton buttonWithType:UIButtonTypeSystem];
    [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_button setTitle:@"Choose Image…" forState:UIControlStateNormal];
    [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_button KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [[UIViewController KDI_viewControllerForPresenting] KDI_presentImagePickerController:controller barButtonItem:nil sourceView:self sourceRect:CGRectZero permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:^(NSDictionary<NSString *,id> * _Nullable info) {
            kstStrongify(self);
            [self.thumbnailImageView setImage:info.KDI_image];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_thumbnailImageView setClipsToBounds:YES];
    [self.contentView addSubview:_thumbnailImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(>=height@priority)]" options:0 metrics:@{@"height": @44.0, @"priority": @(UILayoutPriorityDefaultHigh)} views:@{@"view": self.contentView}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _button}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _button}]];
    
    NSNumber *widthHeight = @32.0;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==width)]-|" options:0 metrics:@{@"width": widthHeight} views:@{@"view": _thumbnailImageView}]];
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:widthHeight.floatValue],[NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
    
    return self;
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
    
    [self.button setContentEdgeInsets:UIEdgeInsetsMake(0, self.layoutMargins.left, 0, 0)];
}

@synthesize formRow=_formRow;
@synthesize formTheme=_formTheme;
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    _formTheme = formTheme;
    
    [self.button.titleLabel setFont:_formTheme.titleFont];
    
    if (_formTheme.titleTextStyle == nil) {
        [NSObject KDI_unregisterDynamicTypeObject:self.button.titleLabel];
    }
    else {
        [NSObject KDI_registerDynamicTypeObject:self.button.titleLabel forTextStyle:_formTheme.titleTextStyle];
    }
}

@end
