//
//  TPWalletReleaseCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletReleaseCell.h"

@implementation TPWalletReleaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    self.title.font = PFRegularFont(14);
    self.title.textColor = kLightGrayColor;
    
    self.typeLabel.font = PFRegularFont(12);
    self.typeLabel.textColor = kLightGrayColor;
    
    self.timeLabel.font = PFRegularFont(10);
    self.timeLabel.textColor = kColorFromStr(@"#03C086");
    
    self.volumeLabel.font = PFRegularFont(14);
    self.volumeLabel.textColor = kColorFromStr(@"#03C086");
    
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    self.typeLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
