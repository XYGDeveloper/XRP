//
//  TPOTCBuyListController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCBuyListController.h"
#import "TPOTCBuyListCell.h"
#import "TPOTCBuyOrderDetailController.h"
#import "TPOTCBuyOrderDetailView.h"
#import "TPOTCProfileViewController.h"
#import "XPOTCBuyListCellCell.h"


@interface TPOTCBuyListController ()<UITableViewDelegate,UITableViewDataSource,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPOTCOrderModel *> *dataArray;


@property(nonatomic,strong)TPOTCBuyOrderDetailView *detailView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,strong)TPOTCOrderModel *selectedModel;



@end

@implementation TPOTCBuyListController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];

    [self setupUI];
    //刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"kUserDidPostAdKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movePageView:) name:@"kUserDidClickTPBaseOTCViewControllerRightButtonKey" object:nil];

}
-(void)movePageView:(NSNotification *)noti
{
    if ([noti.object intValue] == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            _tableView.frame = kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - kTabbarItemHeight - 44);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _tableView.frame = kRectMake(0,0, kScreenW, kScreenH-kNavigationBarHeight - kTabbarItemHeight - 44-70);
        }];
   
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self detailView];
    [self initVerifyConfigure];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_detailView) {
        [_detailView removeFromSuperview];
        _detailView = nil;
    }
}


-(void)setupUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavigationBarHeight-kTabbarItemHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCBuyListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCBuyListCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPOTCBuyListCellCell" bundle:nil] forCellReuseIdentifier:@"XPOTCBuyListCellCell"];


    
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        _isRefresh = YES;
        [weakSelf loadDataWith:_page];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _model.currencyID;
    param[@"page"] = @(page);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"OrdersOtc/sell_order"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];

            if (datas.count == 0 && _dataArray.count == 0) {
//                [self showTips:kLocat(@"OTC_buylist_noorder")];
                
                [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"lay_img_zwjl"] explain:kLocat(@"OTC_buylist_noorder") operationText:kLocat(@"OTC_empty_tips") operationBlock:^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                    [[EmptyManager sharedManager] removeEmptyFromView:weakSelf.view];
                }];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                TPOTCOrderModel *model = [TPOTCOrderModel modelWithJSON:dic];
                model.currencyName = _model.currencyName;
                [self.dataArray addObject:model];
            }
            
            [weakSelf.tableView reloadData];

            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWith:_page];
                    }
                    _isRefresh = YES;
                }];
                [footer setTitle:kLocat(@"R_Loading") forState:MJRefreshStateRefreshing];
                _tableView.mj_footer = footer;
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                //                _tableView.mj_footer = nil;
            }

            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
        
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPOTCBuyListCellCell";
    XPOTCBuyListCellCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.dataArray[indexPath.section];
    cell.topView.tag = indexPath.section;
    [cell.topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserInfo:)]];
    return cell;
//    static NSString *rid = @"TPOTCBuyListCell";
//    TPOTCBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
//    }
//    cell.model = self.dataArray[indexPath.section];
//    cell.topView.tag = indexPath.section;
//    [cell.topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserInfo:)]];
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    
    if (kUserInfo.verify_state.intValue != 1) {
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
                    _selectedModel = self.dataArray[indexPath.section];
                    [self checkCurrentOrderStatusWith:self.dataArray[indexPath.section]];
                }
            }
        }];
    }else{
        _selectedModel = self.dataArray[indexPath.section];
        [self checkCurrentOrderStatusWith:self.dataArray[indexPath.section]];
    }
    
}
#pragma mark - 点击事件

-(void)gotoBuyOrderDetailVC
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"num"] = self.detailView.bottomTF.text;
//    param[@"num"] = [NSString floatOne:self.detailView.bottomTF.text calculationType:CalculationTypeForAdd floatTwo:@"0.000001"];
    param[@"orders_id"] = self.detailView.model.orders_id;
    param[@"validate"] = _verifyStr;
    
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/buy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self.detailView hideAction:nil];
            TPOTCBuyOrderDetailController *vc = [TPOTCBuyOrderDetailController new];
            vc.trade_id = [responseObj ksObjectForKey:kData][@"trade_id"];
            kNavPush(vc);
        }else{
            
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            if (code == 10100) {//token失效
//                [kUserInfo clearUserInfo];
//                UIViewController *vc = [HBLoginTableViewController fromStoryboard];
//                [self presentViewController:vc animated:YES completion:nil];
                
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }
    }];
}

/**  检查订单可交易量  */
-(void)checkCurrentOrderStatusWith:(TPOTCOrderModel *)model
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = model.orders_id;

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/updateavail"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideBaseOTCTopViewKey" object:nil];
            
            
            model.avail = ConvertToString([responseObj ksObjectForKey:kData][@"avail"]);
            
            self.detailView.model = model;
            
            if (!self.detailView.superview) {
                [kKeyWindow addSubview:self.detailView];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.detailView.y = kStatusBarHeight;
            }];
        }else{
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }
    }];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 169 + 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 2.5;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(TPOTCBuyOrderDetailView *)detailView
{
    if (_detailView == nil) {
        
        _detailView =  [[[NSBundle mainBundle] loadNibNamed:@"TPOTCBuyOrderDetailView" owner:nil options:nil] lastObject];
        _detailView.frame = kRectMake(0, kScreenH, kScreenW, kScreenH - kStatusBarHeight);

        [_detailView.dealButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _detailView;
}

-(void)backAction
{
    [super backAction];
    if (_detailView) {
        [_detailView removeFromSuperview];
    }
}
#pragma mark - 显示用户信息
-(void)showUserInfo:(UITapGestureRecognizer *)tap
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHideBaseOTCTopViewKey" object:nil];

    if ([Utilities isExpired]) {
        [self gotoLoginVC];
    }else{
        TPOTCProfileViewController *vc = [TPOTCProfileViewController new];
        vc.memberID = self.dataArray[tap.view.tag].member_id;
        vc.model = self.dataArray[tap.view.tag];
        kNavPush(vc);
    }
}




#pragma mark - 图形验证码
-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    // 设置透明度
    self.manager.alpha = 0;
    // 设置frame
    self.manager.frame = CGRectNull;
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}
-(void)showVerifyInfo
{
    if (self.manager == nil) {
        [self initVerifyConfigure];
    }
    
    
    [self hideKeyBoard];
 
    [self.detailView.topTF resignFirstResponder];
    [self.detailView.bottomTF resignFirstResponder];
    if (self.detailView.topTF.text.length == 0) {
        [kKeyWindow showWarning:kLocat(@"OTC_buylist_inputmoney")];
        return;
    }else if (self.detailView.bottomTF.text.length == 0){
        [kKeyWindow showWarning:kLocat(@"OTC_buylist_inputvolume")];
        return;
    }
    if (self.detailView.bottomTF.text.doubleValue <= 0) {
        [kKeyWindow showWarning:kLocat(@"OTC_buylist_inputvolume")];
        return;
    }
    
//    if (self.detailView.bottomTF.text.doubleValue > self.detailView.model.avail.doubleValue) {
//        [kKeyWindow showWarning:kLocat(@"OTC_buylist_moneytoobig")];
//        return;
//    }
    
//    if (self.detailView.bottomTF.text.doubleValue < 0.0001) {
//        [kKeyWindow showWarning:kLocat(@"OTC_buylist_volumesmall")];
//        return;
//    }
    
    
    
    [self.manager openVerifyCodeView:nil];
}
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self gotoBuyOrderDetailVC];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}

/**  发布了新广告之后刷新页面  */
-(void)refreshData:(NSNotification *)noti
{
    if ([noti.object isEqualToString:_model.currencyID]) {
        _page = 1;
        [self loadDataWith:_page];
    }
}

-(NTESVerifyCodeManager *)manager
{
    if (_manager == nil) {
        // sdk调用
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        
        // 设置透明度
        _manager.alpha = 0;
        _manager.lang = [Utilities getLangguageForNTESVerifyCode];

        // 设置frame
        _manager.frame = CGRectNull;
        
        // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    return _manager;
}


@end
