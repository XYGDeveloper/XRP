//
//  XPMoodSixImageCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodSixImageCell.h"
#import "XPMoodCellLayout.h"

@interface XPMoodSixImageCell ()

@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIImageView *twoImageView;
@property (nonatomic, strong) UIImageView *threeImageView;
@property (nonatomic, strong) UIImageView *fourImageView;
@property (nonatomic, strong) UIImageView *fiveImageView;
@property (nonatomic, strong) UIImageView *sixImageView;

@end

@implementation XPMoodSixImageCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _oneImageView = [self createImageView];
        _twoImageView = [self createImageView];
        _threeImageView = [self createImageView];
        _fourImageView = [self createImageView];
        _fiveImageView = [self createImageView];
        _sixImageView = [self createImageView];
        
        [self.containerView addSubview:_oneImageView];
        [self.containerView addSubview:_twoImageView];
        [self.containerView addSubview:_threeImageView];
        [self.containerView addSubview:_fourImageView];
        [self.containerView addSubview:_fiveImageView];
        [self.containerView addSubview:_sixImageView];
    }
    
    return self;
}

#pragma mark - Publich

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    [super configureCellWithModel:model layout:layout];
    
    self.oneImageView.frame = layout.sixImageViewLayout.imageView1Frame;
    self.twoImageView.frame = layout.sixImageViewLayout.imageView2Frame;
    self.threeImageView.frame = layout.sixImageViewLayout.imageView3Frame;
    self.fourImageView.frame = layout.sixImageViewLayout.imageView4Frame;
    self.fiveImageView.frame = layout.sixImageViewLayout.imageView5Frame;
    self.sixImageView.frame = layout.sixImageViewLayout.imageView6Frame;
}

@end
