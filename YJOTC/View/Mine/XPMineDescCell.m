

//
//  XPMineDescCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/8.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMineDescCell.h"

@implementation XPMineDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _line.backgroundColor = kGrayLineColor;
    
    _itemLabel.textColor = k222222Color;
    _itemLabel.font = PFRegularFont(14);
    
    _descLabel.textColor = k999999Color;
    _descLabel.font = PFRegularFont(12);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
