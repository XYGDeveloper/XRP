//
//  XPInternaPurchaseTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/4/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInternaPurchaseTableViewCell.h"
#import "MQGradientProgressView.h"
#import "XPGACInnerPurchModel.h"
@interface XPInternaPurchaseTableViewCell()
@property (nonatomic,strong)MQGradientProgressView *progressView;
@end

@implementation XPInternaPurchaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressView = [[MQGradientProgressView alloc] init];
    [self.stepLabel addSubview:self.progressView];
//    self.progressView.bgProgressColor = kColorFromStr(@"#066B98");
    self.progressView.colorArr = @[(id)kColorFromStr(@"#066B98").CGColor,(id)kColorFromStr(@"#066B98").CGColor];
    //    [self.progroessLabel addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    self.progressView.layer.cornerRadius = 10;
    self.progressView.layer.masksToBounds = YES;
    [self.progressView addSubview:self.stepMiddleLabel];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithMOdel:(XPGACInnerPurchModel *)model{
    self.innerPauseLabel.text = kLocat(@"XPInternalPurchaseViewController_inner_price");
    self.exchangeLabel.text = [NSString stringWithFormat:@"%@：1%@≈%@%@",kLocat(@"XPInnovacationExchangeViewController_yuji"),model.from_currency,model.ratio,model.to_currency];
    self.leftLabelCurrencyNameLabel.text = [NSString stringWithFormat:@"%@/CNY",model.from_currency];
    self.rightLabelCurrencyLabel.text = [NSString stringWithFormat:@"%@/CNY",model.to_currency];
    self.leftLabel.text = model.from_cny;
    self.rightLabel.text = model.to_cny;
    
//    NSLog(@"%@",model.has_buy);
    
    if ([model.limit_num doubleValue] <= 0) {
        self.progressView.progress = 0.0;
    }else{
        self.progressView.progress = [model.has_buy doubleValue]/[model.limit_num doubleValue];
    }
    self.stepMiddleLabel.text = [NSString stringWithFormat:@"%@%@GAC",kLocat(@"XPInternalPurchaseViewController_inner_has"),model.has_buy];
    [self.progressView setBackgroundColor:kColorFromStr(@"#93A3B6")];
    self.totalLabel.text = [NSString stringWithFormat:@"%@%@GAC",kLocat(@"XPInternalPurchaseViewController_inner_total"),model.limit_num];
    self.LeveleLabel.text = [NSString stringWithFormat:@"%@%@GAC",kLocat(@"XPInternalPurchaseViewController_inner_level"),model.yu];
}

@end
