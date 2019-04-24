
//
//  TPNewsPriceCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPNewsPriceCell.h"

@interface TPNewsPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *bbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;

@property (weak, nonatomic) IBOutlet UILabel *trendLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end


@implementation TPNewsPriceCell

-(void)setDataDic:(NSDictionary *)dataDic
{
//    _dataDic = dataDic;
    
    
    //+涨  #EA6E44     -跌#03C086
    
}
-(void)setModel:(XPQuotationModel *)model
{
    _model = model;
    
    
    
    
    _bbNameLabel.text = [NSString stringWithFormat:@"%@/%@",_model.currency_mark,_model.trade_currency_mark];
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",model.n_price];
    
    _cnyLabel.text = [NSString stringWithFormat:@"≈%@%@",model.n_price_usd,model.nw_price_unit];
    
    _infoLabel.text= [NSString stringWithFormat:@"%@:%@",kLocat(@"k_line_amout"),model.done_num_24H];
    
    _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24];
    
    if (model.n_price_status.intValue > 0) {//涨
        _trendLabel.backgroundColor = kRiseColor;
        _priceLabel.textColor = kRiseColor;
    }else{
        _trendLabel.backgroundColor = kFallColor;
        _priceLabel.textColor = kFallColor;
    }
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    _leftMargin.constant = (168 - 30) * kScreenWidthRatio;
    
    
    _bbNameLabel.textColor = k222222Color;
    _bbNameLabel.font = PFRegularFont(16);
    
    _infoLabel.textColor = k666666Color;
    _infoLabel.font = PFRegularFont(10);
    
    _cnyLabel.textColor = k222222Color;
    _cnyLabel.font = PFRegularFont(12);
    

    _priceLabel.textColor = k222222Color;
    _priceLabel.font = PFRegularFont(16);
    
    _trendLabel.textColor = kWhiteColor;
    _trendLabel.font = PFRegularFont(12);
    _trendLabel.backgroundColor = kColorFromStr(@"03C086");
    _trendLabel.adjustsFontSizeToFitWidth = YES;
    kViewBorderRadius(_trendLabel, 8, 0, kRedColor);

    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
