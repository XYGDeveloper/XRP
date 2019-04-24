//
//  XPFreeExchangeHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPFreeExchangeHeaderTableViewCell.h"
#import "XPGetGACModel.h"
@implementation XPFreeExchangeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.freezeLabel.text = kLocat(@"XPFreezeListViewController_left");
    self.middleLabel.text = kLocat(@"XPFreezeListViewController_middle");
    self.rightLabel.text = kLocat(@"XPFreezeListViewController_right");
    // Initialization code
}

- (void)refreshWithModel:(XPGetGACModel *)model{
    self.freezeContentlabel.text = model.user_num;
    self.middleContentLabel.text = model.release_ratio;
    self.rightContentLabel.text = model.today_num;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
