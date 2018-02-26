//
//  ImagePickerView.m
//  Demo-iOS
//
//  Created by William Towe on 2/25/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//

#import "ImagePickerView.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>

@interface ImagePickerView ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@end

@implementation ImagePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_thumbnailImageView setClipsToBounds:YES];
    [self addSubview:_thumbnailImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(==width)]|" options:0 metrics:@{@"width": @32.0} views:@{@"view": _thumbnailImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==height)]|" options:0 metrics:@{@"height": @32.0} views:@{@"view": _thumbnailImageView}]];
    
    return self;
}

@synthesize formRow=_formRow;
@synthesize formTheme=_formTheme;
- (BOOL)canEditFormRow {
    return YES;
}
- (BOOL)isEditingFormRow {
    return NO;
}
- (void)beginEditingFormRow {
    kstWeakify(self);
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [[UIViewController KDI_viewControllerForPresenting] KDI_presentImagePickerController:controller barButtonItem:nil sourceView:self sourceRect:CGRectZero permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:^(NSDictionary<NSString *,id> * _Nullable info) {
        kstStrongify(self);
        if (info != nil) {
            [self.thumbnailImageView setImage:info.KDI_image];
        }
    }];
}

@end
