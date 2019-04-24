//
//  XPZhuanZhangSuccessController.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPZhuanZhangSuccessController.h"
#import "XPXRPAssetViewController.h"

@interface XPZhuanZhangSuccessController ()


@property (weak, nonatomic) IBOutlet UITextView *tipsTV;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation XPZhuanZhangSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTableColor;
    
    
    self.enablePanGesture = NO;
    
    self.title = kLocat(@"Z_zzsuccestitle");
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);

    [_bgView addShadow];
    _successLabel.textColor = k222222Color;
    _successLabel.font = PFRegularFont(14);
    _tipsTV.textColor = k666666Color;
    _tipsTV.font = PFRegularFont(12);
    
    
    _successLabel.text = kLocat(@"Z_zzsuccesstatus");
    
    
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:kLocat(@"k_popview_select_paywechat_finish") forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kColorFromStr(@"#E4A646") forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightbBarButton addTarget:self action:@selector(finishAction) forControlEvents:(UIControlEventTouchUpInside)];
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;

    [self hideBackButton];
    
    if (_isHuaZhuan) {
        self.title = kLocat(@"hz_zhaunchusuccess");
        _tipsTV.text = kLocat(@"hz_huazhuansucceetips");

        _tipsTV.text = [_tipsTV.text stringByReplacingOccurrencesOfString:@"000" withString:_vol];
        
    }else{
        _tipsTV.text = kLocat(@"Z_zzSuccesstips");
        _tipsTV.text = [_tipsTV.text stringByReplacingOccurrencesOfString:@"000" withString:_vol];
    }
}
-(void)finishAction
{
    BOOL contain = NO;
    UIViewController *targetVC;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XPXRPAssetViewController class]]) {
            contain = YES;
            targetVC = vc;
        }
    }
    if (contain) {
        [self.navigationController popToViewController:targetVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



@end
