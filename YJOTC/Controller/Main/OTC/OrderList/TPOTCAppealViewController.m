//
//  TPOTCAppealViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/24.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCAppealViewController.h"
#import "TPOTCOrderDetailController.h"

@interface TPOTCAppealViewController ()


@property(nonatomic,strong)NSMutableArray<UIButton *> *buttonArray;


@property(nonatomic,strong)YYTextView *reasonTV;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)NSTimer *timer;


@end

@implementation TPOTCAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _buttonArray = [NSMutableArray array];

    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setupUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = kLocat(@"OTC_appleal");
//    self.view.backgroundColor = kColorFromStr(@"#171F34");
    
    CGSize size = [Utilities calculateWidthAndHeightWithWidth:kScreenW - 24 height:10000 text:kLocat(@"OTC_order_applealtips1") font:PFRegularFont(12)].size;
    
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 30 *kScreenHeightRatio+kNavigationBarHeight, size.width, size.height)];
    warningLabel.text = kLocat(@"OTC_order_applealtips2");
    warningLabel.font = PFRegularFont(12);
    warningLabel.textColor = k666666Color;
    warningLabel.numberOfLines = 0;
    [self.view addSubview:warningLabel];
    
    UIView *typeView = [[UIView alloc] initWithFrame:kRectMake(0, warningLabel.bottom + 15 *kScreenHeightRatio, kScreenW, 90 * kScreenHeightRatio)];
    [self.view addSubview:typeView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 17, 60, 14) text:kLocat(@"OTC_order_applealtype") font:PFRegularFont(14) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [typeView addSubview:typeLabel];
    
    
    if (_isBuy) {
        UIButton *typeButton2 = [[UIButton alloc] initWithFrame:kRectMake(90, 0, 70, 20) title:kLocat(@"OTC_order_othernotdischarge") titleColor:kWhiteColor font:PFRegularFont(11) titleAlignment:1];
        typeButton2.centerY = typeLabel.centerY;
        [typeView addSubview:typeButton2];
        [typeButton2 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#066B98")] forState:UIControlStateSelected];
        [typeButton2 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateNormal];
        kViewBorderRadius(typeButton2, 2, 0, kRedColor);
        typeButton2.selected = YES;
        [typeButton2 addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        typeButton2.tag = 2;

        [self.buttonArray addObject:typeButton2];
    }else{
        UIButton *typeButton1 = [[UIButton alloc] initWithFrame:kRectMake(90, 0, 70, 20) title:kLocat(@"OTC_order_othernotpay") titleColor:kWhiteColor font:PFRegularFont(11) titleAlignment:1];
        typeButton1.centerY = typeLabel.centerY;
        [typeView addSubview:typeButton1];
        [typeButton1 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#066B98")] forState:UIControlStateSelected];
        [typeButton1 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateNormal];
        typeButton1.selected = YES;
        kViewBorderRadius(typeButton1, 2, 0, kRedColor);
        typeButton1.selected = YES;
        [self.buttonArray addObject:typeButton1];
        [typeButton1 addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        typeButton1.tag = 1;
    }

    
    
    
    
    UIButton *typeButton3 = [[UIButton alloc] initWithFrame:kRectMake(90, 50, 94, 20) title:kLocat(@"OTC_order_othercheat") titleColor:kWhiteColor font:PFRegularFont(11) titleAlignment:1];
    [typeView addSubview:typeButton3];
    [typeButton3 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#066B98")] forState:UIControlStateSelected];
    [typeButton3 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateNormal];
    typeButton3.tag = 3;
    
    UIButton *typeButton4 = [[UIButton alloc] initWithFrame:kRectMake(typeButton3.right + 20, 0, 60, 20) title:kLocat(@"OTC_order_other") titleColor:kWhiteColor font:PFRegularFont(11) titleAlignment:1];
    typeButton4.centerY = typeButton3.centerY;
    [typeView addSubview:typeButton4];
    [typeButton4 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#066B98")] forState:UIControlStateSelected];
    [typeButton4 setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateNormal];
    typeButton4.tag = 4;

    [self.buttonArray addObject:typeButton3];
    [self.buttonArray addObject:typeButton4];

    [typeButton3 addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [typeButton4 addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    kViewBorderRadius(typeButton3, 2, 0, kRedColor);
    kViewBorderRadius(typeButton4, 2, 0, kRedColor);

    
    typeView.backgroundColor = kWhiteColor;
    
    
    UIView *reasonView = [[UIView alloc] initWithFrame:kRectMake(0, typeView.bottom + 5, kScreenW, 200 *kScreenHeightRatio)];
    [self.view addSubview:reasonView];
    reasonView.backgroundColor = typeView.backgroundColor;
    YYTextView *reasonTV = [[YYTextView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 12, reasonView.height)];
    [reasonView addSubview:reasonTV];
    reasonTV.placeholderText = kLocat(@"OTC_order_inputapplealreason");
    reasonTV.textColor = k222222Color;
    reasonTV.font = PFRegularFont(12);
    reasonTV.placeholderTextColor = k999999Color;
    _reasonTV = reasonTV;
    
    UIButton *bottomButton = [[UIButton alloc]initWithFrame:kRectMake(0, kScreenH - 45, kScreenW, 45) title:kLocat(@"OTC_order_confirmappleal") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:1];
    [self.view addSubview:bottomButton];
    bottomButton.backgroundColor = kColorFromStr(@"#6189C5");
    [bottomButton addTarget:self action:@selector(applealAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 12) text:@"付款成功5分鐘后才能發起申訴" font:PFRegularFont(12) textColor:kColorFromStr(@"#707589") textAlignment:1 adjustsFont:YES];
//    [self.view addSubview:tipsLabel];
//    tipsLabel.bottom = bottomButton.y - 30;
//    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 20) text:@"" font:PFRegularFont(14) textColor:kRedColor textAlignment:1 adjustsFont:YES];
//    [self.view addSubview:timeLabel];
//    timeLabel.bottom = bottomButton.y - 60;
//    
//    _timeLabel = timeLabel;
//    _second = 5;
//   _timer = [WeakTimeObject weakScheduledTimerWithTimeInterval:1 target:self selector:@selector(configureTimeLabel) userInfo:nil repeats:YES];
    
}
-(void)typeButtonAction:(UIButton *)button
{
    for (UIButton *btn in self.buttonArray) {
        if (btn.tag == button.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
            
        }
    }
}

-(void)applealAction
{
    [self hideKeyBoard];
    NSString *typeStr;
    NSInteger index = 1;
    for (UIButton *btn in self.buttonArray) {
        if (btn.selected == YES) {
            NSLog(@"%@",btn.currentTitle);
            typeStr = btn.currentTitle;
            index = btn.tag;
        }
    }
    if (_reasonTV.text.length == 0) {
        [self showTips:kLocat(@"OTC_order_inputapplealreason")];
        return;
    }
    if (_reasonTV.text.length > 200) {
        [self showTips:kLocat(@"OTC_order_reasontoolong")];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"content"] = _reasonTV.text;

    param[@"type"] = @(index);
    
    param[@"trade_id"] = _trade_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"TradeOtc/appeal"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            [self showTips:kLocat(@"OTC_order_commitsuccess")];

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                TPOTCOrderDetailController *vc = [TPOTCOrderDetailController new];
                if (_model == nil) {
                    vc.tradeID = _trade_id;
                }else{
                    vc.model = _model;
                }

                vc.type = TPOTCOrderDetailControllerTypeAppleal;
                kNavPush(vc);
                
            });
            
//            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }else{
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }
    }];
}





-(void)configureTimeLabel
{
    _second--;
    NSString *str;
    if (_second > 0) {
        str = [NSString stringWithFormat:@"您還需等待  %@",[Utilities returnTimeWithSecond:_second formatter:@"mm分ss秒"]];
        str = [NSString stringWithFormat:@"%@  %@",kLocat(@"OTC_order_youneedtowait"),[Utilities returnTimeWithSecond:_second formatter:[NSString stringWithFormat:@"mm%@ss%@",kLocat(@"OTC_minute"),kLocat(@"OTC_second")]]];

    }else{
        str = @"您還需等待  0分0秒";
        str = [NSString stringWithFormat:@"%@  0%@0%@",kLocat(@"OTC_order_youneedtowait"),kLocat(@"OTC_minute"),kLocat(@"OTC_second")];

        [self.timer invalidate];
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
//    NSRange range1 = [str rangeOfString:@"您還需等待  "];
    NSRange range1 = [str rangeOfString:[NSString stringWithFormat:@"%@  ",kLocat(@"OTC_order_youneedtowait")]];

    [attr addAttribute:NSForegroundColorAttributeName value:kLightGrayColor range:range1];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(14) range:range1];

    NSRange range2 = NSMakeRange(kLocat(@"OTC_order_youneedtowait").length + 2, str.length- kLocat(@"OTC_order_youneedtowait").length - 2);
    [attr addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#F52657") range:range2];
    [attr addAttribute:NSFontAttributeName value:PFRegularFont(19) range:range2];

    _timeLabel.attributedText = attr;
}

-(void)dealloc
{
    NSLog(@"==");
}


@end
