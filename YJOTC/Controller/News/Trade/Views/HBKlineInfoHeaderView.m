//
//  HBKlineInfoHeaderView.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/31.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBKlineInfoHeaderView.h"
#import "YTData_listModel.h"

@interface HBKlineInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usdLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfChangeOf24HLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;


@end

@implementation HBKlineInfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kWhiteColor;
    self.maxLabel.text = kLocat(@"k_line_max");
    self.minNameLabel.text = kLocat(@"k_line_min");
    self.volumeLabel.text = kLocat(@"k_line_amout");
    self.volumeLabel.adjustsFontSizeToFitWidth = YES;
    

}

- (void)configViewWithCurrencyMessage:(id)currencyMessage {
    
    ListModel *model = [ListModel mj_objectWithKeyValues:currencyMessage];
    self.priceLabel.text =  model.price;
    
    NSString  *changeOf24H =  model.H24_change;
  
    
    if ([changeOf24H intValue] < 0 ) {
        self.priceLabel.textColor = kColorFromStr(@"EA6E44");
    }else{
        self.priceLabel.textColor = kColorFromStr(@"03C086");
    }
    NSString *changeOf24HString = [NSString stringWithFormat:@"%@%%", changeOf24H];
    self.usdLabel.text = [NSString stringWithFormat:@"≈ %@%@",model.price_usd,model.nw_price_unit];
    self.changeOf24HLabel.text = changeOf24HString;
    self.changeOf24HLabel.textColor = self.priceLabel.textColor;
    self.maxNumberLabel.text = model.max_price;
    self.minNumberLabel.text = model.min_price;
    self.numberOfChangeOf24HLabel.text = model.H24;
}

@end
