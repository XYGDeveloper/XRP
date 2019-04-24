//
//  XPAssetBankSuccessController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPAssetBankSuccessController.h"
#import "XPAssetViewController.h"

@interface XPAssetBankSuccessController ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *manage;
@property (weak, nonatomic) IBOutlet UILabel *addtime;

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *rateLabe;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation XPAssetBankSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

-(void)setupUI
{
    self.title = kLocat(@"z_result");
    
    self.enablePanGesture = NO;
    [self hideBackButton];
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"k_popview_select_paywechat_finish") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kColorFromStr(@"#E4A646") forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
    
    _statusLabel.textColor = kColorFromStr(@"#6189C5");
    _statusLabel.font = PFRegularFont(16);
    
    _volumeLabel.textColor = k222222Color;
    _volumeLabel.font = PFRegularFont(22);
    
    _topTimeLabel.textColor = k666666Color;
    _topTimeLabel.font = PFRegularFont(12);
    
    kViewBorderRadius(_topView, 8, 0, kRedColor);
    [_topView addShadow];
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    _rate.textColor = kColorFromStr(@"#DB1414");
    _rate.font = PFRegularFont(12);
    
    _rateLabe.textColor = _rate.textColor;
    _rateLabe.font = PFRegularFont(12);
    
    _manage.textColor = k666666Color;
    _manage.font = PFRegularFont(12);
    
    _managerLabel.textColor = k666666Color;
    _managerLabel.font = PFRegularFont(12);
    
    _addtime.textColor = k666666Color;
    _addtime.font = PFRegularFont(12);
    
    _addTimeLabel.textColor = k666666Color;
    _addTimeLabel.font = PFRegularFont(12);
    
    _endTime.textColor = k666666Color;
    _endTime.font = PFRegularFont(12);
    
    _endLabel.textColor = k666666Color;
    _endLabel.font = PFRegularFont(12);

    
    _rate.text = kLocat(@"z_predictRate");
    _statusLabel.text = kLocat(@"z_zhuanrusuccess");
    _manage.text = kLocat(@"z_managetime");
    _addtime.text = kLocat(@"z_addtime");
    _endTime.text = kLocat(@"z_predictreceive");
    
    
    _volumeLabel.text = [NSString stringWithFormat:@"%@%@",_resultDic[@"num"],_model.currency_mark];
    
    _topTimeLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"z_yujidaozhanshijian"),_resultDic[@"end_time"]];
    
    _rateLabe.text = [NSString stringWithFormat:@"%@%@%%",kLocat(@"ZB_about"),_resultDic[@"rate"]];
    
    _managerLabel.text = [NSString stringWithFormat:@"%d%@",_model.months.intValue*30,kLocat(@"z_day")];
    
    _addTimeLabel.text = _resultDic[@"add_time"];
    _endLabel.text = [NSString stringWithFormat:@"%@%@",_resultDic[@"estimate_money"],_model.currency_mark];
    
}




-(void)backAction
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XPAssetViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
