//
//  TPIdentifyCell.m
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPIdentifyCell.h"

@implementation TPIdentifyCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.lineView.backgroundColor = kColorFromStr(@"#111419");
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    
    self.itemLabel.textColor = kColorFromStr(@"#CDD2E3");
    self.tf.textColor = self.itemLabel.textColor;
    self.itemLabel.font = PFRegularFont(14);
    self.tf.font = PFRegularFont(14);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
