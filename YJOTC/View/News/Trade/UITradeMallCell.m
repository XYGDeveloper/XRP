//
//  UITradeMallCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "UITradeMallCell.h"

@interface UITradeMallCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewW;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *amountView;

@property (weak, nonatomic) IBOutlet UILabel *panKouLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPriceMargin;


@end

@implementation UITradeMallCell

//上面是卖盘
-(void)setBuyArray:(NSArray *)buyArray
{
    _buyArray = buyArray;
    [self.bottomPanKouView removeAllSubviews];
    
    if (buyArray.count == 0) {
        return;
    }
    CGFloat w = kScreenW - 24 - self.leftViewW.constant - 14;
    CGFloat h = 33;
    
    for (NSInteger i = 0; i < buyArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, h * i, w, h)];
        [self.bottomPanKouView addSubview:view];
        view.tag = i;
        view.userInteractionEnabled = YES;
        view.backgroundColor = kColorFromStr(@"#222631");
                                             
        UILabel *panKouLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 10, h) text:[NSString stringWithFormat:@"%zd",5-i] font:PFRegularFont(12) textColor:kColorFromStr(@"#979CAD") textAlignment:0 adjustsFont:YES];
        [view addSubview:panKouLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:kRectMake(26, 0, w - 62 - 26, h) text:buyArray[i][@"price"] font:PFRegularFont(12) textColor:kColorFromStr(@"#03C086") textAlignment:2 adjustsFont:YES];
        [view addSubview:priceLabel];
        priceLabel.right = w - _topPriceMargin.constant;
    
        UILabel *number = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 35, h) text:buyArray[i][@"avail"] font:PFRegularFont(12) textColor:kColorFromStr(@"#979CAD") textAlignment:2 adjustsFont:YES];
        [view addSubview:number];
//        number.text = [NSString stringWithFormat:@"%.2f",[buyArray[i][@"avail"] doubleValue]];

        number.text = [NSString floatOne:[NSString stringWithFormat:@"%@",buyArray[i][@"avail"]] calculationType:CalculationTypeForAdd floatTwo:@"0"];
        
        number.right = view.right;
//        view.backgroundColor = kRandColor;
        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDidClickPriceList:)]];
        
    }
}





-(void)setSellArray:(NSArray *)sellArray
{
    _sellArray = sellArray;
    [self.topPanKouView removeAllSubviews];
    
    if (sellArray.count == 0) {
        return;
    }
    CGFloat w = kScreenW - 24 - self.leftViewW.constant - 14;
    CGFloat h = 33;
    
    for (NSInteger i = 0; i < sellArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, h * i, w, h)];
        [self.topPanKouView addSubview:view];
        view.tag = i+5;
        view.userInteractionEnabled = YES;
        view.backgroundColor = kColorFromStr(@"#222631");
        
        UILabel *panKouLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 10, h) text:[NSString stringWithFormat:@"%zd",i+1] font:PFRegularFont(12) textColor:kColorFromStr(@"#979CAD") textAlignment:0 adjustsFont:YES];
        [view addSubview:panKouLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:kRectMake(26, 0, w - 62 - 26, h) text:sellArray[i][@"price"] font:PFRegularFont(12) textColor:kColorFromStr(@"#EA6E44") textAlignment:2 adjustsFont:YES];
        [view addSubview:priceLabel];
        priceLabel.right = w - _topPriceMargin.constant;

        
        
        
        UILabel *number = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 35, h) text:sellArray[i][@"avail"] font:PFRegularFont(12) textColor:kColorFromStr(@"#979CAD") textAlignment:2 adjustsFont:YES];
//        number.text = [NSString stringWithFormat:@"%@",@([sellArray[i][@"avail"] doubleValue])];
        
        number.text = [NSString floatOne:[NSString stringWithFormat:@"%@",sellArray[i][@"avail"]] calculationType:CalculationTypeForAdd floatTwo:@"0"];

        
        [view addSubview:number];
        number.right = view.right;
        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDidClickPriceList:)]];
        
    }
}





- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    
    self.leftViewW.constant = 190 *kScreenWidthRatio;
    
    
    [_buyButton setBackgroundImage:kImageFromStr(@"mairu_icon_4") forState:UIControlStateNormal];
    [_buyButton setBackgroundImage:kImageFromStr(@"mairu_icon_3") forState:UIControlStateSelected];
    [_buyButton setTitle:kLocat(@"k_MyassetDetailViewController_wt_mr") forState:UIControlStateNormal];
    [_buyButton setTitle:kLocat(@"k_MyassetDetailViewController_wt_mr") forState:UIControlStateSelected];
    _buyButton.titleLabel.font = PFRegularFont(16);
    [_buyButton setTitleColor:k666666Color forState:UIControlStateNormal];
    [_buyButton setTitleColor:kRiseColor forState:UIControlStateSelected];

    [_sellButton setBackgroundImage:kImageFromStr(@"mairu_icon_18") forState:UIControlStateNormal];
    [_sellButton setBackgroundImage:kImageFromStr(@"maichu_icon_18") forState:UIControlStateSelected];
    [_sellButton setTitle:kLocat(@"k_MyassetDetailViewController_wt_mc") forState:UIControlStateNormal];
    [_sellButton setTitle:kLocat(@"k_MyassetDetailViewController_wt_mc") forState:UIControlStateSelected];
    _sellButton.titleLabel.font = PFRegularFont(16);
    [_sellButton setTitleColor:k666666Color forState:UIControlStateNormal];
    [_sellButton setTitleColor:kFallColor forState:UIControlStateSelected];
    
    _limiteButton.titleLabel.font = PFRegularFont(16);
    [_limiteButton setTitle:kLocat(@"limit_price") forState:UIControlStateNormal];
    [_limiteButton setTitleColor:k666666Color forState:UIControlStateNormal];

    
    _priceTF.textColor = k222222Color;
    _priceTF.font = PFRegularFont(12);
    _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"Price") attributes:@{NSForegroundColorAttributeName:k999999Color}];

    
    
    [_addButton setImage:kImageFromStr(@"mairu_icon_8") forState:UIControlStateNormal];
    [_minusButton setImage:kImageFromStr(@"mairu_icon_7") forState:UIControlStateNormal];

    _aboutMoneyLabel.textColor = k666666Color;
    _aboutMoneyLabel.font = PFRegularFont(12);
    
    _amountTF.textColor = k222222Color;
    _amountTF.font = PFRegularFont(14);
    _amountTF.keyboardType = UIKeyboardTypeDecimalPad;
    _amountTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"k_HBTradeJLViewController_count") attributes:@{NSForegroundColorAttributeName: k999999Color}];

    _currencyNameLabel.textColor = k666666Color;
    _currencyNameLabel.font = PFRegularFont(14);
    _currencyNameLabel.adjustsFontSizeToFitWidth = YES;
    
    _availableCurrencyLabel.textColor = k666666Color;
    _availableCurrencyLabel.font = PFRegularFont(14);

    _dealLabel.textColor = k222222Color;
    _dealLabel.font = PFRegularFont(16);
    
    
    _actionButton.titleLabel.font = PFRegularFont(14);
    _actionButton.backgroundColor = kColorFromStr(@"#03C086");
    [_actionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    
    kViewBorderRadius(_amountView, 0, 0.5, k999999Color);
    kViewBorderRadius(_priceView, 0, 0.5, k999999Color);

    
    _panKouLabel.textColor = k666666Color;
    _panKouLabel.font = PFRegularFont(12);
    _price.textColor = k666666Color;
    _price.font = PFRegularFont(12);
    _amount.textColor = k666666Color;
    _amount.font = PFRegularFont(12);
        
    _currentCNYLabel.textColor = k666666Color;
    _currentCNYLabel.font = PFRegularFont(12);
    _currentPriceLabel.textColor = kColorFromStr(@"#03C086");
    _currentPriceLabel.font = PFRegularFont(16);
    
    _progressBeginLabel.textColor = k666666Color;
    _progressBeginLabel.font = PFRegularFont(12);
    _progressEndLabel.textColor = _progressBeginLabel.textColor;
    _progressEndLabel.font = PFRegularFont(12);
    _progressEndLabel.adjustsFontSizeToFitWidth = YES;
    
    _topPriceMargin.constant = 48 *kScreenWidthRatio;
    
    
}


-(void)userDidClickPriceList:(UITapGestureRecognizer *)tap
{
    NSInteger tag = tap.view.tag;
    NSDictionary *dic;
    
    if (tag > 4) {
        dic = self.sellArray[tag-5];
    }else{
        dic = self.buyArray[tag];
    }
    if ([self.delegate respondsToSelector:@selector(didClickPanKouListWith:)]) {
        [self.delegate didClickPanKouListWith:dic];
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
