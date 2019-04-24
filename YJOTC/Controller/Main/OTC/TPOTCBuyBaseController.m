
//
//  TPOTCBuyBaseController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyBaseController.h"
#import "TPOTCSellBaseController.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCOrderBaseController.h"
#import "TPOTCBaseADController.h"
#import "TPOTCBasePostController.h"
#import "NSObject+SVProgressHUD.h"
#import "TPOTCBuyListController.h"

@interface TPOTCBuyBaseController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property(nonatomic,strong)NSMutableArray<TPCurrencyModel *> *dataArr;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)NSArray *currencyArr;


@end

@implementation TPOTCBuyBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = kLocat(@"OTC_main_buy");
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movePageView:) name:@"kUserDidClickTPBaseOTCViewControllerRightButtonKey" object:nil];
    [self setNavi];
}
-(void)movePageView:(NSNotification *)noti
{
    if ([noti.object intValue] == 0) {//hide
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollPageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-kTabbarItemHeight-kNavigationBarHeight);
        }];
    }else{
        self.scrollPageView.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height-kTabbarItemHeight-kNavigationBarHeight);
        self.scrollPageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-kTabbarItemHeight-kNavigationBarHeight);

    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)loadData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/currencys"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            _dataArr = [NSMutableArray arrayWithCapacity:datas.count];
            for (NSDictionary *dic in datas) {
                [self.dataArr addObject:[TPCurrencyModel modelWithJSON:dic]];
            }
            
            [NSKeyedArchiver archiveRootObject:self.dataArr toFile:[@"kDidGetAllAvailableCurrencyKey" appendDocument]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDidGetAllAvailableCurrencyKey" object:_dataArr.copy];
            _currencyArr = _dataArr.mutableCopy;
            [self setupUI];
            
        }else{
            
            [[EmptyManager sharedManager]showNetErrorOnView:self.view response:nil operationBlock:^{
                [self loadData];
            }];
        }
    }];
}

-(void)setNavi
{
    [self addRightBarButtonWithFirstImage:kImageFromStr(@"rui_icon_navbar") action:@selector(rightButtonAction:)];
    
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];
    
    //    [self rightButtonAction:nil];
    self.topView.height = 70;
    
}

-(void)setupUI
{
    self.view.backgroundColor = kColorFromStr(@"225686");

//    self.view.backgroundColor = kRedColor;

    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = NO;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = [PFRegularFont(14) fontWithBold];
    style.normalTitleColor = kColorFromStr(@"#54CDC0");
    style.selectedTitleColor = kWhiteColor;
    style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = NO;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    //    self.titles = @[@"标签",@"用户",@"文章",@"资讯"];
    style.scrollTitle = YES;
    style.contentViewBounces = NO;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.dataArr.count];
    
    for (TPCurrencyModel *model in self.dataArr) {
        [titles addObject:model.currencyName];
    }
 
    self.titles = titles.mutableCopy;
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 70+kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight-kTabbarItemHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
    _scrollPageView.segmentView.backgroundColor = kColorFromStr(@"#225686");
//    _scrollPageView.contentView.backgroundColor = kColorFromStr(@"#225686");
//    _scrollPageView.contentView.collectionView.backgroundColor = kColorFromStr(@"#225686");
    [self.view addSubview:_scrollPageView];
    
    
}

-(NSInteger)numberOfChildViewControllers
{
    return self.dataArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    TPOTCBuyListController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [TPOTCBuyListController new];
    }
    childVc.model = self.dataArr[index];
    return childVc;
}

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
#pragma mark - 点击了右上角按钮
-(void)rightButtonAction:(UIButton *)button
{
    
    if (self.topView.height == 0) {
//        _isHide = NO;
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"kUserDidClickTPBaseOTCViewControllerRightButtonKey" object:@"1"];
        
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 70);
            self.topView.alpha = 1;
            
            self.scrollPageView.frame = CGRectMake(0, 70+kNavigationBarHeight, self.view.bounds.size.width, kScreenH-kTabbarItemHeight-kNavigationBarHeight);

        }];
    }
}
#pragma mark - 多按钮点击事件

-(void)topButtonAction:(UIButton *)button
{
    
    if ([Utilities isExpired] && button.tag < 4) {
        [self gotoLoginVC];
        return;
    }
  
    if (button.tag < 4 && kUserInfo.verify_state.intValue != 1) {
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/memberinfo"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                kLOG(@"%@",responseObj);
                NSDictionary *dic = [responseObj ksObjectForKey:kData][@"member"];
                YJUserInfo *model = kUserInfo;
                
                model.verify_state = ConvertToString(dic[@"verify_state"]);
                [model saveUserInfo];
                
                if (kUserInfo.verify_state.intValue < 1) {
                    [self showTips:kLocat(@"s_plzfinishauth")];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        kNavPush([XNIdentifyViewController new]);
                    });
                    return;
                }else if(kUserInfo.verify_state.intValue == 2) {
                    [self showTips:kLocat(@"s_plzwaitcheck")];
                    return;
                }else{
                    [self actionAfterCheck:button];
                }
            }
        }];
    }else{
        [self actionAfterCheck:button];
    }
}

-(void)actionAfterCheck:(UIButton *)button
{
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
            [UIView animateWithDuration:0.2 animations:^{
                self.scrollPageView.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight-kTabbarItemHeight);
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
