//
//  XPExchangeHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPExchangeHeaderTableViewCell.h"
#import "XPExchangeInnocationModel.h"

@implementation XPExchangeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.chuzhangLabel.text = kLocat(@"XPInnovacationExchangeViewController_chuzhang");
    self.countNameLabel.text = kLocat(@"XPInnovacationExchangeViewController_fasongucount");
    // Initialization code
}

//- (void)refreshWithModel:(XPExchangeInnocationModel *)model{
//   
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
