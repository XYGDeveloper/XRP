//
//  XPGACTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPGACTableViewCell.h"
#import "XPGACModel.h"
#import "XPGetGACModel.h"
@implementation XPGACTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
}

- (void)refreshWithModel:(XPGACModel *)model{
    self.typeLabel.text = [NSString stringWithFormat:@"%@ %@ to %@",kLocat(@"XPInnovacationExchangeViewController_types"),model.from_currency,model.to_currency];
    self.statusLabel.text = model.status_txt;
    self.gacCountLabel.text = [NSString stringWithFormat:@"+%@%@",model.actual,model.to_currency];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"XPInnovacationExchangeViewController_addtime"),model.add_time];
}

//- (void)refreshWithModel1:(XPGetGACModel *)model{
//    self.typeLabel.text = [NSString stringWithFormat:@"%@ %@ to %@",kLocat(@"XPInnovacationExchangeViewController_types"),model.currency_name,@"GAC"];
//    self.statusLabel.text = model.status_txt;
////    self.gacCountLabel.text = [NSString stringWithFormat:@"+%@%@",model.actual,model.to_currency];
////    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"XPInnovacationExchangeViewController_addtime"),model.add_time];
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
