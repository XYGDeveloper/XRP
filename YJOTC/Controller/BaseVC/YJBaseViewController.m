//
//  YJBaseViewController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "HBRegisterTableViewController.h"

NSString *backImgName = @"fanhui_icon";


@interface YJBaseViewController ()

@end

@implementation YJBaseViewController
- (id)init{
    self = [super init];
    if (self) {
        self.enablePanGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = kColorFromStr(@"#111419");
    
    self.view.backgroundColor = kTableColor;
    [self initBackButton];
    self.automaticallyAdjustsScrollViewInsets = NO;

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self hideKeyBoard];
}

-(void)initBackButton
{
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.hidesBackButton = YES;
    }else{
        
        
        [self addLeftBarButtonWithImage:kImageFromStr(backImgName) action:@selector(backAction)];
//        return;
//        self.navigationItem.hidesBackButton = NO;
//        UIButton *btn = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 12, 20)];
//        [btn setImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
//
//        UIBarButtonItem *negetiveSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negetiveSpace.width = -1;
//        self.navigationItem.leftBarButtonItems = @[negetiveSpace,back];
        
    }
}
//返回事件
-(void)backAction
{
    if (self.navigationController.viewControllers.count == 1) {
        kDismiss;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setTitleWithNoNavgationBar:(NSString *)titleWithNoNavgationBar
{
    [self addbackButtonAndTitleWith:titleWithNoNavgationBar];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}
-(void)addbackButtonAndTitleWith:(NSString *)title
{
    UIButton *enlageButton = [[UIButton alloc]initWithFrame:kRectMake(0, 0, kNavigationBarHeight, kNavigationBarHeight)];
    [self.view addSubview:enlageButton];
    [enlageButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y = IS_IPHONE_X?(35 + 22):35;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:kRectMake(20, y, 12, 20)];
    [enlageButton addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:backImgName] forState:UIControlStateNormal];
    //    backBtn.userInteractionEnabled = NO;
    
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    _backBtn = backBtn;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:kRectMake(50, 0, kScreenW - 100, 20) text:title font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [self.view addSubview:titleLabel];
    titleLabel.centerY = 35 + 13/2.0;
    titleLabel.centerY = y;

    
    _titleLabel = titleLabel;
    
}



-(void)userDidLogin
{
    
}
-(void)userDidlogout
{
}
-(void)userClickBackButton
{
    
}


-(void)changeStatusBarColorWithWhite:(BOOL)isWhite
{
    if (isWhite) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
-(void)gotoLoginVC
{
    
//    YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
    UIViewController *vc1 = [HBLoginTableViewController fromStoryboard];
//    YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:vc1];

    [self presentViewController:vc1 animated:YES completion:nil];
    
//    YJLoginViewController*vc = [[YJLoginViewController alloc]init];
//    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc] animated:YES completion:nil];


}

-(void)gotoRegisterVC
{
    
    UIViewController *vc1 = [HBRegisterTableViewController fromStoryboard];
    YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:vc1];
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)showTips:(NSString *)msg
{
    
    if (msg == nil || msg.length == 0) {
        return;
    }
    
    //mbprogress
    [self.view showWarning:msg];
    
}
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}
-(void)hideBackButton
{
    self.backBtn.hidden = YES;
    self.backBtn.superview.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)setEnablePanGesture:(BOOL)enablePanGesture
{
    _enablePanGesture = enablePanGesture;
    self.disableDragBack = !enablePanGesture;
}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setStatusBarColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
-(BOOL)shouldAutorotate
{
    return NO;
}
@end
