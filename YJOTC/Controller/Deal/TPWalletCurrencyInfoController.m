//
//  TPWalletCurrencyInfoController.m
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletCurrencyInfoController.h"
#import "TPWalletCurrencyDetailListCell.h"
#import "TPWalletRecevieController.h"
#import "HYChartView.h"
#import "TPWalletSendController.h"
#import "TPWalletLockController.h"
#import "TPWalletReleaseController.h"
#import "TPWalletAccountBookController.h"
#import "XPAssetViewController.h"
#import "XPXRPAssetViewController.h"
#import "XPCommunityViewController.h"
#import "TPWalletAccountDetailController.h"


@interface TPWalletCurrencyInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)HYChartView *chartView;
@property(nonatomic,strong)NSArray *historyArray;

@property(nonatomic,copy)NSString *volume;
@property(nonatomic,copy)NSString *CNY;

@property(nonatomic,strong)UILabel *volumeLabel;
@property(nonatomic,strong)UILabel *cnyLabel;
@property(nonatomic,strong)NSString *is_send;



@property(nonatomic,strong)UIButton *rightButton;

@property(nonatomic,assign)BOOL isXRP;



@end

@implementation TPWalletCurrencyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
//    if ([_model.currency_mark isEqualToString:@"XRP"]) {
//        _isXRP = YES;
//    }
    
    
    [self initNavi];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kUserDidSendCurrencySuccessKey" object:nil];

    [self loadData];

    
    [self createCurrencyAddress];
    
}
/**  创建钱包  */
-(void)createCurrencyAddress
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _model.currency_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/createWalletAddress"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
        }
    }];
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
    [firstButton setImage:kImageFromStr(@"rui_icon_navbar") forState:UIControlStateNormal];
    [firstButton setImage:kImageFromStr(@"rui_icon_navbar") forState:UIControlStateSelected];
    [firstButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
    _rightButton = firstButton;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
-(void)setupUI
{
    
    self.navigationItem.title = _model.currency_mark;
    CGFloat topH = _isXRP == YES?130:60;
    self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, topH);   self.topView.alpha = 1;
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight + topH, kScreenW, kScreenH - kNavigationBarHeight - 45- topH) style:UITableViewStyleGrouped];
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
//    _tableView.tableHeaderView = [self setupHeadView];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletCurrencyDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPWalletCurrencyDetailListCell"];
    
    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    
    [self rightButtonAction:nil];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:kRectMake(0, kScreenH - 45, kScreenW/2.0, 45) title:kLocat(@"W_Send") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:sendButton];
    sendButton.backgroundColor = kColorFromStr(@"#EA6E44");
    [sendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (weakSelf.model.take_switch == 2) {
            [weakSelf showTips:kLocat(@"W_thiscurrencycanntsend")];
            return;
        }
        TPWalletSendController *vc = [TPWalletSendController new];
        vc.model = weakSelf.model;
        
        kNavPushSafe(vc);
    }];
    
    UIButton *receiveButton = [[UIButton alloc] initWithFrame:kRectMake(sendButton.right, kScreenH - 45, kScreenW/2.0, 45) title:kLocat(@"W_receive") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:receiveButton];
    receiveButton.backgroundColor = kColorFromStr(@"#03C086");
    [receiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (_model.recharge_switch == 2) {
            [weakSelf showTips:kLocat(@"W_thiscurrencycanntreceive")];
            return;
        }
        TPWalletRecevieController *vc = [TPWalletRecevieController new];
        vc.currencyID = weakSelf.model.currency_id;
//        if ([weakSelf.model.currency_mark containsString:@"XRP"]) {
//            vc.isXRP = YES;
//        }else{
//            vc.isXRP = NO;
//        }
        kNavPushSafe(vc);
    }];

//    if (_model.take_switch == 2) {
//        sendButton.enabled = NO;
//    }
//    if (_model.recharge_switch == 2) {
//        receiveButton.enabled = NO;
//    }
}


-(void)loadData
{
    [self loadTradeLog];
    [self loadHistory];
    [self getUserInpayLogWith:_model.currency_id];
}

-(void)loadTradeLog
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currency_id;
    param[@"rows"] = @"100";
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/getTibiList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        [_tableView.mj_header endRefreshing];
        if (success) {
//            NSLog(@"-------%@",responseObj);
//            NSString *volume = [responseObj ksObjectForKey:kData][@"user"][@"num"];
//            NSString *CNY = [responseObj ksObjectForKey:kData][@"user"][@"cny_total"];
//            _CNY = CNY;
//            _volume = volume;
//            _cnyLabel.text = [NSString stringWithFormat:@"≈¥%@",_CNY];
//            _volumeLabel.text = _volume;
//            NSArray *data = [responseObj ksObjectForKey:kData][@"list"];
//            self.is_send = [NSString stringWithFormat:@"%@",[responseObj ksObjectForKey:kData][@"currency"][@"is_send"]];
//            NSLog(@"----------%@",self.is_send);
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData]) {
                [self.dataArray addObject:dic];
            }
            if ([[responseObj ksObjectForKey:kData] count] == 0) {
                [self showTips:kLocat(@"OTC_order_norecord")];
            }

            [self.tableView reloadData];

            
        }else{
//            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(void)loadHistory
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currency_id;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/getAssetChangeList"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {

        if (success) {
            _historyArray = [responseObj ksObjectForKey:kData];
            self.tableView.tableHeaderView = [self setupHeadView];
        }else{
            
        }
    }];
}

//拉取用户转入记录
-(void)getUserInpayLogWith:(NSString *)currencyID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/inpay_log"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.dataArray.count == 0) {
        
        UITableViewCell *cell = [UITableViewCell new];
        cell.contentView.backgroundColor = kTableColor;
        UIImageView *noContentView = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 149)/2.0, 20, 149, 73)];
        [cell.contentView addSubview:noContentView];
        noContentView.image = kImageFromStr(@"lay_img_zwjl");
        
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, noContentView.bottom - 10, kScreenW, 14) text:kLocat(@"OTC_order_norecord") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
        [cell.contentView addSubview:label];
        cell.selectionStyle = 0;
        return cell;
        
    }else{
        
        static NSString *rid = @"TPWalletCurrencyDetailListCell";
        TPWalletCurrencyDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        cell.dataDic = self.dataArray[indexPath.row];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.dataArray.count > 0) {
//        NSDictionary *dic = self.dataArray[indexPath.row];
//        TPWalletAccountDetailController *vc = [TPWalletAccountDetailController new];
//        vc.dic = dic;
//        kNavPush(vc);
//    }
}

-(void)topButtonAction:(UIButton *)button
{
    
    switch (button.tag) {
        case 0://扫一扫
        {
            __weak typeof(self)weakSelf = self;
            KSScanningViewController *vc = [[KSScanningViewController alloc] init];
            vc.callBackBlock = ^(NSString *scannedStr) {
                
                TPWalletSendController *vc = [TPWalletSendController new];
                vc.model = weakSelf.model;
                vc.addressStr = scannedStr;
                kNavPushSafe(vc);
            };
            
            [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
        }
            break;
        case 1:
        {
            kNavPush([TPWalletAccountBookController new]);

        }
            break;
        case 2:
        {
//            [self showTips:kLocat(@"g_jqqd")];
            kNavPush([XPCommunityViewController new]);

        }
            break;
        case 3:
        {
            
//            [self showTips:kLocat(@"g_jqqd")];
            kNavPush([XPAssetViewController new]);


        }
            break;
        case 4:
        {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.topView.height = 0;
                self.topView.hidden = NO;

                self.tableView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
            } completion:^(BOOL finished) {
                self.topView.hidden = YES;
            }];
            

        }
            break;
        case 5:
        {
            kNavPush([XPXRPAssetViewController new]);

//            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return 140;
    }
    return 65;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 46)];
    v.backgroundColor = kTableColor;
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 100, 14) text:kLocat(@"W_LatestRecoord") font:PFRegularFont(14) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [v addSubview:label];
    
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 25)];
    view.backgroundColor = kTableColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 60, 25) text:kLocat(@"W_NoMoreData") font:PFRegularFont(12) textColor:k666666Color textAlignment:1 adjustsFont:YES];
    [view addSubview:label];
    [label alignHorizontal];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
    lineView.backgroundColor = k666666Color;
    [view addSubview:lineView];
    [lineView alignVertical];
    lineView.right = label.left - 10;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
    lineView1.backgroundColor = k666666Color;
    [view addSubview:lineView1];
    [lineView1 alignVertical];
    lineView1.left = label.right + 10;
    return view;
}

-(UIView *)setupHeadView
{
    UIView *headerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 180 + 48)];
    headerView.backgroundColor = kWhiteColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(0, 3, kScreenW, 16) text:kLocat(@"W_available") font:PFRegularFont(15) textColor:kColorFromStr(@"999999") textAlignment:1 adjustsFont:YES];
    [headerView addSubview:title];
    
    UILabel *volumeLabel = [[UILabel alloc]initWithFrame:kRectMake(0, 25, kScreenW, 25) text:_model.total font:PFRegularFont(30) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    
    [headerView addSubview:volumeLabel];
    
    UILabel *cnyLabel = [[UILabel alloc]initWithFrame:kRectMake(0, 60, kScreenW, 14) text:[NSString stringWithFormat:@"≈$%@",_model.cny] font:PFRegularFont(13) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    
    [headerView addSubview:cnyLabel];
    _cnyLabel = cnyLabel;
    _volumeLabel = volumeLabel;
    
    _cnyLabel.text = [NSString stringWithFormat:@"≈%@%@",_model.nw_price_unit,_model.cny];
    _volumeLabel.text = _model.money;

 
    NSMutableArray *date = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:7];
    for (NSDictionary *dic in self.historyArray) {
        [date addObject:dic[@"cac_time"]];
        [values addObject:[NSString stringWithFormat:@"%@",dic[@"cac_money"]]];
    }
    
    
//    _chartView = [[HYChartView alloc] initWithFrame:CGRectMake(0, 82, self.view.bounds.size.width, 138) xValues:@[@"10.01",@"10.02",@"10.03",@"10.04",@"10.05",@"10.06",@"10.07"] yValues:@[@"2.0",@"10.02",@"5.7",@"19.0",@"8.7",@"10.0",@"0.0"] shadowEnabled:YES];
    _chartView = [[HYChartView alloc] initWithFrame:CGRectMake(3, 82, self.view.bounds.size.width-6, 138) xValues:date yValues:values shadowEnabled:YES];
    _chartView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00];

//    _chartView.yMarkTitles = @[@"2",@"6"];
    
    BOOL hideY = NO;
    for (NSString *value in values) {
        if (value.doubleValue > 100) {
            hideY = YES;
            break;
        }
    }
    if (hideY == YES) {
        [_chartView setShowYMarkTitles:NO];
    }else{
        BOOL biger = NO;
        for (NSString *value in values) {
            if (value.doubleValue > 10) {
                biger = YES;
                break;
            }
        }
        if (biger == YES) {
            _chartView.yMarkTitles = @[@"0",@"20",@"40",@"60",@"80",@"100"];
        }else{
            _chartView.yMarkTitles = @[@"0",@"2",@"4",@"6",@"8",@"10"];
        }
    }

    [_chartView drawChart];
    [headerView addSubview:_chartView];
    
    
    return headerView;
}
-(void)rightButtonAction:(UIButton *)button
{
    if (self.topView.height == 0) {
        self.topView.hidden = NO;

        [UIView animateWithDuration:0.25 animations:^{
            CGFloat topH = _isXRP == YES?130:60;
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, topH);
            self.tableView.frame = kRectMake(0, self.topView.bottom, kScreenW, kScreenH - self.topView.bottom );
        }];
    }

}
-(UIView *)topView
{
    if (_topView == nil) {
        
        CGFloat topH = _isXRP == YES?130:60;
        
        _topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, topH)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"225686");
        
        //        CGFloat w = 22 + 20 ;
        CGFloat w = kScreenW/5;

        CGFloat h = _isXRP == YES?130/2:60;
        NSInteger totalColumns = 5;
        CGFloat margin = 0;

        NSArray *titles = @[kLocat(@"K_Scan"),kLocat(@"x_xzhangben"),kLocat(@"x_Minebooosplan"),kLocat(@"x_xassetbank"),kLocat(@"OTC_main_hide"),kLocat(@"M_XRPassset")];
        NSArray *icons = @[@"pay_icon_sys",@"pay_icon_zab",@"pay_icon_boss",@"pay_icon_blank",@"poc_icon_hide",@"pay_icon_xrp+"];
      
        for (NSInteger i = 0; i < titles.count; i++) {
            NSInteger row = i / totalColumns;
            NSInteger col = i % totalColumns;
            CGFloat x = col * (w + margin) ;
            CGFloat y = row * (h + margin + 0) ;
            
            YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(x, y, w, h)];
            [_topView addSubview:button];
            
            [self configureButton:button With:titles[i] image:icons[i]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (_isXRP == NO) {
                if (i == 2 ||i == 3|| i ==5) {
                    button.hidden = YES;
                }
            }
        }
        
    }
    return _topView;
}
-(void)configureButton:(YLButton *)button With:(NSString *)title image:(NSString *)image
{
    button.titleLabel.adjustsFontSizeToFitWidth = NO;
    button.titleLabel.font = PFRegularFont(12);
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button setImage:kImageFromStr(image) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.imageRect = kRectMake((kScreenW/5.0-22)/2, 12, 22, 22);
    button.titleRect = kRectMake(0, 38, button.width, 12);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;//设置文字位置，现设为居左，默认的是居中
    button.titleLabel.textAlignment = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
}

@end
