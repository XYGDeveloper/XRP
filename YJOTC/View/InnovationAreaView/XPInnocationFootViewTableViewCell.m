//
//  XPInnocationFootViewTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnocationFootViewTableViewCell.h"

@implementation XPInnocationFootViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.senderButton, 8, 0, kRedColor);
    [self.senderButton addShadow];
    kViewBorderRadius(self.InnerPuButton, 8, 0, kRedColor);
    [self.InnerPuButton addShadow];
    [self.senderButton setTitle:kLocat(@"XPInnovationHomeViewController_exchange") forState:UIControlStateNormal];
    [self.InnerPuButton setTitle:kLocat(@"XPInternalPurchaseViewController_title1") forState:UIControlStateNormal];

//    self.noticeLabel.text = kLocat(@"XPInnovationHomeViewController_notice");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
