//
//  TPBiToBiListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPBiToBiListCell.h"

@interface TPBiToBiListCell ()
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exCurrencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *trendButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;


@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;


@end


@implementation TPBiToBiListCell


-(void)setModel:(TPQuotationModel *)model
{
    _model = model;
    
    if (_isBCB) {
        _exCurrencyNameLabel.text = @"/BCB";
    }else{
        _exCurrencyNameLabel.text = @"/ETH";
    }
    _currencyNameLabel.text = model.currency_name;
    
    if (model.nprice_status.doubleValue > 0) {
        _trendButton.backgroundColor = kColorFromStr(@"#03C086");
        [_trendButton setTitle:[NSString stringWithFormat:@"%@%%",model.change_24H] forState:UIControlStateNormal];
    }else{
        _trendButton.backgroundColor = kColorFromStr(@"#EA6E44");
        if (model.change_24H.doubleValue < 0) {
            [_trendButton setTitle:[NSString stringWithFormat:@"%@%%",model.change_24H] forState:UIControlStateNormal];
        }else{
            [_trendButton setTitle:[NSString stringWithFormat:@"%@%%",model.change_24H] forState:UIControlStateNormal];
        }
    }
    
    _topLabel.text = model.nprice;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.cny];
    _amountLabel.text = [NSString stringWithFormat:@"24H量 %@",model.done_24H];
    
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = kColorFromStr(@"#1F2225");
    
    self.selectionStyle = 0;
    _leftMargin.constant = 155 *kScreenWidthRatio;
    _currencyNameLabel.textColor = kColorFromStr(@"#CDD2E3");
    _currencyNameLabel.font = [PFRegularFont(18) fontWithBold];
    
    _exCurrencyNameLabel.textColor = kColorFromStr(@"#9498A73");
    _exCurrencyNameLabel.font = PFRegularFont(10);
    
    _topLabel.textColor = kColorFromStr(@"#CDD2E3");
    _topLabel.font = [PFRegularFont(18) fontWithBold];
    
    [_trendButton setTitleColor:kColorFromStr(@"#CDD2E3") forState:UIControlStateNormal];
    _trendButton.titleLabel.font = [PFRegularFont(14) fontWithBold];
    _trendButton.backgroundColor = kColorFromStr(@"#EA6E44");
    
    _amountLabel.textColor = kColorFromStr(@"#9498A73");
    _amountLabel.font = PFRegularFont(12);
    
    _priceLabel.textColor = kColorFromStr(@"#9498A73");
    _priceLabel.font = PFRegularFont(12);
    
    _trendButton.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
