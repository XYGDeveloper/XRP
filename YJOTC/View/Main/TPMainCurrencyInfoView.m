//
//  TPMainCurrencyInfoView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMainCurrencyInfoView.h"

@interface TPMainCurrencyInfoView()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *cnyLabel;
@property(nonatomic,strong)UILabel *trendLabel;
@property(nonatomic,strong)UILabel *priceLabel;


@end


@implementation TPMainCurrencyInfoView



-(void)setModel:(XPQuotationModel *)model
{
    _model = model;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@/%@",model.currency_mark,model.trade_currency_mark];

    _priceLabel.text = [NSString stringWithFormat:@"%@",model.n_price];

    _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24];

    
    _cnyLabel.text = [NSString stringWithFormat:@"≈%@%@",model.n_price_usd,model.nw_price_unit];
    
    if (model.n_price_status.intValue > 0) {//涨
        _trendLabel.textColor = kRiseColor;
        _priceLabel.textColor = kRiseColor;
    }else{
        _trendLabel.textColor = kFallColor;
        _priceLabel.textColor = kFallColor;
    }
}

//-(void)setModel:(TPQuotationModel *)model
//{
//    _model = model;
//
//
//    _nameLabel.text = [NSString stringWithFormat:@"%@/%@",model.currency_mark,model.trade_currency_mark];
//    _priceLabel.text = model.nprice;
//    _cnyLabel.text = [NSString stringWithFormat:@"≈%@CNY",model.n_price_usd];
//
//
//
//    if (model.nprice_status.intValue > 0) {
//
//        _priceLabel.textColor = kColorFromStr(@"#39CB85");
//        _trendLabel.textColor = kColorFromStr(@"#39CB85");
//        _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24H];
//
//    }else{
//        _priceLabel.textColor = kColorFromStr(@"#EC4242");
//        _trendLabel.textColor = kColorFromStr(@"#EC4242");
//        _trendLabel.text = [NSString stringWithFormat:@"%@%%",model.change_24H];
//    }
//
//
//}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
    
}

-(void)setupUI
{
    self.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 9, self.width, 12) text:@"BTC/BCB" font:PFRegularFont(12) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    [self addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:kRectMake(0, titleLabel.bottom + 12, self.width, 15) text:@"BTC/BCB" font:PFRegularFont(16) textColor:kColorFromStr(@"#E96E44") textAlignment:1 adjustsFont:YES];
    [self addSubview:priceLabel];
    
    
    UILabel *trendLabel = [[UILabel alloc] initWithFrame:kRectMake(0, priceLabel.bottom + 4, self.width, 12) text:@"BTC/BCB" font:PFRegularFont(12) textColor:kColorFromStr(@"#CDD2E3") textAlignment:1 adjustsFont:YES];
    [self addSubview:trendLabel];
    
    
    UILabel *cnyLabel = [[UILabel alloc] initWithFrame:kRectMake(0, trendLabel.bottom + 8, self.width, 12) text:@"BTC/BCB" font:PFRegularFont(12) textColor:k666666Color textAlignment:1 adjustsFont:YES];
    [self addSubview:cnyLabel];
    
    
    _nameLabel = titleLabel;
    _priceLabel = priceLabel;
    _trendLabel = trendLabel;
    _cnyLabel = cnyLabel;
    
}





@end
