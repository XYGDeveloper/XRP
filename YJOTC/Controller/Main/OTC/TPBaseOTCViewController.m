//
//  TPBaseOTCViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPBaseOTCViewController.h"
#import "TPOTCBuyBaseController.h"
#import "TPOTCSellBaseController.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCOrderBaseController.h"
#import "TPOTCBaseADController.h"
#import "TPOTCBasePostController.h"
#import "NSObject+SVProgressHUD.h"

@interface TPBaseOTCViewController ()

@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *sellButton;
@property(nonatomic,assign)BOOL isBuy;

@property(nonatomic,strong)TPOTCBuyBaseController *buyVC;
@property(nonatomic,strong)TPOTCSellBaseController *sellVC;

@property(nonatomic,strong)UIViewController *currentVC;

@property(nonatomic,strong)NSArray *currencyArr;

@property(nonatomic,assign)BOOL loadSuccess;

@property(nonatomic,assign)BOOL firstLoad;

@property(nonatomic,assign)BOOL isHide;


@end

@implementation TPBaseOTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetAllAvailableCurrency:) name:@"kDidGetAllAvailableCurrencyKey" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOTCBaseVCTopView) name:@"kHideBaseOTCTopViewKey" object:nil];


    [self setupNavi];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (_loadSuccess == NO) {
        [self loadData];
    }
    
//    if (_isHide) {
//        self.topView.height = 0;
//        self.topView.alpha = 0;
//    }else{
//        [self rightButtonAction:nil];
//    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)loadData
{

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/currencys"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
//        _firstLoad = NO;
        if (success) {
            _loadSuccess = YES;
            NSArray *datas = [responseObj ksObjectForKey:kData];
            NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [Marr addObject:[TPCurrencyModel modelWithJSON:dic]];
            }
            _currencyArr = Marr.mutableCopy;
            [NSKeyedArchiver archiveRootObject:Marr.copy toFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
            
            [self setupUI];
            [self.view bringSubviewToFront:self.topView];
        }else{
            __weak typeof(self)weakSelf = self;
            _loadSuccess = NO;

            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:error.localizedDescription operationBlock:^{
                
                [weakSelf loadData];
                
            }];
        }
    }];
}


-(void)setupUI
{
//    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor  = kColorFromStr(@"#0B132A");
    
    self.buyVC = [[TPOTCBuyBaseController alloc] init];
//    self.buyVC.view.frame = kRectMake(0, 0, kScreenW, kScreenH - kNavigationBarHeight - 60);
    self.buyVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
    [self addChildViewController:self.buyVC];

    self.sellVC = [[TPOTCSellBaseController alloc] init];
    self.sellVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
//    self.sellVC.view.frame = kScreenBounds;

    [self addChildViewController:self.sellVC];


    [self.view addSubview:self.buyVC.view];
    self.currentVC = self.buyVC;
}
-(void)setupNavi
{
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, 200, kNavigationBarHeight)];
    topView.backgroundColor = kColorFromStr(@"#1F2225");
    
    UIView *midView = [[UIView alloc]initWithFrame:kRectMake(0, 0, 170, 30)];
    [topView addSubview:midView];
    midView.backgroundColor = topView.backgroundColor;
    kViewBorderRadius(midView, 0, 1, kColorFromStr(@"#11B1ED"));
    [midView alignHorizontal];
    midView.bottom = topView.height - 5;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, midView.width/2, midView.height) title:kLocat(@"OTC_main_buy") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:leftButton];
    [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11B1ED")] forState:UIControlStateSelected];
 
    [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#1F2225")] forState:UIControlStateNormal];
    leftButton.selected = YES;
    leftButton.tag = 0;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, leftButton.width, leftButton.height) title:kLocat(@"OTC_main_sell") titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:rightButton];
    [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11B1ED")] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#1F2225")] forState:UIControlStateNormal];
    rightButton.tag = 1;
    
    
//    self.navigationItem.titleView = midView;
    
    self.navigationItem.title = kLocat(@"OTC_main_buy");
    _buyButton = leftButton;
    _sellButton = rightButton;
    _isBuy = YES;
    leftButton.SG_eventTimeInterval = 0.3;
    rightButton.SG_eventTimeInterval = 0.3;
    
    [rightButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(topNaviButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    view.backgroundColor = [UIColor clearColor];
//    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    firstButton.frame = CGRectMake(0, 0, 44, 44);
//    [firstButton setImage:kImageFromStr(@"poc_icon_navno") forState:UIControlStateNormal];
//    [firstButton setImage:kImageFromStr(@"poc_icon_navpre") forState:UIControlStateSelected];
//    [firstButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
//    _rightButton = firstButton;
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    [self addRightBarButtonWithFirstImage:kImageFromStr(@"rui_icon_navbar") action:@selector(rightButtonAction:)];
    
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];
    
//    [self rightButtonAction:nil];
    self.topView.height = 70;
    [self.view bringSubviewToFront:self.topView];
}

#pragma mark - 点击事件

-(void)avatarAction
{
    if (isInvalid) {
        [self gotoLoginVC];
        return;
    }
   XPMineManager *v =  [[XPMineManager alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight)];
    [UIView animateWithDuration:0.25 animations:^{
        v.frame = kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight);
    }];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.view addSubview:v];
}



-(void)topNaviButtonAction:(UIButton *)button
{

    if (button.isSelected) {
        return;
    }else{
        if (button.tag == 0) {
            _buyButton.selected = YES;
            _sellButton.selected = NO;
        }else{
            _buyButton.selected = NO;
            _sellButton.selected = YES;
        }
    }
    _isBuy = _buyButton.isSelected;
//    [self loadDateWithKeyWord:@""];
    
    if (_isBuy) {
        [self replaceController:self.currentVC newController:self.buyVC];
    }else{
        [self replaceController:self.currentVC newController:self.sellVC];

    }
    [self.view bringSubviewToFront:self.topView];

}





#pragma mark - 点击了上角按钮
-(void)rightButtonAction:(UIButton *)button
{

    if (self.topView.height == 0) {
        _isHide = NO;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"kUserDidClickTPBaseOTCViewControllerRightButtonKey" object:@"1"];

        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 70);
            self.topView.alpha = 1;
            
            self.buyVC.view.frame = kRectMake(0, kNavigationBarHeight+70, kScreenW, kScreenH - 70 - kNavigationBarHeight);

        }];
    }
}
#pragma mark - 多按钮点击事件

-(void)topButtonAction:(UIButton *)button
{
//    [self hideOTCBaseVCTopView];
    
    if (_currencyArr == nil) {
        
        _currencyArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
        if (_currencyArr == nil) {
            [self loadData];
            return;
        }
    }
    
    if ([Utilities isExpired] && button.tag < 4) {
        [self gotoLoginVC];
        return;
    }
//    if(kUserInfo.verify_state.intValue != 1){
//        [self showTips:kLocat(@"k_in_c2c_tips")];
//        return;
//    }
    
    switch (button.tag) {
        case 0:
        {
            if (kUserInfo.nickName.length == 0) {
                [self _alertNicknameTextField];
                return;
            }
            TPOTCBasePostController *vc = [TPOTCBasePostController new];
            vc.currencyArr = _currencyArr;
            kNavPush(vc);
        }
            break;
        case 1:
        {
            TPOTCBaseADController *vc = [TPOTCBaseADController new];
            vc.currencyArr = _currencyArr;
            kNavPush(vc);
        }
            break;
        case 2:
        {
            TPOTCOrderBaseController *vc = [TPOTCOrderBaseController new];
            kNavPush(vc);
        }
            break;
        case 3:
        {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }
            break;
        case 4:
        {
            _isHide = YES;
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"kUserDidClickTPBaseOTCViewControllerRightButtonKey" object:@"0"];
            [UIView animateWithDuration:0.25 animations:^{
                self.buyVC.view.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight+70);

                self.topView.height = 0;
                self.topView.alpha = 0;
            }];
            
        }
            break;
        default:
            break;
    }
}
-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 70)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#225686");
        
        CGFloat h = _topView.height;
        
        //        NSArray *titles = @[@"Send",@"Receive",@"Receive",@"Receive",@"Flod"];
        NSArray *titles = titles = @[kLocat(@"OTC_main_postad"),kLocat(@"OTC_main_myad"),kLocat(@"OTC_main_order"),kLocat(@"OTC_main_payway"),kLocat(@"x_xfold")];
        NSArray *icons = @[@"otc_icon_fzgg",@"otc_icon_wdgg",@"otc_icon_wdan",@"otc_icon_moshi",@"fi_icon_fold"];
        CGFloat w = kScreenW/icons.count;
        
        for (NSInteger i = 0; i < icons.count; i++) {
            CGFloat x = w * i;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, 0, w, h)];
            [_topView addSubview:button];
            [button alignVertical];
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
//        _topView.height = 0;
    }
    return _topView;
}
-(void)configureButton:(YLButton *)button With:(NSString *)title image:(NSString *)image
{
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.font = PFRegularFont(12);
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button setImage:kImageFromStr(image) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.imageRect = kRectMake((kScreenW/5-34)/2, 12, 32, 32);
    button.titleRect = kRectMake(0, 50, button.width, 12);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
}

-(void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            
            [newController  didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
}

-(void)didGetAllAvailableCurrency:(NSNotification *)noti
{
    _currencyArr = noti.object;
    
}

-(void)hideOTCBaseVCTopView
{
    _rightButton.selected = YES;
    [self rightButtonAction:_rightButton];
}

#pragma mark - Alert

- (void)_alertNicknameTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"HBMemberViewController_set_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *nickName = alertController.textFields.firstObject.text;
        [self modifyNick:nickName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }

    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        
        kHideHud;
        if ([model succeeded]) {
            YJUserInfo *userInfo = kUserInfo;
            userInfo.nickName = nick;
            [userInfo saveUserInfo];
            [self showSuccessWithMessage:model.message];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}


@end
