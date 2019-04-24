//
//  XPFreeExchangeTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPFreeExchangeTableViewCell.h"
#import "XPGetGACModel.h"
@implementation XPFreeExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithModel:(InnerModel *)model{
    if ([model.type isEqualToString:@"30"]) {
        self.namelabel.text = model.title;
        self.middleLabel.text = model.middle;
        self.bottomLabel.text = model.bottom;
        self.middleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.middleLabel.textColor = kColorFromStr(@"666666");
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@%@%@",model.num_type,model.num,model.currency_name];
    }else if([model.type isEqualToString:@"20"]){
        self.namelabel.text = model.title;
        self.middleLabel.text = model.middle;
        self.bottomLabel.text = model.bottom;
        self.middleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.middleLabel.textColor = kColorFromStr(@"666666");
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@%@%@",model.num_type,model.num,model.currency_name];
    }else{
        self.middleLabel.text = model.title;
        self.middleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.middleLabel.textColor = kColorFromStr(@"222222");
        self.bottomLabel.text = model.bottom;
        self.namelabel.text = @"";
        self.bottomLabel.text = @"";
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@%@%@",model.num_type,model.num,model.currency_name];
    }
    
    if ([model.num_type isEqualToString:@"+"]) {
        self.img.image = [UIImage imageNamed:@"eth_icon_jies"];
    }else{
        self.img.image = [UIImage imageNamed:@"eth_icon_fsong"];
    }
    self.rightBottomLabel.text = model.add_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
