
//
//  XPAssetBankProgressCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankProgressCell.h"

@implementation XPAssetBankProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor =kTableColor;
    
    _addTime.font = PFRegularFont(12);
    _addTime.textColor = k222222Color;
    _manager.font = PFRegularFont(12);
    _manager.textColor = k222222Color;
    _endTime.font = PFRegularFont(12);
    _endTime.textColor = k222222Color;
    
    _addtimeLabel.font = PFRegularFont(10);
    _addtimeLabel.textColor = k666666Color;
    _managerLabel.font = PFRegularFont(10);
    _managerLabel.textColor = k666666Color;
    _endtimeLabel.font = PFRegularFont(10);
    _endtimeLabel.textColor = k666666Color;
    
    _addTime.text = kLocat(@"z_addtime");
    _manager.text = kLocat(@"z_managetime");
    _endTime.text = kLocat(@"z_endtime");

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
