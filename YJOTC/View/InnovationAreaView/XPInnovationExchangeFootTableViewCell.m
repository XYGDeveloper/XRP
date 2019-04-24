//
//  XPInnovationExchangeFootTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovationExchangeFootTableViewCell.h"
#import "XPExchangeInnocationModel.h"
@implementation XPInnovationExchangeFootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    kViewBorderRadius(self.senderButton, 8, 0, kRedColor);
    [self.senderButton addShadow];
    self.chuzhangLabel.text = kLocat(@"XPInnovacationExchangeViewController_ruzhang");
    self.countNameLabel.text = kLocat(@"XPInnovacationExchangeViewController_jieshoucount");
    [self.senderButton setTitle:kLocat(@"XPInnovacationExchangeViewController_submit") forState:UIControlStateNormal];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
