//
//  XPMoodEightImageCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodEightImageCell.h"
#import "XPMoodCellLayout.h"

@interface XPMoodEightImageCell ()

@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIImageView *twoImageView;
@property (nonatomic, strong) UIImageView *threeImageView;
@property (nonatomic, strong) UIImageView *fourImageView;
@property (nonatomic, strong) UIImageView *fiveImageView;
@property (nonatomic, strong) UIImageView *sixImageView;
@property (nonatomic, strong) UIImageView *sevenImageView;
@property (nonatomic, strong) UIImageView *eightImageView;


@end

@implementation XPMoodEightImageCell

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
        _sevenImageView = [self createImageView];
        _eightImageView = [self createImageView];
        
        [self.containerView addSubview:_oneImageView];
        [self.containerView addSubview:_twoImageView];
        [self.containerView addSubview:_threeImageView];
        [self.containerView addSubview:_fourImageView];
        [self.containerView addSubview:_fiveImageView];
        [self.containerView addSubview:_sixImageView];
        [self.containerView addSubview:_sevenImageView];
        [self.containerView addSubview:_eightImageView];
    }
    
    return self;
}

#pragma mark - Publich

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    [super configureCellWithModel:model layout:layout];
    
    self.oneImageView.frame = layout.eightImageViewLayout.imageView1Frame;
    self.twoImageView.frame = layout.eightImageViewLayout.imageView2Frame;
    self.threeImageView.frame = layout.eightImageViewLayout.imageView3Frame;
    self.fourImageView.frame = layout.eightImageViewLayout.imageView4Frame;
    self.fiveImageView.frame = layout.eightImageViewLayout.imageView5Frame;
    self.sixImageView.frame = layout.eightImageViewLayout.imageView6Frame;
    self.sevenImageView.frame = layout.eightImageViewLayout.imageView7Frame;
    self.eightImageView.frame = layout.eightImageViewLayout.imageView8Frame;
}

@end
