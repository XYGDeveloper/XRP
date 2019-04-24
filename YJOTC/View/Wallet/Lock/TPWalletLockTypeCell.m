//
//  TPWalletLockTypeCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletLockTypeCell.h"

@implementation TPWalletLockTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    _title.font = PFRegularFont(16);
    _title.textColor = kDarkGrayColor;
    
    _volumeLabel.font = PFRegularFont(30);
    _volumeLabel.textColor = kLightGrayColor;
    
    _cnyLabel.font = PFRegularFont(12);
    _cnyLabel.textColor = kDarkGrayColor;
    
    _typeLabel.font = PFRegularFont(14);
    _typeLabel.textColor = kDarkGrayColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
