//
//  TPMineCommenCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/1.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMineCommenCell.h"

@implementation TPMineCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kWhiteColor;
    self.selectionStyle = 0;
    
//    kViewBorderRadius(_itemIcon, 12.5, 0, kRedColor);
    
    _itemLabel.textColor = k222222Color;
    _itemLabel.font = PFRegularFont(16);
    
    _descLabel.textColor = kColorFromStr(@"#999999");
    _descLabel.font = PFRegularFont(12);
    
    _descLabel.hidden = YES;
    
    _lineView.backgroundColor = kGrayLineColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
