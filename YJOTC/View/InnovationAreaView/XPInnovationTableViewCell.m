//
//  XPInnovationTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovationTableViewCell.h"
#import "XPInnovationModel.h"
@implementation XPInnovationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
 
    // Initialization code
}

- (void)refreshWithModel:(XPInnovationModel *)model{
    self.img.image = [UIImage imageNamed:@"exchange"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",model.gac_exchange_name,model.forzen_num];
}

- (void)refreshWithModel1:(XPInnovationModel *)model1{
    self.img.image = [UIImage imageNamed:@"cander"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",model1.gac_reward_name,model1.reward_num];
}

- (void)refreshWithModel2:(XPInnovationModel *)model1{
    self.img.image = [UIImage imageNamed:@"gac_inner"];
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",model1.gac_internal_buy_name,model1.internal_buy_num];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
