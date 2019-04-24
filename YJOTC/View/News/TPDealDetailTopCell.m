//
//  TPDealDetailTopCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPDealDetailTopCell.h"

@interface TPDealDetailTopCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLabelLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelLeftMargin;

@property (weak, nonatomic) IBOutlet UILabel *dealAmount;
@property (weak, nonatomic) IBOutlet UILabel *dealAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *charge;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;


@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (weak, nonatomic) IBOutlet UILabel *dealA;
@property (weak, nonatomic) IBOutlet UILabel *dealALabel;


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *biLabel;


@property (weak, nonatomic) IBOutlet UILabel *last;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end


@implementation TPDealDetailTopCell


-(void)setType:(NSInteger)type
{
    _type = type;
    if (type == 1) {
        _arrow.hidden = YES;
        _arrowLabel.hidden = YES;

        _lastLabel.hidden = YES;
        _last.hidden = YES;
    }
    
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    if ([dataDic[@"type"] isEqualToString:@"buy"]) {
        _typeLabel.text = @"買入";
        _typeLabel.textColor = kColorFromStr(@"#03C086");
    }else{
        _typeLabel.text = @"賣出";
        _typeLabel.textColor = kColorFromStr(@"#EA6E44");
    }
    

    
    if (_type == 2) {
        _arrowLabel.textColor = kColorFromStr(@"6078C7");
        _arrow.hidden = YES;
        _arrowLabel.text = @"撤銷";
    }else if (_type == 0){
        _arrowLabel.textColor = k222222Color;
        _arrowLabel.text = dataDic[@"status_name"];
        if ([dataDic[@"trade_num"] doubleValue] > 0) {
            _arrow.hidden = NO;
        }else{
            _arrow.hidden = YES;
        }
    }else{
        _arrow.hidden = YES;
        _arrowLabel.hidden = YES;
    }
    
        _biLabel.text = [NSString stringWithFormat:@"%@/%@",dataDic[@"currency_name"],dataDic[@"market"]];

    
    if (_type == 1) {
        
        _dealAmount.text = [NSString stringWithFormat:@"成交總額(%@)",dataDic[@"market"]];
        _dealAmountLabel = dataDic[@"trade_total"];
        
        _charge.text = [NSString stringWithFormat:@"手續費(%@)",dataDic[@"market"]];
        _chargeLabel.text = ConvertToString(dataDic[@"fee"]);
        
        _price.text = [NSString stringWithFormat:@"成交均價(%@)",dataDic[@"market"]];
        _priceLabel.text = dataDic[@"avg_price"];
        
        
        _cost.hidden = YES;
        _costLabel.hidden = YES;
        
        _dealA.text = [NSString stringWithFormat:@"成交量(%@)",dataDic[@"currency_name"]];
        _dealALabel.text = dataDic[@"num"];
        
        _last.hidden = YES;
        _lastLabel.hidden = YES;
        
        

    }else{
        
        _dealAmount.text = @"時間";
        _dealAmountLabel.text = dataDic[@"add_time"];
        
        _charge.text = [NSString stringWithFormat:@"成交總額(%@)",dataDic[@"market"]];
        _chargeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"trade_total"]];
        
        _price.text = [NSString stringWithFormat:@"委託價(%@)",dataDic[@"market"]];
        _priceLabel.text = dataDic[@"price"];
        
        
        _cost.text = [NSString stringWithFormat:@"成交均價(%@)",dataDic[@"market"]];
        _costLabel.text = dataDic[@"avg_price"];
        
        _dealA.text = [NSString stringWithFormat:@"委託量(%@)",dataDic[@"currency_name"]];
        _dealALabel.text = dataDic[@"num"];
        
        _last.text = [NSString stringWithFormat:@"成交量(%@)",dataDic[@"currency_name"]];
        _lastLabel.text = dataDic[@"trade_num"];
    }
    
    
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    
    self.contentView.backgroundColor = kWhiteColor;
    
    
    _biLabel.font = PFRegularFont(16);
    _biLabel.textColor = k222222Color;
    _typeLabel.font = PFRegularFont(16);
    _typeLabel.textColor = _biLabel.textColor;
    
    
    _midLabelLeftMargin.constant = 138 *kScreenWidthRatio;
    _rightLabelLeftMargin.constant = 292 *kScreenWidthRatio;
    
    
    _dealAmount.font = PFRegularFont(12);
    _dealAmount.textColor = kColorFromStr(@"#666666");
    _dealAmountLabel.font = PFRegularFont(12);
    _dealAmountLabel.textColor = k222222Color;
    
    
    
    _charge.font = PFRegularFont(12);
    _charge.textColor = kColorFromStr(@"#666666");
    _chargeLabel.font = PFRegularFont(12);
    _chargeLabel.textColor = k222222Color;
    
    _price.font = PFRegularFont(12);
    _price.textColor = kColorFromStr(@"#666666");
    _priceLabel.font = PFRegularFont(12);
    _priceLabel.textColor = k222222Color;
    
    _cost.font = PFRegularFont(12);
    _cost.textColor = kColorFromStr(@"#666666");
    _costLabel.font = PFRegularFont(12);
    _costLabel.textColor = k222222Color;
    
    _dealA.font = PFRegularFont(12);
    _dealA.textColor = kColorFromStr(@"#666666");
    _dealALabel.font = PFRegularFont(12);
    _dealALabel.textColor = k222222Color;
    
    
    _last.font = PFRegularFont(12);
    _last.textColor = kColorFromStr(@"#666666");
    _lastLabel.font = PFRegularFont(12);
    _lastLabel.textColor = k222222Color;
    
    
    
    
    //卖出  #EA6E44
    //买入  #03C086
    _typeLabel.textColor = kColorFromStr(@"#EA6E44");
    
    
    _arrowLabel.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
