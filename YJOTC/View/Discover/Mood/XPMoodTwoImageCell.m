//
//  XPMoodTwoImageCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodTwoImageCell.h"
#import "XPMoodCellLayout.h"

@interface XPMoodTwoImageCell ()

@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIImageView *twoImageView;

@end

@implementation XPMoodTwoImageCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _oneImageView = [self createImageView];
        _twoImageView = [self createImageView];
        
        [self.containerView addSubview:_oneImageView];
        [self.containerView addSubview:_twoImageView];
    }
    
    return self;
}

#pragma mark - Publich

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    [super configureCellWithModel:model layout:layout];
    
    self.oneImageView.frame = layout.twoImageViewLayout.imageView1Frame;
    self.twoImageView.frame = layout.twoImageViewLayout.imageView2Frame;
}


@end
