
//
//  XPXRPViewController.m
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPXRPViewController.h"
#import "XPWalletChibiCell.h"
#import "XPMineMoreItemCell.h"
#import <SDCycleScrollView.h>
#import <SafariServices/SFSafariViewController.h>
#import "TPWalletAccountBookController.h"
#import "XPZhuanZhangController.h"
#import "XPAssetBankListController.h"
#import "XPCommunityViewController.h"
#import "TPQuotationModel.h"
#import "XPXRPAssetViewController.h"
#import "XPAssetViewController.h"
#import "XPXRPBannerCell.h"
#import "TPMainCurrencyInfoView.h"
#import "XPReleaseViewController.h"
#import "LSPaoMaView.h"
#import "XPMemberListerViewController.h"
#import "XNIdentifyViewController.h"
#import "XPInnovateViewController.h"
#import "XPNoticeViewController.h"
#import "LXAlertView.h"
#import "XPInnovationHomeViewController.h"
#import "XPInternalPurchaseViewController.h"
@interface XPXRPViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray *quotationArrs;

@property(nonatomic,strong)NSMutableArray *XRPArrays;


@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,copy)NSString *bannerStr;
@property(nonatomic,copy)NSString *articleId;

@property(nonatomic,copy)NSString *updateUrl;


@end

@implementation XPXRPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _quotationArrs = [NSMutableArray array];

    [self setupUI];
//    [self loadData];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"type"] = @"6";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [self checkIfGoToLoginVc];
}

-(void)setupUI
{
    self.topView.y = kNavigationBarHeight;
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,self.topView.bottom, kScreenW, kScreenH  - kTabbarItemHeight - self.topView.bottom) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kTableColor;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"XPWalletChibiCell" bundle:nil] forCellReuseIdentifier:@"XPWalletChibiCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPMineMoreItemCell" bundle:nil] forCellReuseIdentifier:@"XPMineMoreItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPXRPBannerCell" bundle:nil] forCellReuseIdentifier:@"XPXRPBannerCell"];
//    _tableView.estimatedSectionFooterHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
    
    
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];

    [self addRightBarButtonWithFirstImage:kImageFromStr(@"rui_icon_navbar") action:@selector(rightButtonAction:)];
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
        [weakSelf versionControl];
    }];
//    [self loadData];
    [_tableView.mj_header beginRefreshing];
    
}


-(void)loadData
{

    if ([Utilities netWorkUnAvalible]) {
        self.tableView.hidden = YES;
        [[EmptyManager sharedManager]showNetErrorOnView:self.view response:nil operationBlock:^{
            [self versionControl];
        }];
        return;
    }else{
        self.tableView.hidden = NO;

        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Index/index"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            dispatch_group_leave(group);
            if (success) {
                _dataDic = [responseObj ksObjectForKey:kData];
                
                if ([_dataDic[@"url"][@"invit_code"]  length] < 2) {
                    [kUserInfo clearUserInfo];
                }
                
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"type"] = @"1";
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/news/ad"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            dispatch_group_leave(group);

            if (success) {
                _bannerStr = [responseObj ksObjectForKey:kData][@"title"];
                _articleId  = ConvertToString([responseObj ksObjectForKey:kData][@"article_id"]);
                //                [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/quotation1"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {    
            dispatch_group_leave(group);
            [[EmptyManager sharedManager] removeEmptyFromView:self.view];
            
            if (success) {
                NSArray *arr = [[responseObj ksObjectForKey:kData] firstObject][@"data_list"];
                _XRPArrays = [NSMutableArray new];
                for (NSDictionary *dic in arr) {
                    XPQuotationModel *model = [XPQuotationModel modelWithJSON:dic];
                    [_XRPArrays addObject:model];
                }
                for (NSDictionary *dic in [[responseObj ksObjectForKey:kData] lastObject][@"data_list"]) {
                    XPQuotationModel *model = [XPQuotationModel modelWithJSON:dic];
                    [_XRPArrays addObject:model];
                }
            }
        }];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            kHideHud;
            [_tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDic) {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;

    if (indexPath.section == 0) {
        static NSString *rid = @"XPXRPBannerCell";
        XPXRPBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        for (UIView *v in cell.bgView.subviews) {
            if (v.tag == 10000) {
                [v removeFromSuperview];
            }
        }
        
        if (_bannerStr.length > 1) {
            LSPaoMaView* paomav = [[LSPaoMaView alloc] initWithFrame:kRectMake(31, 10, kScreenW - 24 - 31 - 24, 20) title:_bannerStr];
            paomav.tag = 10000;
            [cell.bgView addSubview:paomav];
//            [paomav alignVertical];
        }
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.contentView.backgroundColor = kTableColor;
        cell.selectionStyle = 0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, 2, kScreenW - 24, 160*(kScreenW-24)/350.0)];
        [cell.contentView addSubview:bgView];
        
        bgView.backgroundColor = kWhiteColor;
        [bgView.layer setCornerRadius:8];
        
        [bgView addShadow];

        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[_dataDic[@"flash"] count]];
        
        for (NSDictionary *dic in _dataDic[@"flash"]) {
            [images addObject:dic[@"pic"]];
        }
        
        SDCycleScrollView *scView = [SDCycleScrollView cycleScrollViewWithFrame:bgView.bounds delegate:self placeholderImage:kImageFromStr(@"xrp_img_banner1")];
        scView.imageURLStringsGroup = images;
        
        [bgView addSubview:scView];
        scView.currentPageDotColor = kColorFromStr(@"#E4A646");
        scView.pageDotColor = kColorFromStr(@"#CCCCCC");
        kViewBorderRadius(scView, 8, 0, kRedColor);
  
        return cell;
        
    }else if (indexPath.section == 3){
        static NSString *rid = @"XPMineMoreItemCell";
        XPMineMoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        [cell configureItemInfoWithTitleArray:@[kLocat(@"s0219_toupiaojihjua"),kLocat(@"x_xzhaunzhan"),kLocat(@"s0219_redpacket"),kLocat(@"x_xzhangben")] icons:@[@"xrp_icon_tpjh",@"xrp_icon_go",@"xrp_icon_zsx",@"xrp_icon_tran"]];
                        
        [cell.button0 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
            if (isInvalid) {
                [weakSelf gotoLoginVC];
            }else{
                kNavPushSafe([XPCommunityViewController new]);
//                kNavPush([XPInnovationHomeViewController new]);
            }
        }];
        [cell.button1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
            if (isInvalid) {
                [weakSelf gotoLoginVC];
            }else{
                
                kNavPushSafe([XPZhuanZhangController new]);
            }
        }];
        
        [cell.button2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (isInvalid) {
                [weakSelf gotoLoginVC];
            }else{
                
                kNavPushSafe([XPReleaseViewController new]);
            }
        }];
        [cell.button3 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (isInvalid) {
                [weakSelf gotoLoginVC];
            }else{
                kNavPushSafe([TPWalletAccountBookController new]);
            }
        }];
        return cell;
 
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [UITableViewCell new];
        
        cell.contentView.backgroundColor = kTableColor;
        cell.selectionStyle = 0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 120)];
        [cell.contentView addSubview:bgView];
        
        bgView.backgroundColor = kWhiteColor;
        [bgView.layer setCornerRadius:8];
        
        [bgView addShadow];
        
        UIScrollView *scView = [[UIScrollView alloc]initWithFrame:bgView.bounds];
        [bgView addSubview:scView];
        scView.showsVerticalScrollIndicator = NO;
        scView.showsHorizontalScrollIndicator = NO;
        CGFloat w = bgView.width/3;
        CGFloat h = scView.height-20;
        NSInteger itemCount = [self.XRPArrays count];
        for (NSInteger i = 0; i < itemCount; i++) {
            TPMainCurrencyInfoView *view = [[TPMainCurrencyInfoView alloc] initWithFrame:kRectMake(w * i, 5, w, h)];
            view.backgroundColor = kWhiteColor;
//            view.model = self.quotationArrs[i];
            view.model = self.XRPArrays[i];

            [scView addSubview:view];
        }
        scView.contentSize = kSizeMake(w * itemCount, 0);
        scView.delegate = self;
        scView.tag = 10000;
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:kRectMake(0, 100, 100, 20)];
        [bgView addSubview:pageControl];
        [pageControl alignHorizontal];
        pageControl.currentPageIndicatorTintColor = kColorFromStr(@"#E4A646");
        pageControl.pageIndicatorTintColor = kColorFromStr(@"#CCCCCC");
        pageControl.currentPage = 0;
        pageControl.numberOfPages = (itemCount-1)/3+1;
//        pageControl.numberOfPages = (itemCount)/3+0;

        pageControl.userInteractionEnabled = NO;
        _pageControl = pageControl;
        return cell;
    }else{
        
        static NSString *rid = @"XPWalletChibiCell";
        XPWalletChibiCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }

        if (indexPath.section == 14) {
            if (isInvalid) {
                cell.nameLabel.text = kLocat(@"S0114_sorry");
                cell.volumeLabel.hidden = YES;
                cell.isLogin = NO;
                
                [cell.loginButton addTarget:self action:@selector(gotoLoginVC) forControlEvents:UIControlEventTouchUpInside];
                [cell.registerButton addTarget:self action:@selector(gotoRegisterVC) forControlEvents:UIControlEventTouchUpInside];

                cell.icon.image = kImageFromStr(@"yaoyue_icon_inte");
            }else{
                cell.isLogin = YES;

                cell.volumeLabel.hidden = NO;
                cell.descW.constant = 126 ;
                cell.descLabel.adjustsFontSizeToFitWidth = YES;
                
                cell.volumeLabel.text = _dataDic[@"url"][@"invit_code"];

                cell.icon.image = kImageFromStr(@"yaoyue_icon_inte");
                cell.nameLabel.text = kLocat(@"x_MineinvitTitle");
                cell.descLabel.text = kLocat(@"x_Mineinvitcode");
                cell.supportLabel.text = kLocat(@"x_Mineinvitdesc");
                [cell.joinButton setTitle:@"Go" forState:UIControlStateNormal];
                
            }
        }else if(indexPath.section == 4){
            cell.isLogin = YES;

            cell.volumeLabel.hidden = NO;
            cell.descW.constant = 126 ;
            cell.descLabel.adjustsFontSizeToFitWidth = YES;
            cell.nameLabel.text = _dataDic[@"asset_bank"][@"title"];
            cell.descLabel.text = _dataDic[@"asset_bank"][@"info"];
            cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
            cell.supportLabel.text = _dataDic[@"asset_bank"][@"support"];
            cell.icon.image = kImageFromStr(@"fi_icon_inte");

        }else if (indexPath.section == 5){
            cell.isLogin = YES;

            cell.volumeLabel.hidden = YES;
            cell.descW.constant = kScreenW - 76 - 67;
            cell.descLabel.adjustsFontSizeToFitWidth = NO;
            cell.nameLabel.text = _dataDic[@"innovation_zone"][@"title"];
            cell.descLabel.text = _dataDic[@"innovation_zone"][@"info"];
            //            cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
            cell.supportLabel.text = _dataDic[@"innovation_zone"][@"support"];
            cell.icon.image = kImageFromStr(@"fi_icon_zone");
        }else if (indexPath.section == 34){
            cell.isLogin = YES;
            
            cell.volumeLabel.hidden = YES;
            cell.descW.constant = kScreenW - 76 - 67;
            cell.descLabel.adjustsFontSizeToFitWidth = NO;
            cell.nameLabel.text = _dataDic[@"boss_plan"][@"title"];
            cell.descLabel.text = _dataDic[@"boss_plan"][@"info"];
            //            cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
            cell.supportLabel.text = _dataDic[@"boss_plan"][@"support"];
            cell.icon.image = kImageFromStr(@"bossi_icon_inte");
        }

        return cell;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 65;
//    }else if (indexPath.section == 1) {
//        return 160*(kScreenW-24)/350 + 10;
//    }else if (indexPath.section == 2){
//        return 97 + 8;
//    }else if(indexPath.section == 3){
//        return  120+10;
//    }else if(indexPath.section == 4){
//        return  105;
//    }

    if (indexPath.section == 0) {
        return 65;
    }else if (indexPath.section == 1) {
        return 160*(kScreenW-24)/350 + 10;
    }else if (indexPath.section == 2){
        return 130;
    }else if (indexPath.section == 3){
        return 105;
    }else{
        return 105;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 6) {
        return 15;
    }
    return 0.01;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        return 0.01;
    }
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (_dataDic == nil) {
        return nil;
    }
    
    if (section < 2) {
        return nil;
    }else if (section == 3) {
        return [self createTopViewWithTitle:kLocat(@"x_xApplication") showMore:NO action:nil];
    }else if(section == 2){
        return [self createTopViewWithTitle:kLocat(@"M_Price") showMore:NO action:nil];
    }else if(section == 14){
        return [self createTopViewWithTitle:kLocat(@"x_MineInvite") showMore:NO action:nil];
    }else if(section == 4){
        return [self createTopViewWithTitle:kLocat(@"x_xassetbank") showMore:NO action:nil];
    }else if(section == 5){
        return [self createTopViewWithTitle:kLocat(@"M_InnvoteTitle") showMore:NO action:nil];
    }else if(section == 24){
        return [self createTopViewWithTitle:kLocat(@"x_Minebooosplan") showMore:NO action:nil];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0://跑马灯点击事件
        {
            XPNoticeViewController *vc = [XPNoticeViewController new];
            vc.type = 1;
            kNavPush(vc);
        }
            break;
            
        case 2:
            self.tabBarController.selectedIndex = 2;
            break;
        case 14://邀請好友
        {
            if (isInvalid) {
                return;
            }
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"key"] = kUserInfo.token;
            param[@"token_id"] = @(kUserInfo.uid);
            kShowHud;
            [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Account/is_login"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
                kHideHud;
                if (success) {
                 NSString * url = _dataDic[@"url"][@"invit_url"];
                    BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:url title:nil];
                    kNavPush(vc);
                    return;
                }
            }];
            return;
        }
            break;
        case 4://资产银行
//            [self showTips:kLocat(@"Coming soon")];
            if (isInvalid) {
                [self gotoLoginVC];
            }else{
                kNavPush([XPAssetViewController new]);
            }
            
            break;
            
        case 5://創新區
            if (isInvalid) {
                [self gotoLoginVC];
            }else{
                kNavPush([XPInnovationHomeViewController new]);
            }

            break;
        case 16://老板计划
            if (isInvalid) {
                [self gotoLoginVC];
            }else{
//                [self showTips:kLocat(@"Coming soon")];
                kNavPush([XPCommunityViewController new]);
            }
            break;
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 10000) {
//        kLOG(@"%.2f==%.2f",scrollView.contentOffset.y,scrollView.contentOffset.x);
        
        
       _pageControl.currentPage = scrollView.contentOffset.x / (kScreenW-24);
        
//        if (scrollView.contentOffset.x >= (kScreenW-24)) {
//            _pageControl.currentPage = 1;
//        }else{
//            _pageControl.currentPage = 0;
//        }
    }
}

-(UIView *)createTopViewWithTitle:(NSString *)str showMore:(BOOL)showMore action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    view.backgroundColor = kTableColor;
    UILabel *line = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 2, 20)];
    line.backgroundColor = kNaviColor;
    [view addSubview:line];
    [line alignVertical];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 250, 16) text:str font:PFRegularFont(16) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
    [view addSubview:label];
    label.centerY = line.centerY;
    
    if (showMore) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 38, 40) title:@"More" titleColor:kColorFromStr(@"#066B98") font:PFRegularFont(14) titleAlignment:0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [view addSubview:button];
        [button alignVertical];
        button.right = kScreenW - 12;
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
}

#pragma mark - 点击事件

-(void)scanAction
{
    
}

-(void)rightButtonAction:(UIButton *)button
{
    if (self.topView.height == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 70);
            self.tableView.frame = kRectMake(0, self.topView.bottom, kScreenW, kScreenH - self.topView.bottom - kTabbarItemHeight);
        }];
    }
}
-(void)topButtonAction:(UIButton *)button
{
    __block NSString *url;
    
    if (button.tag == 0) {
        url = _dataDic[@"url"][@"homepage"];
    }else if (button.tag == 1){
        url = _dataDic[@"url"][@"white_paper"];
        SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }else if (button.tag == 2){
        url = _dataDic[@"url"][@"block_query"];
    }else if (button.tag == 3){
  
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
            return;
        }else{
            
            kNavPush([XPMemberListerViewController new]);
            return;
        }
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.height = 0;
            self.tableView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight - kTabbarItemHeight);
        }];
        return;
    }
    
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) title:button.currentTitle];
    if ([url containsString:@"http"]) {
        vc.urlStr = url;
    }else{
        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,url];
    }
    
    kNavPush(vc);
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    NSString *url = _dataDic[@"flash"][index][@"jump_url"];
    if (url.length < 3) {
        return;
    }
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:@""];
    if ([url containsString:@"http"]) {
        vc.urlStr = url;
    }else{
        
        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,url];
    }
    kNavPush(vc);
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

-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 70)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#225686");
        
        CGFloat h = _topView.height;
        
//        NSArray *titles = @[@"Send",@"Receive",@"Receive",@"Receive",@"Flod"];
        NSArray *titles = titles = @[kLocat(@"x_xguanwnag"),kLocat(@"x_xbps"),kLocat(@"x_xblock"),kLocat(@"x_MyFriend"),kLocat(@"x_xfold")];
        NSArray *icons = @[@"xrp_icon_home",@"xrp_icon_white",@"xrp_icon_block",@"xrp_icon_infr",@"fi_icon_fold"];
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
/**  判断是都需要进登录页面  */
-(void)checkIfGoToLoginVc
{
    NSInteger type = [kUserDefaults integerForKey:@"kToLoginOrRegisterKey"];
    [kUserDefaults setInteger:0 forKey:@"kToLoginOrRegisterKey"];
    if (type == 1) {
        [self gotoLoginVC];
    }else if(type == 2) {
        [self gotoRegisterVC];
    }
}
#pragma mark - 版本控制
- (void)versionControl{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/District/version"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        //http://d.bcbcom.club/q3
        if (success) {
            
            kLOG(@"%@",responseObj);
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            // app build版本
            
            NSDictionary *dic = [responseObj ksObjectForKey:kResult];
            
            int time =  [dic[@"last_get"] longLongValue] - [NSDate new].timeIntervalSince1970;
            
            [kUserDefaults setObject:@(time) forKey:kServiceTimeKey];
            
            [self loadData];
            
            if ([kBasePath containsString:@"tp://te"]) {
                return;
            }
            
            NSArray *tipsArr = dic[@"mobile_apk_explain"];
            NSMutableString *tipsStr = [NSMutableString new];
            for (NSDictionary *dic in tipsArr) {
                [tipsStr appendString:[NSString stringWithFormat:@"%@\n",dic[@"text"]]];
            }
            
            if (![dic[@"versionName"] isEqualToString:app_Version]) {
                
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:kLocat(@"U_updataTips") message:tipsStr.mutableCopy cancelBtnTitle:nil otherBtnTitle:kLocat(@"U_update") clickIndexBlock:^(NSInteger clickIndex) {
                    
                    [self gotoSafariUpdataWith:_updateUrl];
                    
                }];
                alert.animationStyle = LXASAnimationDefault;
                [alert showLXAlertView];
                alert.dontDissmiss = YES;
                
                _updateUrl = dic[@"downloadUrl"];
                
            }
        }
    }];
}

-(void)gotoSafariUpdataWith:(NSString *)urlStr
{
    //    NSString * urlStr = url;
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open %d",success);
                                         }];
            } else {
            }
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
