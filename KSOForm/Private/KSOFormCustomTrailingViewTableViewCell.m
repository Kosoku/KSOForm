//
//  KSOFormCustomTrailingViewTableViewCell.m
//  KSOForm-iOS
//
//  Created by William Towe on 2/25/18.
//  Copyright © 2018 Kosoku Interactive, LLC. All rights reserved.
//

#import "KSOFormCustomTrailingViewTableViewCell.h"
#import "KSOFormImageTitleSubtitleView.h"
#import "KSOFormRow.h"
#import "KSOFormTheme.h"

@interface KSOFormCustomTrailingViewTableViewCell ()
@property (strong,nonatomic) KSOFormImageTitleSubtitleView *leadingView;
@property (strong,nonatomic) __kindof UIView<KSOFormRowView> *trailingView;
@end

@implementation KSOFormCustomTrailingViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setLeadingView:[[KSOFormImageTitleSubtitleView alloc] initWithFrame:CGRectZero]];
    [self.leadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leadingView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.leadingView];
    
    return self;
}

- (BOOL)wantsTrailingViewTopBottomLayoutMargins {
    return NO;
}

- (BOOL)canEditFormRow {
    return self.trailingView.canEditFormRow;
}
- (BOOL)isEditingFormRow {
    return self.trailingView.isEditingFormRow;
}
- (void)beginEditingFormRow {
    [self.trailingView beginEditingFormRow];
}

@dynamic leadingView;
@dynamic trailingView;
- (void)setTrailingView:(__kindof UIView *)trailingView {
    [self.trailingView removeFromSuperview];
    
    [super setTrailingView:trailingView];
    
    if (trailingView != nil) {
        [self.contentView addSubview:trailingView];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setFormRow:(KSOFormRow *)formRow {
    [super setFormRow:formRow];
    
    [self.leadingView setFormRow:formRow];
    
    [self setTrailingView:formRow.cellTrailingView];
    [self.trailingView setFormRow:formRow];
}
- (void)setFormTheme:(KSOFormTheme *)formTheme {
    [super setFormTheme:formTheme];
    
    [self.leadingView setFormTheme:formTheme];
    [self.trailingView setFormTheme:formTheme];
}

@end
