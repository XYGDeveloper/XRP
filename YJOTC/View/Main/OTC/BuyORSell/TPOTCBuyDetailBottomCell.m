//
//  TPOTCBuyDetailBottomCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyDetailBottomCell.h"

@implementation TPOTCBuyDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];


    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    self.itemLabel.textColor = k222222Color;
    self.itemLabel.font = PFRegularFont(14);
    
    self.infoLabel.font = PFRegularFont(14);
    
    self.cpyLabel.font = PFRegularFont(14);
    
    _cpyLabel.textColor = k666666Color;
    _infoLabel.textColor = k666666Color;
    _lineView.backgroundColor = kCCCCCCColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
