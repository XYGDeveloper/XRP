//
//  TPMainViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMainViewController.h"
#import "TPMainItemView.h"
#import "TPMainActivityCell.h"
#import <SDCycleScrollView.h>
//#import "YJMineViewController.h"
#import "LSPaoMaView.h"
#import "TPMainCurrencyInfoView.h"
#import "TPQuotationModel.h"
#import "TPBaseOTCViewController.h"
#import "TPWalletSendListController.h"
#import "TPWalletRecevieController.h"

#import "TPWalletAccountBookController.h"

@interface TPMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *itemIcons;
@property(nonatomic,strong)NSArray *itemNames;


@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIButton *rightButton;

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)NSMutableArray *activityArr;

@property(nonatomic,strong)NSArray *bannerArr;

@property(nonatomic,copy)NSString *infoString;

@property(nonatomic,strong)NSMutableArray * urls;


@property(nonatomic,strong)NSDictionary *infoDic;

@property(nonatomic,strong)NSMutableArray<TPQuotationModel *> *currencyInfos;

@property(nonatomic,copy)NSString *updateUrl;

@property(nonatomic,copy)NSString *updateString;

@end

@implementation TPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _activityArr = [NSMutableArray array];
    _urls = [NSMutableArray array];
    _currencyInfos = [NSMutableArray arrayWithCapacity:3];
    [self initNavi];

    [self setupUI];
    [self activeAccount];

//    [self checkUserStaus];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)initNavi
{
//    [self addLeftBarButtonWithImage:kImageFromStr(kAvatarString) action:@selector(leftButtonAction)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:kImageFromStr(@"poc_icon_navno") forState:UIControlStateNormal];
    [firstButton setImage:kImageFromStr(@"poc_icon_navpre") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
    _rightButton = firstButton;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // 注册手势驱动
//    __weak typeof(self)weakSelf = self;
//    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
//        NSLog(@"direction = %ld", direction);
//        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
//            [weakSelf leftButtonAction];
//        } else if (direction == CWDrawerTransitionFromRight) { // 右侧滑出
//                        [weakSelf rightClick];
//        }
//    }];


}
-(void)setupUI
{
    
    self.navigationItem.title = @"首页";
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight - kTabbarItemHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#111419");
    _tableView.backgroundColor = kTableColor;
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _tableView.tableHeaderView = [self setupHeadView];
    [_tableView registerNib:[UINib nibWithNibName:@"TPMainActivityCell" bundle:nil] forCellReuseIdentifier:@"TPMainActivityCell"];
    
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self loadData];
}


-(UIView *)setupHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 220)];
    
    
    UIImageView *temImgView = [[UIImageView alloc] initWithFrame:view.bounds];
    [view addSubview:temImgView];
    temImgView.image = kImageFromStr(@"banner_img_bg");
    
    
    _headView = view;
    return view;
}
-(void)loadData
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    if (internetStatus) {
        //可以访问网络
    } else {
        [_tableView.mj_header endRefreshing];
        //没有可以访问的网络
        [self showTips:@"網絡連接斷開"];
        return;
    }
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"index/index"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        [_tableView.mj_header endRefreshing];

        if (success) {
          
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            
            //banner
            NSArray *banners = [dic ksObjectForKey:@"flash"];
            _bannerArr = banners;
            NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:banners.count];
            for (NSDictionary *dict in banners) {
                [imageUrls addObject:dict[@"pic"]];
            }
            for (UIView *view in _headView.subviews) {
                if (view.tag == 1000) {
                    [view removeFromSuperview];
                }
            }
            SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:_headView.bounds delegate:self placeholderImage:kImageFromStr(@"banner_img_bg")];
            
            scrollView.imageURLStringsGroup = imageUrls.copy;
            scrollView.placeholderImage = kImageFromStr(@"banner_img_bg");
            scrollView.tag = 1000;
            scrollView.delegate = self;
            [_headView addSubview:scrollView];
            
            //公告
            _infoString = [dic[@"result"] firstObject][@"title"];
            
            _infoDic = [dic[@"result"] firstObject];
            
            //中间的url
            [self.urls removeAllObjects];
            for (NSString *url in dic[@"url"]) {
                [self.urls addObject:url];
                
            }
            
            
            //活动->持币生息
            [self.activityArr removeAllObjects];
            for (NSDictionary *dict in dic[@"money_holding"]) {
                [self.activityArr addObject:dict];
            }
            
            [self.tableView reloadData];
            
        }
    }];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"from"] = @"index";
    param[@"market"] = @"BCBcy";
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/quotation"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            
            [self.currencyInfos removeAllObjects];
            
            NSArray *datas = [responseObj ksObjectForKey:kData];
            for (NSDictionary *dic in datas) {
                [self.currencyInfos addObject:[TPQuotationModel modelWithJSON:dic]];
            }
            
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }];
    
}
/**  激活账户 没有返回值  */
-(void)activeAccount
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/active"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.activityArr.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commenCell"];
    cell.selectionStyle = 0;
//    cell.contentView.backgroundColor = kColorFromStr(@"#1E1F22");
    if (indexPath.section == 0) {
        CGFloat w  = kScreenW / 5;
        CGFloat h = 60;
        NSInteger totalColumns = 5;
        CGFloat margin = 0;
        NSInteger itemCount = 10;
        
        for (NSInteger i = 0; i < itemCount; i++) {
            // 计算行号  和   列号
            NSInteger row = i / totalColumns;
            NSInteger col = i % totalColumns;
            CGFloat x = col * (w + margin) ;
            CGFloat y = row * (h + margin + 15) ;
            
            TPMainItemView *view = [[TPMainItemView alloc] initWithFrame:kRectMake(x, y, w, h) icon:self.itemIcons[i] itemName:self.itemNames[i]];
            [cell.contentView addSubview:view];
            view.tag = i;
//            [self.itemViewArray addObject:view.subviews.firstObject];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemViewTapAction:)]];
        }

        return cell;
    }else if (indexPath.section == 1){

        CGFloat w = (kScreenW - 24 - 14)/3;
        CGFloat h = 88;
        CGFloat margin = 7;
        
        NSInteger itemCount;
        
        if (self.currencyInfos.count == 0) {
            itemCount = 0;
        }else {
            itemCount = self.currencyInfos.count;
        }
        if (itemCount > 3) {
            itemCount = 3;
        }

        
        for (NSInteger i = 0; i < itemCount; i++) {
            TPMainCurrencyInfoView *view = [[TPMainCurrencyInfoView alloc] initWithFrame:kRectMake(12 + (w + margin) * i, 5, w, h)];
            view.backgroundColor = kWhiteColor;
            [cell.contentView addSubview:view];
            view.model = self.currencyInfos[i];
        }
        
        return cell;
        
    }else if(indexPath.section == 2){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:kRectMake(kMargin, 0, 22, 22)];
        [cell.contentView addSubview:imgView];
        imgView.image = kImageFromStr(@"poc_icon_notice");
        [imgView alignVertical];
        //        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(42, 9, kScreenW - 42 -12, 15) text:_infoString font:PFRegularFont(14) textColor:kColorFromStr(@"#CDD2E3") textAlignment:0 adjustsFont:0];
        //        [cell.contentView addSubview:label];
        //        [label alignVertical];
        //        _infoLabel = label;
        
        
        if (_infoString.length < 2) {
            _infoString = @"";
        }
        
        LSPaoMaView* paomav = [[LSPaoMaView alloc] initWithFrame:kRectMake(42, 9, kScreenW - 42 -12, 15) title:_infoString];
        
        [cell.contentView addSubview:paomav];
        [paomav alignVertical];

        return cell;
    }else{
        static NSString *rid = @"TPMainActivityCell";
        TPMainActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        cell.dataDic = self.activityArr[indexPath.row];
        cell.joinButton.tag = indexPath.row;
        [cell.joinButton addTarget:self action:@selector(joinActivityAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return cell;
}


-(void)itemViewTapAction:(UITapGestureRecognizer *)tap
{
    
    if (tap.view.tag == 4) {
        
        if (kUserInfo.verify_state.intValue > 0) {
//            if ([Utilities netWorkUnAvalible]) {
//                [self showTips:@"請檢查當前網絡"];
//            }else{
                TPBaseOTCViewController *vc = [[TPBaseOTCViewController alloc] init];
                kNavPush(vc);
//            }
            
        }else{
            [self checkIndentifyStatus];
        }
        return;
    }
    if (tap.view.tag == 0) {//转账
//        kNavPush([TPTransferViewController new]);

        return;
    }
    if (tap.view.tag == 5) {//账本
        kNavPush([TPWalletAccountBookController new]);

        return;
    }
    

    
    
    
    
    
//    IMKLineChartViewController *vc = [IMKLineChartViewController ]
    if (tap.view.tag > self.urls.count) {
        return;
    }
    NSString *urlStr = self.urls[tap.view.tag];
    if ([urlStr isKindOfClass:[NSNull class]] || urlStr.length < 2) {
        [self showTips:kLocat(@"g_jqqd")];
        return;
    }else{
        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
        
        vc.showNaviBar = NO;
        if (tap.view.tag == 7) {
            vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) title:@"Explore"];
            vc.showNaviBar = YES;
            vc.titleString = @"Explore";
        }
        if ([urlStr hasPrefix:@"http"]) {
            vc.urlStr = urlStr;
        }else{
            vc.urlStr = [kBasePath stringByAppendingPathComponent:urlStr];
        }
        
        kNavPush(vc);
    }
}

-(void)joinActivityAction:(UIButton *)button
{
    NSString *url = self.activityArr[button.tag][@"url"];
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
    vc.urlStr = [kBasePath stringByAppendingPathComponent:url];
    vc.showNaviBar = NO;
    kNavPush(vc);
}




-(void)topButtonAction:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
        case 1:
        {
//            [self showTips:@"敬請期待"];
            TPWalletSendListController *vc = [TPWalletSendListController new];
            kNavPush(vc);
            
        }
            break;
        case 2:
        {
            TPWalletRecevieController *vc = [TPWalletRecevieController new];
            kNavPush(vc);
            
        }
            break;
        case 3:
        {
            _rightButton.selected = YES;
            [self rightButtonAction:_rightButton];
            
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self gotoLoginVC];
    
    if (indexPath.section == 2) {
        if (self.infoDic) {
            BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
            vc.urlStr = [NSString stringWithFormat:@"%@/Mobile/Art/details/id/%@/.html",kBasePath,self.infoDic[@"article_id"]];
            vc.showNaviBar = NO;
            kNavPush(vc);
        }
    }
}

#pragma mark - 点击轮播图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *urlStr = self.bannerArr[index][@"jump_url"];
    
    if ([urlStr isKindOfClass:[NSNull class]] || urlStr.length < 2 ) {
        return;
    }else{
        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
        vc.urlStr = urlStr;
        vc.showNaviBar = NO;
        kNavPush(vc);
    }
}

-(void)leftButtonAction
{
//    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.86 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromLeft backImage:nil];
//    YJMineViewController *vc = [[YJMineViewController alloc] init];
//    YJBaseNavController *baseVC = [[YJBaseNavController alloc] initWithRootViewController:vc];
//    [self cw_showDrawerViewController:baseVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
}

-(void)rightButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.isSelected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.x = 0;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.x = kScreenW;
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 170;
    }else if (indexPath.section == 1){
        return 88 + 10;
    }else if(indexPath.section == 2){
        return 44;
    }else{
        return 84;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 5;
    }
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 3) {
        return 5;
    }else{
        return 40;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 40)];
        view.backgroundColor = kWhiteColor;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:kRectMake(kMargin, 0, 22, 22)];
        [view addSubview:imgView];
        imgView.image = kImageFromStr(@"poc_icon_active");
        [imgView alignVertical];
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(42, 9, kScreenW - 24 -12, 15) text:@"活动" font:PFRegularFont(14) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
        [view addSubview:label];
        [label alignVertical];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:kImageFromStr(@"user_icon_getin")];
        [view addSubview:arrow];
        [arrow alignVertical];
        arrow.right = kScreenW - 12;
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 40, 16) title:@"more" titleColor:kColorFromStr(@"#CDD2E3") font:PFRegularFont(14) titleAlignment:0];
        [view addSubview:moreButton];
        [moreButton alignVertical];
        moreButton.right = arrow.left - 5;
        
        __weak typeof(self)weakSelf = self;

        [moreButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weakSelf showTips:kLocat(@"g_jqqd")];

        }];

        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 39.5, kScreenW - 24, 0.5)];
        lineView.backgroundColor = kTableColor;
        [view addSubview:lineView];
        return view;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(NSArray *)itemNames
{
    if (!_itemNames) {
        _itemNames = @[@"轉賬",@"資產交易",@"充值",@"紅包分享",@"OTC",@"賬本",@"口袋老闆",@"Explorer",@"激活用戶",@"口袋"];
    }
    return _itemNames;
}

-(NSArray *)itemIcons
{
    if (_itemIcons == nil) {
        _itemIcons = @[@"poc_icon_Transfer",@"poc_icon_Asset",@"poc_icon_Recharge",@"poc_icon_Redenve",@"poc_icon_C2C",@"poc_icon_C2Cbooks",@"poc_icon_xin_boss",@"poc_icon_liulanqi",@"poc_icon_jiuser",@"poc_icon_jiuser11"];
    }
    return _itemIcons;
}


-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(kScreenW, kNavigationBarHeight, kScreenW, 60)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#A74125");
        
        CGFloat w = 22 + 20 ;
        CGFloat h = _topView.height;
        
        NSArray *titles = @[@"客服",@"發送",@"接收",@"隐藏"];
        NSArray *icons = @[@"poc_icon_servie",@"poc_icon_funk",@"poc_icon_shouk",@"poc_icon_yinc"];
        for (NSInteger i = 0; i < 4; i++) {
            CGFloat x = (kScreenW / 4.0 - w)/2 + i * kScreenW / 4;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, 0, w, h)];
            [_topView addSubview:button];
            [button alignVertical];
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
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
    
    button.imageRect = kRectMake(10, 12, 22, 22);
    button.titleRect = kRectMake(0, 38, button.width, 12);
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
    
}


-(void)checkUserStaus
{
    [kUserDefaults setObject:[NSDate date] forKey:@"kLastTimeKey"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"token"] = kUserInfo.token;
    param[@"user_id"] = @(kUserInfo.uid);
    param[@"sign"] = [Utilities handleParamsWithDic:param];
    param[@"uuid"] = [Utilities randomUUID];
    
    [kNetwork_Tool POST_HTTPS:@"/api/Account/checkToken" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            
        }else{
            if ([[responseObj ksObjectForKey:kCode] integerValue] == 10001) {
                [kUserInfo clearUserInfo];
                
                [self gotoLoginVC];
                
                YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:[YJLoginViewController new]];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    }];
}

-(void)checkIndentifyStatus
{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"key"] = kUserInfo.token;
//    param[@"token_id"] = @(kUserInfo.uid);
//    kShowHud;
//    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Set/userInfo"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
//        kHideHud;
//        if (success) {
//            kLOG(@"%@",responseObj);
//            NSDictionary *dic = [responseObj ksObjectForKey:kData];
//
//            YJUserInfo *model = kUserInfo;
//            model.avatar = dic[@"head"];
//            model.userName = dic[@"name"];
//            model.account = dic[@"email"];
//
//            if ([dic[@"verify_time"] integerValue] > 0) {
//                model.status = @"1";
//            }else{
//                model.status = @"0";
//            }
//            [model saveUserInfo];
//
//            if (model.status.intValue == 0) {
//                [self showTips:@"請先完成實名認證"];
//            }else{
//                TPBaseOTCViewController *vc = [[TPBaseOTCViewController alloc] init];
//                kNavPush(vc);
//            }
//        }else{
//
//            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
//            if (code == 10100) {//token失效
//                [kUserInfo clearUserInfo];
//                YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:[YJLoginViewController new]];
//
//                [self presentViewController:vc animated:YES completion:nil];
//            }
//        }
//    }];
//
}


@end
