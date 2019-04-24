//
//  XPMoodBiggerImageCell.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/12.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMoodBiggerImageCell.h"
#import "XPMoodCellLayout.h"

@interface XPMoodBiggerImageCell ()

@property (nonatomic, strong) UIImageView *biggerImageView;

@end

@implementation XPMoodBiggerImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.containerView addSubview:self.biggerImageView];
    }
    return self;
}

- (void)configureCellWithModel:(YWDynamicModel *)model layout:(XPMoodCellLayout *)layout {
    [super configureCellWithModel:model layout:layout];
    
    self.biggerImageView.frame = layout.biggerImageViewLayout.biggerImageViewFrame;
}

#pragma mark - Getters

- (UIImageView *)biggerImageView {
    if (!_biggerImageView) {
        _biggerImageView = [UIImageView new];
        _biggerImageView.backgroundColor = kColorFromStr(@"F4F4F4");
    }
    
    return _biggerImageView;
}

@end
