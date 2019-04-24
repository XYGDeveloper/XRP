//
//  TPOTCBuyDetailPayWayNotCardCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetailPayWayNotCardCell.h"

@implementation TPOTCBuyDetailPayWayNotCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kTableColor;
    self.selectionStyle  = 0;
    self.wayLabel.textColor = k222222Color;
    self.wayLabel.font = PFRegularFont(16);
    
    self.wayButton.userInteractionEnabled = NO;
    
    [self.wayButton setImage:kImageFromStr(@"fu_icon_gno") forState:UIControlStateNormal];
    [self.wayButton setImage:kImageFromStr(@"fu_icon_gpre") forState:UIControlStateSelected];

    self.lineView.backgroundColor = kCCCCCCColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
