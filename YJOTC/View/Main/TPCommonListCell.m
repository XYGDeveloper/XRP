//
//  TPCommonListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPCommonListCell.h"

@implementation TPCommonListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
//    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    _itemLabel.textColor = k666666Color;
    _itemLabel.font = PFRegularFont(16);
    
    _infoLabel.textColor = k999999Color;
    _infoLabel.font = PFRegularFont(16);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
