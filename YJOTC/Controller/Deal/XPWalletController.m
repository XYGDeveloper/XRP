
//
//  XPWalletController.m
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPWalletController.h"
#import <SDCycleScrollView.h>
#import "TPMainCurrencyInfoView.h"
#import "TPWalletCurrencyModel.h"
#import "XPWalletPieView.h"
#import "XPWalletChibiCell.h"
#import "TPWalletSendListController.h"
#import "TPWalletSendController.h"
#import "TPWalletRecevieController.h"
#import "XPWalletListCell.h"
#import "TPWalletCurrencyInfoController.h"
#import "TPWalletAccountBookController.h"
#import "XPAssetViewController.h"

@interface XPWalletController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,assign)BOOL firstLoad;

@property(nonatomic,strong)NSMutableArray *currencyArray;
@property(nonatomic,strong)NSDictionary *dataDic;

@property(nonatomic,strong)NSMutableArray *quotationArrs;


@end

@implementation XPWalletController


-(void)viewDidLoad
{
    [super viewDidLoad];

    _currencyArray = [NSMutableArray array];
    _quotationArrs = [NSMutableArray array];
    [self setupUI];
    [self loadDataAssetsInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAssetsInfo) name:@"kRefreshXPXRPAssetViewControllerKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAssetsInfo) name:@"kUserDidSendCurrencySuccessKey" object:nil];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"XPWalletListCell" bundle:nil] forCellReuseIdentifier:@"XPWalletListCell"];
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    
    
    [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"rui_icon_navbar") firstAction:@selector(rightButtonAction:) secondImage:kImageFromStr(@"rui_icon_sys") secondAction:@selector(scanAction)];
    
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];
    
    
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataAssetsInfo];
        [weakSelf loadData];
    }];
    [self loadData];
}
-(void)loadData
{
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Index/index"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _dataDic = [responseObj ksObjectForKey:kData];
//            [_quotationArrs removeAllObjects];
//            for (NSDictionary *dic in _dataDic[@"quotation"]) {
//                [_quotationArrs addObject:[TPQuotationModel modelWithJSON:dic]];
//            }
            
            [self.tableView reloadData];
        }
    }];
    return;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Index/quotation"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
            id quotations = [responseObj ksObjectForKey:kData];
            [_quotationArrs removeAllObjects];
            NSArray *array = [NSArray modelArrayWithClass:TPQuotationModel.class json:quotations];
//            for (NSDictionary *dic in _dataDic[@"quotation"]) {
//                [_quotationArrs addObject:[TPQuotationModel modelWithJSON:dic]];
//            }
            [_quotationArrs addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    }];
}

-(void)loadDataAssetsInfo
{
    
    if ([Utilities isExpired]) {
        [_tableView.mj_header endRefreshing];
        _tableView.tableHeaderView = [self setupHeadView];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_firstLoad == YES) {
        kShowHud;
    }
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/asset_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];
        _firstLoad = NO;
        kHideHud;
        if (success) {
            [self.currencyArray removeAllObjects];
            NSArray *datas = [responseObj ksObjectForKey:kData];
            for (NSDictionary*dic in datas) {
                [self.currencyArray addObject:[TPWalletCurrencyModel modelWithJSON:dic]];
            }
            _tableView.tableHeaderView = [self setupHeadView];
            
            [self.tableView reloadData];
            
        }else{
            
        }
    }];
}



-(UIView *)setupHeadView
{
    XPWalletPieView *headView = [[XPWalletPieView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50 + 200 + 5)];
    if ([Utilities isExpired]) {
        headView.notLogin = YES;
    }else{
        headView.currencyArray = self.currencyArray;
    }
    return headView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([Utilities isExpired]) {
        return 1;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDic == nil) {
        return 0;
    }
    
    
    if (isInvalid) {
        return 1;
    }else{
        
        if (section == 0) {
            return self.currencyArray.count;
        }else{
            return 1;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;

    if (isInvalid) {
        static NSString *rid = @"XPWalletChibiCell";
        XPWalletChibiCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.volumeLabel.hidden = NO;
        cell.descW.constant = 126 ;
        cell.descLabel.adjustsFontSizeToFitWidth = YES;
        cell.nameLabel.text = _dataDic[@"asset_bank"][@"title"];
        cell.descLabel.text = _dataDic[@"asset_bank"][@"info"];
        cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
        cell.supportLabel.text = _dataDic[@"asset_bank"][@"support"];
        cell.icon.image = kImageFromStr(@"fi_icon_inte");
        [cell.joinButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //            kNavPushSafe([TPTransferViewController new]);
            [weakSelf showTips:kLocat(@"Coming soon")];
        }];
        return cell;

    }
    
    
    if (indexPath.section == 0) {
        
        static NSString *rid = @"XPWalletListCell";
        XPWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = self.currencyArray[indexPath.row];
        return cell;
        
//        UITableViewCell *cell = [UITableViewCell new];
//
//        cell.contentView.backgroundColor = kTableColor;
//        cell.selectionStyle = 0;
//
//        UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 120)];
//        [cell.contentView addSubview:bgView];
//
//        bgView.backgroundColor = kWhiteColor;
//        [bgView.layer setCornerRadius:8];
//
//        [bgView addShadow];
//
//        UIScrollView *scView = [[UIScrollView alloc]initWithFrame:bgView.bounds];
//        [bgView addSubview:scView];
//        scView.showsVerticalScrollIndicator = NO;
//        scView.showsHorizontalScrollIndicator = NO;
//        CGFloat w = bgView.width/3;
//        CGFloat h = scView.height-20;
//        NSInteger itemCount = [self.quotationArrs count];
//        for (NSInteger i = 0; i < itemCount; i++) {
//            TPMainCurrencyInfoView *view = [[TPMainCurrencyInfoView alloc] initWithFrame:kRectMake(w * i, 5, w, h)];
//            view.backgroundColor = kWhiteColor;
//            view.model = self.quotationArrs[i];
//            [scView addSubview:view];
//        }
//        scView.contentSize = kSizeMake(w * itemCount, 0);
//
//        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:kRectMake(0, 100, 100, 20)];
//        [bgView addSubview:pageControl];
//        [pageControl alignHorizontal];
//        pageControl.pageIndicatorTintColor = kColorFromStr(@"#E4A646");
//        pageControl.currentPageIndicatorTintColor = kColorFromStr(@"#CCCCCC");
//        pageControl.currentPage = 0;
//        pageControl.numberOfPages = (itemCount-1)/3+1;
//        return cell;
        
    }else if (indexPath.section == 1){
        static NSString *rid = @"XPWalletChibiCell";
        XPWalletChibiCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.volumeLabel.hidden = NO;
        cell.descW.constant = 126 ;
        cell.descLabel.adjustsFontSizeToFitWidth = YES;
        cell.nameLabel.text = _dataDic[@"asset_bank"][@"title"];
        cell.descLabel.text = _dataDic[@"asset_bank"][@"info"];
        cell.volumeLabel.text = [NSString stringWithFormat:@"%@%%",_dataDic[@"asset_bank"][@"rate"]];
        cell.supportLabel.text = _dataDic[@"asset_bank"][@"support"];
        cell.icon.image = kImageFromStr(@"fi_icon_inte");
        [cell.joinButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            //            kNavPushSafe([TPTransferViewController new]);
            [weakSelf showTips:kLocat(@"Coming soon")];
        }];
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isInvalid) {
//        [self showTips:kLocat(@"g_jqqd")];
        [self gotoLoginVC];
    }else{
        if (indexPath.section == 1) {
//            [self showTips:kLocat(@"g_jqqd")];
            kNavPush([XPAssetViewController new]);

        }else{
            
            TPWalletCurrencyInfoController *vc = [TPWalletCurrencyInfoController new];
            
            vc.model = self.currencyArray[indexPath.row];
            
            kNavPush(vc);
        }
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 97+20;
    }
    
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
 
 

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return [self createTopViewWithTitle:kLocat(@"M_AssetList") showMore:NO action:nil];

    }else{
        return [self createTopViewWithTitle:kLocat(@"x_xassetbank") showMore:NO action:nil];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 200, 16) text:str font:PFRegularFont(16) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
    [view addSubview:label];
    label.centerY = line.centerY;
    
    if (showMore) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 55, 40) title:kLocat(@"W_more") titleColor:kColorFromStr(@"#066B98") font:PFRegularFont(14) titleAlignment:0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [view addSubview:button];
//        [button sizeToFit];
        [button alignVertical];
        button.right = kScreenW - 12;
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return view;
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

-(void)scanAction
{
    if (isInvalid) {
        [self gotoLoginVC];
        return;
    }
    TPWalletSendListController *vc = [TPWalletSendListController new];
    vc.toScan = YES;
    kNavPush(vc);
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
    if (button.tag  < 3) {
        if (isInvalid) {
            [self gotoLoginVC];
            return;
        }
    }
    
    switch (button.tag) {
        case 0:
        {
            kNavPush([TPWalletSendListController new]);
        }
            break;
        case 1:
        {
            kNavPush([TPWalletRecevieController new]);
        }
            break;
        case 2:
        {
            kNavPush([TPWalletAccountBookController new]);
        }
            break;
        case 3:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.topView.height = 0;
                self.tableView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight - kTabbarItemHeight);
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
        
        CGFloat w = 22 + 20 ;
        CGFloat h = _topView.height;
        
        NSArray *titles = @[kLocat(@"W_Send"),kLocat(@"W_receive"),kLocat(@"x_xzhangben"),kLocat(@"x_xfold")];
        NSArray *icons = @[@"fi_icon_send",@"fi_icon_Receive",@"fi_icon_bokking",@"fi_icon_fold"];
        CGFloat margin = (kScreenW - 24 - w*titles.count)/3;
        for (NSInteger i = 0; i < icons.count; i++) {
            CGFloat x = (kScreenW / icons.count - w)/2 + i * kScreenW / icons.count;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, 0, w, h)];
            [_topView addSubview:button];
            [button alignVertical];
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                button.x  = 12;
            }else if (i == 1){
                button.x = 12 + w + margin;
            }else if (i == 2){
                button.x = 12 + 2*(margin + w);
            }else if(i == titles.count-1){
                button.right = kScreenW - 12;
            }
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
    
    button.imageRect = kRectMake(5, 12, 34, 34);
    button.titleRect = kRectMake(0, 50, button.width, 12);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
    
}


@end
