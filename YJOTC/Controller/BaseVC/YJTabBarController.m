//
//  YJTabBarController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJTabBarController.h"
//#import "YJTabbar.h"
#import "YJBaseViewController.h"
#import "YJBaseNavController.h"



#import "FXBlurView.h"
//#import "YJDiscoverViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YWCircleViewController.h"
#import "TPMainViewController.h"
#import "TPNewsViewController.h"
#import "TPMineViewController.h"
#import "TPQuotationController.h"
#import "TPWalletViewController.h"

#import "XPWalletController.h"
#import "XPXRPViewController.h"
#import "XPDiscoverViewController.h"
#import "XPNewsViewController.h"
#import "TPBaseOTCViewController.h"
#import "TPOTCBuyBaseController.h"

#define kAnimationTime 0.25

@interface YJTabBarController ()<UITabBarControllerDelegate>

//@property (nonatomic, strong) YJTabbar *tabbar;


@property(nonatomic,strong)YJDealViewController *dealVC;

//@property(nonatomic,strong)YJShopViewController *shopVC;
@property(nonatomic,strong)YWCircleViewController *cirVC;

@property(nonatomic,strong)TPMainViewController *newMainVC;
@property(nonatomic,strong)TPNewsViewController *nNewsVC;
@property(nonatomic,strong)TPMineViewController *nMineVC;
@property(nonatomic,strong)TPQuotationController *quaVC;
@property(nonatomic,strong)TPWalletViewController *nWalletVC;

@property(nonatomic,strong)XPWalletController *xpWalletVC;
@property(nonatomic,strong)XPXRPViewController *xrpVC;
@property (nonatomic, strong) UIViewController *discoverVC;

@property(nonatomic,strong)UIViewController *baseOTCVC;



@property(nonatomic,assign)NSInteger current;


@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)NSArray *selctedImagesArray;
@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UIButton *checkButton;
@property(nonatomic,strong)UIButton *publishButton;
@property(nonatomic,strong)UIButton *centerButton;

@property (nonatomic, strong) UIViewController *otcVC;


@end

@implementation YJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTabbarVC];
    [self addChildViewControllers];
    self.delegate = self;

    [self.tabBar setBarTintColor:kTabbarColor];
    self.tabBar.translucent = NO;


}

-(void)configureTabbarVC
{
    self.delegate = self;
    
    // 背景图颜色
    [self.tabBar setBarTintColor:[UIColor colorWithRed:0.11 green:0.13 blue:0.18 alpha:1.00]];
//    self.tabBar.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.21 alpha:1.00];
    [self addChildViewControllers];
    //阴影
    [self dropShadowWithOffset:CGSizeMake(0, -3) radius:3 color:[UIColor grayColor] opacity:0.3];
    //去掉黑线
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
}

-(void)addChildViewControllers
{
//    YJBaseNavController *nav0 = [[YJBaseNavController alloc] initWithRootViewController:self.mainVC];
    YJBaseNavController *nav0 = [[YJBaseNavController alloc] initWithRootViewController:self.xpWalletVC];

    
    
//    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.newsVC];
//    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.nNewsVC];
    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.quaVC];


    YJBaseNavController *nav2 = [[YJBaseNavController alloc] initWithRootViewController:self.xrpVC];
    
//    YJBaseNavController *nav3 = [[YJBaseNavController alloc] initWithRootViewController:self.dealVC];
    YJBaseNavController *nav3 = [[YJBaseNavController alloc] initWithRootViewController:self.discoverVC];

    
    
    YJBaseNavController *nav4 = [[YJBaseNavController alloc] initWithRootViewController:self.baseOTCVC];
//    YJBaseNavController *nav4 = [[YJBaseNavController alloc] initWithRootViewController:self.otcVC];

    
    UIColor *mainColor = kColorFromStr(@"#3284CA");
    UIColor *normalColor = kColorFromStr(@"#AEB2B4");
    
    [nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    [nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];

    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];

    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    
    [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    
    [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:mainColor} forState:UIControlStateSelected];
    [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    

//    self.viewControllers = @[nav0,nav1,nav3,nav4];
    self.viewControllers = @[nav0,nav1,nav2,nav3,nav4];

    self.selectedIndex = 2;
}



- (void)setUpOneChildViewController:(UIViewController *)vc image:(NSString *)image selectImage:(NSString *)selectImage
{
    //描述对应的按钮的内容
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}


-(TPMainViewController *)newMainVC
{
    if (_newMainVC == nil) {
        
        _newMainVC = [[TPMainViewController alloc]init];
        [self setUpOneChildViewController:_newMainVC image:self.imagesArray.firstObject selectImage:self.selctedImagesArray.firstObject];
        _newMainVC.title = LocalizedString(@"Z_BCB");
        
    }
    return _newMainVC;
}
-(XPWalletController *)xpWalletVC
{
    if (_xpWalletVC == nil) {
        _xpWalletVC = [XPWalletController new];
        [self setUpOneChildViewController:_xpWalletVC image:self.imagesArray.firstObject selectImage:self.selctedImagesArray.firstObject];
        _xpWalletVC.title = LocalizedString(@"main");
    }
    return _xpWalletVC;
}





-(TPMineViewController *)nMineVC
{
    if (_nMineVC == nil) {
        _nMineVC = [TPMineViewController new];
        [self setUpOneChildViewController:_nMineVC image:self.imagesArray.lastObject  selectImage:self.selctedImagesArray.lastObject];
        _nMineVC.title = LocalizedString(@"account");
    }
    return _nMineVC;
}



-(TPNewsViewController *)nNewsVC
{
    if (_nNewsVC == nil) {
        _nNewsVC = [TPNewsViewController new];
        [self setUpOneChildViewController:_nNewsVC image:self.imagesArray[1] selectImage:self.selctedImagesArray[1]];
        _nNewsVC.title = LocalizedString(@"hangqing");
    }
    return _nNewsVC;
}
-(TPQuotationController *)quaVC
{
    if (_quaVC == nil) {
        _quaVC = [TPQuotationController new];
        [self setUpOneChildViewController:_quaVC image:self.imagesArray[1] selectImage:self.selctedImagesArray[1]];
        _quaVC.title = LocalizedString(@"hangqing");
    }
    return _quaVC;
}

-(XPXRPViewController *)xrpVC
{
    if (_xrpVC == nil) {
        _xrpVC = [XPXRPViewController new];
        [self setUpOneChildViewController:_xrpVC image:self.imagesArray[2] selectImage:self.selctedImagesArray[2]];
        _xrpVC.title = kLocat(@"index_main");//kLocat(@"x_xxrp")
    }
    return _xrpVC;

}

-(YJDealViewController *)dealVC
{
    if (_dealVC == nil) {
        
        _dealVC = [YJDealViewController new];
        _dealVC.title = LocalizedString(@"Z_Wallet");
        [self setUpOneChildViewController:_dealVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
    }
    return _dealVC;
}
-(TPWalletViewController *)nWalletVC
{
    if (_nWalletVC == nil) {
        
        _nWalletVC = [TPWalletViewController new];
        _nWalletVC.title = LocalizedString(@"Z_Wallet");
        [self setUpOneChildViewController:_nWalletVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
    }
    return _nWalletVC;

}

-(UIViewController *)otcVC
{
    if (_otcVC == nil) {
        _otcVC = [TPBaseOTCViewController new];
        _otcVC.title = @"OTC";
        [self setUpOneChildViewController:_otcVC image:self.imagesArray[4] selectImage:self.selctedImagesArray[4]];
    }
    return _otcVC;
}

-(UIViewController *)baseOTCVC
{
    
    if (_baseOTCVC == nil) {
        _baseOTCVC = [TPOTCBuyBaseController new];
        _baseOTCVC.title = @"OTC";
        [self setUpOneChildViewController:_baseOTCVC image:self.imagesArray[4] selectImage:self.selctedImagesArray[4]];
    }
    return _baseOTCVC;
    
}


-(YWCircleViewController *)cirVC
{
    if (_cirVC == nil) {
        _cirVC = [[YWCircleViewController alloc] init];
        _cirVC.title = kLocat(@"discover");
                [self setUpOneChildViewController:_cirVC image:self.imagesArray[2] selectImage:self.selctedImagesArray[2]];

    }
    return _cirVC;
}

- (UIViewController *)discoverVC {
    if (!_discoverVC) {
//        _discoverVC = [XPDiscoverViewController new];
        _discoverVC = [XPNewsViewController fromStoryboard];
        _discoverVC.title = kLocat(@"discover");
        [self setUpOneChildViewController:_discoverVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
    }
    return _discoverVC;
}

-(NSArray *)imagesArray
{
    if (_imagesArray == nil) {
//        _imagesArray = @[@"wabao_link",@"information_link",@"youquanc_link",@"business_link",@"user_link"];
        _imagesArray = @[@"tab_icon1",@"tab_icon3",@"tab_icon7",@"tab_icon5",@"tab_icon9"];
    }
    return _imagesArray;
}
-(NSArray *)selctedImagesArray
{
    if (_selctedImagesArray == nil) {
        _selctedImagesArray = @[@"tab_icon2",@"tab_icon4",@"tab_icon8",@"tab_icon6",@"tab_icon10"];

//        _selctedImagesArray = @[@"wabao_ckick",@"information_ckick",@"youquan_ckick",@"business_click",@"user_click"];
    }
    return _selctedImagesArray;
}





@end
