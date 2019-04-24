//
//  XPCommunityHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/24.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityHeaderTableViewCell.h"

@implementation XPCommunityHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    kViewBorderRadius(self.bannerImg, 8, 0, kRedColor);
    [self.bannerImg addShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
