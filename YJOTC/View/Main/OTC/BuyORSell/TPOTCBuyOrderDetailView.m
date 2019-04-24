//
//  TPOTCBuyOrderDetailView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyOrderDetailView.h"
#import "NSString+Operation.h"


@interface TPOTCBuyOrderDetailView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CNYLabel;

@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;


@property (weak, nonatomic) IBOutlet UIImageView *way1Icon;
@property (weak, nonatomic) IBOutlet UILabel *way1Label;
@property (weak, nonatomic) IBOutlet UIImageView *way2Icon;
@property (weak, nonatomic) IBOutlet UILabel *way2Label;
@property (weak, nonatomic) IBOutlet UILabel *way3Label;
@property (weak, nonatomic) IBOutlet UIImageView *way3Icon;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;


//w无关紧要

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;



@end


@implementation TPOTCBuyOrderDetailView

-(void)setModel:(TPOTCOrderModel *)model
{
    _model = model;
    
    [self.timer invalidate];
    _second = 45;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    self.timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    
    
    if ([model.type isEqualToString:@"sell"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_main_buy"),model.currencyName];

//        NSString *placeHolder = [NSString floatOne:model.avail calculationType:CalculationTypeForMultiply floatTwo:model.price];
        NSString *placeHolder = [self _calculateTheMaxBuyingOfCNYForModel:model];
        
        
//        if ([placeHolder containsString:@"."]) {
//            placeHolder = [NSString stringWithFormat:@"%.2f",placeHolder.doubleValue];
//        }
        _topTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_view_maxbuy"),placeHolder];
//        _topTF.placeholder = [NSString stringWithFormat:@"最大可買 %@",[NSString floatOne:model.avail calculationType:CalculationTypeForMultiply floatTwo:model.price]];
        NSString *bottomPlaceHolder = [self _calculateTheMaxBuingOfNumberForModel:model];
        _bottomTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_view_maxbuy"), bottomPlaceHolder];        [_buyButton setTitle:kLocat(@"OTC_view_buyall") forState:UIControlStateNormal];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_main_sell"),model.currencyName];
        _topTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_view_maxsell"),[NSString floatOne:model.avail calculationType:CalculationTypeForMultiply floatTwo:model.price]];
        _bottomTF.placeholder = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_view_maxsell"),model.avail];
        [_buyButton setTitle:kLocat(@"OTC_view_sellall") forState:UIControlStateNormal];

    }
    _topTF.text = nil;
    _bottomTF.text = nil;
    
    [_icon setImageWithURL:model.currency_logo.ks_URL placeholder:nil];
    _CNYLabel.text = [NSString stringWithFormat:@"%@ CNY",model.price];

    _limitLabel.text = [NSString stringWithFormat:@"%@ ¥%@-¥%@",kLocat(@"OTC_view_limtesum"),model.min_money,model.max_money];
    
    _remarkTV.text = model.order_message;
    _currencyLabel.text = model.currencyName;
    
    if (model.money_type.count == 3) {
        _way1Icon.hidden = NO;
        _way2Icon.hidden = NO;
        _way3Icon.hidden = NO;
        _way1Label.hidden = NO;
        _way2Label.hidden = NO;
        _way3Label.hidden = NO;
        _way1Icon.image = kImageFromStr(@"gmxq_icon_yhk");
        _way2Icon.image = kImageFromStr(@"gmxq_icon_zfb");
        _way3Icon.image = kImageFromStr(@"gmxq_icon_wx");
        _way1Label.text = kLocat(@"k_popview_select_paybank");
        _way2Label.text = kLocat(@"k_popview_select_payalipay");
        _way3Label.text = kLocat(@"k_popview_select_paywechat");
        
    }else if (model.money_type.count == 2){
        _way1Icon.hidden = NO;
        _way2Icon.hidden = NO;
        _way3Icon.hidden = YES;
        _way1Label.hidden = NO;
        _way2Label.hidden = NO;
        _way3Label.hidden = YES;
        if (![model.money_type containsObject:kZFB]) {
            _way1Icon.image = kImageFromStr(@"gmxq_icon_yhk");
            _way2Icon.image = kImageFromStr(@"gmxq_icon_wx");
            _way1Label.text = kLocat(@"k_popview_select_paybank");
            _way2Label.text = kLocat(@"k_popview_select_paywechat");
        }else if (![model.money_type containsObject:kWechat]){
            _way1Icon.image = kImageFromStr(@"gmxq_icon_yhk");
            _way2Icon.image = kImageFromStr(@"gmxq_icon_zfb");
            _way1Label.text = kLocat(@"k_popview_select_paybank");
            _way2Label.text = kLocat(@"k_popview_select_payalipay");
        }else{
            _way1Icon.image = kImageFromStr(@"gmxq_icon_zfb");
            _way2Icon.image = kImageFromStr(@"gmxq_icon_wx");
            _way1Label.text = kLocat(@"k_popview_select_payalipay");
            _way2Label.text = kLocat(@"k_popview_select_paywechat");
        }
    }else{
        _way1Icon.hidden = NO;
        _way2Icon.hidden = YES;
        _way3Icon.hidden = YES;
        _way1Label.hidden = NO;
        _way2Label.hidden = YES;
        _way3Label.hidden = YES;
        if ([model.money_type containsObject:kZFB]) {
            _way1Icon.image = kImageFromStr(@"gmxq_icon_zfb");
            _way1Label.text = kLocat(@"k_popview_select_payalipay");

        }else if ([model.money_type containsObject:kWechat]){
            _way1Icon.image = kImageFromStr(@"gmxq_icon_wx");
            _way1Label.text = kLocat(@"k_popview_select_paywechat");
        }else{
            _way1Icon.image = kImageFromStr(@"gmxq_icon_yhk");
            _way1Label.text = kLocat(@"k_popview_select_paybank");
        }
    }
    
    NSString *limteTime = kLocat(@"s0015_needyoutopayin1mins");
    limteTime = [limteTime stringByReplacingOccurrencesOfString:@"000" withString:model.repeal_time];
    _timeLabel.text = limteTime;
    [_timeButton setTitle:[NSString stringWithFormat:@"%zds%@",_second,kLocat(@"Cancel")] forState:UIControlStateNormal];

    _dealButton.backgroundColor = kColorFromStr(@"656B7B");
    [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];

    
}



- (IBAction)hideAction:(id)sender
{
    [self.timer invalidate];
    
    [_topTF resignFirstResponder];
    [_bottomTF resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenH;

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight);
    _tipsLabel.text = kLocat(@"s0017_OTCBuyOrderTips");
    _tipsLabel.textColor = kColorFromStr(@"E1545A");
    _tipsLabel.font = PFRegularFont(12);
    
    // 创建BezierPath 并设置角 和 半径 这里只设置了 右上 和 右下
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
    
    
    _nameLabel.textColor = k222222Color;
    _nameLabel.font = PFRegularFont(18);
    
    _currencyLabel.textColor = kColorFromStr(@"#6189C5");
    _currencyLabel.font = PFRegularFont(14);
    
    _CNYLabel.textColor = _currencyLabel.textColor;
    _CNYLabel.font = PFRegularFont(16);
    
    _limitLabel.textColor = k666666Color;
    _limitLabel.font = PFRegularFont(12);
    
    _way1Label.textColor = k666666Color;
    _way1Label.font = PFRegularFont(12);
    _way2Label.textColor = k666666Color;
    _way2Label.font = PFRegularFont(12);
    _way3Label.textColor = k666666Color;
    _way3Label.font = PFRegularFont(12);
    
    _topTF.textColor = _nameLabel.textColor;
    _topTF.font = PFRegularFont(14);
    
    _bottomTF.textColor = _nameLabel.textColor;
    _bottomTF.font = PFRegularFont(14);
    
    _markLabel.textColor = _CNYLabel.textColor;
    _markLabel.font = PFRegularFont(14);
    
    [_buyButton setTitleColor:kColorFromStr(@"#066B98") forState:UIControlStateNormal];
    _buyButton.titleLabel.font = PFRegularFont(14);
    
    
    _timeLabel.textColor = kColorFromStr(@"#979CAD");
    _timeLabel.font = PFRegularFont(12);
    
    [_timeButton setTitleColor:kColorFromStr(@"#9BC1ED") forState:UIControlStateNormal];
    _timeButton.titleLabel.font = PFRegularFont(14);
    _timeButton.backgroundColor = kColorFromStr(@"#8A94A8");
    
    [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _dealButton.titleLabel.font = PFRegularFont(14);

    _dealButton.backgroundColor = kColorFromStr(@"#6189C5");
    


    _markLabel.textColor = kColorFromStr(@"#6189C5");
    _markLabel.font = PFRegularFont(14);
    
    _remark.textColor = k666666Color;
    _remark.font = PFRegularFont(14);
    
    _remarkTV.textColor = k666666Color;
    _remarkTV.backgroundColor = kClearColor;
    _remarkTV.font = PFRegularFont(12);
    _remarkTV.editable = NO;
    
    _lineView.backgroundColor = k999999Color;
    kViewBorderRadius(_midView, 0, 0.5, k999999Color);
    _midView.backgroundColor = kClearColor;
    self.backgroundColor = kWhiteColor;
    
    
    _topTF.placeholder = @"0";
    kTextFieldPlaceHoldColor(_topTF, k999999Color);
    _bottomTF.placeholder = @"0";
    kTextFieldPlaceHoldColor(_bottomTF, k999999Color);
    
    _topTF.delegate = self;
    _bottomTF.delegate = self;
    
    
    [_buyButton addTarget:self action:@selector(allButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_timeButton addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _remark.text = kLocat(@"OTC_view_sellerremark");
    [_buyButton setTitle:kLocat(@"OTC_view_buyall") forState:UIControlStateNormal];
    _timeLabel.text = kLocat(@"OTC_view_needpayin15min");
    [_dealButton setTitle:kLocat(@"OTC_view_placeorder") forState:UIControlStateNormal];
    
}


-(void)allButtonAction
{
    if ([_model.type isEqualToString:@"buy"]) {//购买
        
        
        
    }else{//出售
        
        _topTF.text = [self _calculateTheMaxBuyingOfCNYForModel:_model];

//        _topTF.text = [NSString stringWithFormat:@"%@",[NSString floatOne:_model.max_money calculationType:CalculationTypeForMultiply floatTwo:_model.price]];
//
//        if ([_topTF.text containsString:@"."]) {
//            _topTF.text = [NSString stringWithFormat:@"%.2f",_topTF.text.doubleValue];
//        }
        
        _dealButton.backgroundColor = kColorFromStr(@"#6189C5");
        [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];

        _bottomTF.text = [self _calculateTheMaxBuingOfNumberForModel:_model];
    }

}

/**
 计算 最大可买 CNY
 
 @param model model
 @return 最大可买(CNY)
 */
- (NSString *)_calculateTheMaxBuyingOfCNYForModel:(TPOTCOrderModel *)model {
    NSString *myMax = [NSString floatOne:model.avail calculationType:CalculationTypeForMultiply floatTwo:model.price];
    NSString *result = nil;
    if ([myMax doubleValue] > [model.max_money doubleValue]) {
        result = model.max_money;
    } else {
        result = myMax;
    }
    
//    if ([result containsString:@"."]) {
//        result = [NSString stringWithFormat:@"%.2f",result.doubleValue];
//    }
    
  result = [result rouningDownByScale:2];
    
    return result;
}


/**
 计算 最大可买 数量
 
 @param model model
 @return 最大可买(数量)
 */
- (NSString *)_calculateTheMaxBuingOfNumberForModel:(TPOTCOrderModel *)model {
    NSString *maxOfNumber = [NSString floatOne:model.max_money calculationType:CalculationTypeForDivide floatTwo:model.price];
    
    NSString *result = model.avail;
    if ([maxOfNumber doubleValue] < [model.avail doubleValue]) {
        result = maxOfNumber;
    }
    
//    if ([result containsString:@"."]) {
//        result = [NSString stringWithFormat:@"%.6f",result.doubleValue];
//    }
   result = [result rouningDownByScale:6];

    return result;
}

-(void)countDown
{
    _second --;
    [_timeButton setTitle:[NSString stringWithFormat:@"%zds%@",_second,kLocat(@"net_alert_load_message_cancel")] forState:UIControlStateNormal];
    if (_second == 0) {
        [self.timer invalidate];
        [self hideAction:nil];
    }
}
#pragma mark - textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
                    //                    showMsg(@"数据格式有误");
                    NSLog(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    //                    showMsg(@"数据格式有误");
                    NSLog(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (textField == _bottomTF) {
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 6) {
                            return YES;
                        }else{
                            NSLog(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }else{
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            NSLog(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }
        }else{//输入的数据格式不正确
            //            showMsg(@"数据格式有误");
            NSLog(@"数据格式有误");
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
#pragma mark - 输入框通知
-(void)textFieldTextDidChange:(NSNotification *)noti
{
    UITextField *tf = noti.object;

    if (tf == _topTF) {
        _bottomTF.text = [NSString floatOne:_topTF.text calculationType:CalculationTypeForDivide floatTwo:_model.price];
        
        if ([_bottomTF.text containsString:@"."]) {
            _bottomTF.text = [NSString stringWithFormat:@"%.6f",_bottomTF.text.doubleValue];
        }
        
        if (_topTF.text.length == 0) {
            _bottomTF.text = nil;
        }
        
        if (_topTF.text.doubleValue + _bottomTF.text.doubleValue > 0) {
            _dealButton.backgroundColor = kColorFromStr(@"#6189C5");
            [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        }else{
            _dealButton.backgroundColor = kColorFromStr(@"#8A94A8");
            [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];

        }
    }else if (tf == _bottomTF){
        _topTF.text = [NSString floatOne:_bottomTF.text calculationType:CalculationTypeForMultiply floatTwo:_model.price];
        if ([_topTF.text containsString:@"."]) {
            _topTF.text = [NSString stringWithFormat:@"%.2f",_topTF.text.doubleValue];
        }
        
        if (_bottomTF.text.length == 0) {
            _topTF.text = nil;
        }
        if (_topTF.text.doubleValue + _bottomTF.text.doubleValue > 0) {
            _dealButton.backgroundColor = kColorFromStr(@"#6189C5");
            [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        }else{
            _dealButton.backgroundColor = kColorFromStr(@"#8A94A8");
            [_dealButton setTitleColor:kWhiteColor forState:UIControlStateNormal];

        }
    }
    
    
}



@end
