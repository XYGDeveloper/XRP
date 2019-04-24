//
//  TPOTCPayWayListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/23.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPayWayListCell.h"

@implementation TPOTCPayWayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = kTableColor;
    self.selectionStyle = 0;
   
    self.typeLabel.textColor = k222222Color;
    self.typeLabel.font = PFRegularFont(12);
    
    self.accountLabel.textColor = k666666Color;
    self.accountLabel.font = PFRegularFont(16);
    
    _paySwitch.tintColor = kColorFromStr(@"#6189C5");
    _paySwitch.onTintColor = kColorFromStr(@"#6189C5");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
