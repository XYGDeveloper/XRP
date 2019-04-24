//
//  XPInnocationExcangeTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnocationExcangeTableViewCell.h"
#import "XPExchangeInnocationModel.h"

@implementation XPInnocationExcangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desLabel.text = kLocat(@"XPInnovacationExchangeViewController_yesPrice");
    // Initialization code
}

- (void)refreshWithModel:(XPExchangeInnocationModel *)model{
    self.letCurrencyLabel.text = [NSString stringWithFormat:@"%@/CNY",model.from_currency];
    self.rightCurrencyLabel.text = [NSString stringWithFormat:@"%@/CNY",model.to_currency];
    self.letBottomLabel.text = model.from_cny;
    self.rightBottomLabel.text = model.to_cny;
    self.bottomLabel.text = [NSString stringWithFormat:@"%@：1%@≈%@%@",kLocat(@"XPInnovacationExchangeViewController_yuji"),model.from_currency,model.ratio,model.to_currency];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
