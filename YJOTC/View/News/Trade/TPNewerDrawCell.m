
//
//  TPNewerDrawCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPNewerDrawCell.h"

@implementation TPNewerDrawCell

-(void)setModel:(TPQuotationModel *)model
{
    _model = model;
    
    if (model.isSelected) {
        self.contentView.backgroundColor = kColorFromStr(@"#2B3143");
    }else{
        self.contentView.backgroundColor = kColorFromStr(@"#222631");
    }
    
    _NameLabel.text = model.currency_name;
    
    _priceLabel.text = model.nprice;
    
    
    if (model.nprice_status.doubleValue > 0) {

        _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24H];
        
       _trendLabel.textColor = kColorFromStr(@"#03C086");
        _priceLabel.textColor = kColorFromStr(@"#03C086");
    }else{
        
        if (model.change_24H.doubleValue < 0) {
            _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24H];
        }else{
            _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24H];
        }
        _trendLabel.textColor = kColorFromStr(@"#EA6E44");
        _priceLabel.textColor = kColorFromStr(@"#EA6E44"); 
    }
    
}


-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    XPQuotationModel *model = [XPQuotationModel modelWithJSON:dic];
    
    _NameLabel.text = model.currency_mark;
    _priceLabel.text = model.n_price;
    _trendLabel.text = model.change_24;
    
    if (model.n_price_status.intValue > 0) {
        _priceLabel.textColor = kRiseColor;
        _trendLabel.textColor = kRiseColor;

    }else{
        _priceLabel.textColor = kFallColor;
        _trendLabel.textColor = kFallColor;
    }
    
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineView.backgroundColor = kColorFromStr(@"cccccc");
    self.contentView.backgroundColor = kWhiteColor;
    self.selectionStyle = 0;
    
    _NameLabel.textColor = k222222Color;
    _NameLabel.font = PFRegularFont(16);
    
    _priceLabel.textColor = kColorFromStr(@"#CDD2E3");
    _priceLabel.font = PFRegularFont(16);
    
    
    _trendLabel.textColor = kColorFromStr(@"#CDD2E3");
    _trendLabel.font = PFRegularFont(16);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
