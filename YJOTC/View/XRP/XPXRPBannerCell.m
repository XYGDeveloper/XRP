//
//  XPXRPBannerCell.m
//  YJOTC
//
//  Created by 周勇 on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPXRPBannerCell.h"

@implementation XPXRPBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.bgView.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kBGColor;
    
    
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
