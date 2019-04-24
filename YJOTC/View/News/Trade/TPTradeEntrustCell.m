//
//  TPTradeEntrustCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTradeEntrustCell.h"

@interface TPTradeEntrustCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLabelLeftMargin;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@property (weak, nonatomic) IBOutlet UILabel *volume;

@property (weak, nonatomic) IBOutlet UILabel *volumLabel;

@property (weak, nonatomic) IBOutlet UILabel *deal;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;


@end


@implementation TPTradeEntrustCell


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    //卖出  #EA6E44
    //买入  #03C086
    if ([dataDic[@"type"] isEqualToString:@"buy"]) {
        _typeLabel.text = @"買入";
        
        _typeLabel.textColor = kRiseColor;
        
    }else{
        _typeLabel.text = @"賣出";
        _typeLabel.textColor = kFallColor;

    }
    
    
    _timeLabel.text = dataDic[@"add_time"];
    
    _priceLabel.text = dataDic[@"price"];
    _price.text = [NSString stringWithFormat:@"%@(%@)",kLocat(@"Price"),dataDic[@"market"]];
    

    _volume.text = [NSString stringWithFormat:@"%@(%@)",kLocat(@"k_HBTradeJLViewController_count"),dataDic[@"currency_name"]];
    _volumLabel.text = dataDic[@"num"];
    
    _deal.text = [NSString stringWithFormat:@"%@(%@)",kLocat(@"H_realdeal"),dataDic[@"currency_name"]];
    _dealLabel.text = dataDic[@"trade_num"];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    
    _midLabelLeftMargin.constant = 138 *kScreenWidthRatio;

    
    //卖出  #EA6E44
    //买入  #03C086
    _typeLabel.textColor = kColorFromStr(@"#EA6E44");
    _typeLabel.font = PFRegularFont(16);
    
    _timeLabel.textColor = kColorFromStr(@"#707589");
    _timeLabel.font = PFRegularFont(12);
    
    
    _price.textColor = kColorFromStr(@"707589");
    _priceLabel.textColor = kColorFromStr(@"979CAD");
    
    _volume.textColor = kColorFromStr(@"707589");
    _volumLabel.textColor = kColorFromStr(@"979CAD");
    
    _deal.textColor = kColorFromStr(@"707589");
    _dealLabel.textColor = kColorFromStr(@"979CAD");
    
    _priceLabel.font = PFRegularFont(12);
    _price.font = PFRegularFont(12);
    _volume.font = PFRegularFont(12);
    _volumLabel.font = PFRegularFont(12);
    _deal.font = PFRegularFont(12);
    _dealLabel.font = PFRegularFont(12);

    [_cancelButton setTitleColor:kColorFromStr(@"#6078C7") forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = PFRegularFont(14);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
