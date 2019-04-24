//
//  TPMainActivityCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMainActivityCell.h"

@implementation TPMainActivityCell


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [_icon setImageWithURL:[NSURL URLWithString:dataDic[@"logo"]] placeholder:nil];
    
    _nameLabel.text = dataDic[@"title"];
    
    _infoLabel.text = [NSString stringWithFormat:@"活动: %@",dataDic[@"currency_mark"]];
    
//    _earningsLabel.text = [NSString stringWithFormat:@"年化收益率：%@%%",dataDic[@"earnings"]];
    _valueLabel.text = [NSString stringWithFormat:@"%@%%",dataDic[@"earnings"]];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    _nameLabel.textColor = kColorFromStr(@"#222222");
    _earningsLabel.textColor = kColorFromStr(@"#E4A646");
    _infoLabel.textColor = kColorFromStr(@"#666666");
    
    _nameLabel.font = PFRegularFont(15);
    _earningsLabel.font = PFRegularFont(12);
    _infoLabel.font = PFRegularFont(12);

    _joinButton.backgroundColor = kColorFromStr(@"#E4A646");
    _joinButton.titleLabel.font = PFRegularFont(12);
    
    _valueLabel.font = PFRegularFont(24);
    _valueLabel.textColor = kColorFromStr(@"#E4A646");
    
    
    
    kViewBorderRadius(_joinButton, 5, 0, kRedColor);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
