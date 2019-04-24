
//
//  TPDealHistoryController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPDealHistoryController.h"
#import "TPDealDetailTopCell.h"
#import "TPDealDetailController.h"


@interface TPDealHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)UIView *blankView;

@property(nonatomic,strong)UIView *searchView;

@property(nonatomic,strong)UIView *searchBottomView;

@property(nonatomic,assign)BOOL showMarket;
@property(nonatomic,strong)UITextField *marketTF;
@property(nonatomic,strong)UITextField *currencyTF;

@property(nonatomic,strong)UIButton *buyButton;
@property(nonatomic,strong)UIButton *sellButton;

@property(nonatomic,strong)UIButton *chooseButton;


@end

@implementation TPDealHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];
    _page = 1;
    [self setupTopView];
    [self setupUI];

    if (_type == TPDealHistoryControllerTypeHistory) {
        
        __weak typeof(self)weakSelf = self;
        _page = 1;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithCurrency:_currencyName market:_markName type:nil page:_page];
        }];
        
    }
    
    
    
    [self loadDataWithCurrency:_currencyName market:_markName type:nil page:_page];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)setupTopView
{
    NSString *title;
    if (_type == TPDealHistoryControllerTypeEntrust) {
        title = kLocat(@"k_MyassetDetailViewController_tableview_header_label");
        self.navigationItem.title = [NSString stringWithFormat:@"%@/%@",_currencyName,_markName];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        view1.backgroundColor = [UIColor clearColor];
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 0, 44, 44);
        [firstButton setImage:kImageFromStr(@"jilu_icon_lisi") forState:UIControlStateNormal];
        __weak typeof(self)weakSelf = self;

        [firstButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            TPDealHistoryController *vc = [[TPDealHistoryController alloc] init];
            vc.type = TPDealHistoryControllerTypeHistory;
            kNavPushSafe(vc);
        }];
        
        [firstButton setTitleColor:kColorFromStr(@"#CDD2E3") forState:UIControlStateNormal];
        [firstButton setTitle:kLocat(@"H_Record") forState:UIControlStateNormal];
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth / 375.0)];
        firstButton.titleLabel.font = PFRegularFont(16);
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 40 + 16)];
        view.backgroundColor = kTableColor;
        UILabel *label= [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:title font:PFRegularFont(16) textColor:k222222Color textAlignment:0 adjustsFont:YES];
        [view addSubview:label];

        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 65, view.height) title:kLocat(@"k_MyassetDetailViewController_tableview_header_selectBtn") titleColor:kColorFromStr(@"#979CAD") font:PFRegularFont(14) titleAlignment:0];
        [button setImage:kImageFromStr(@"jilu_icon_saixuan0") forState:UIControlStateNormal];
        [button setImage:kImageFromStr(@"jilu_icon_saixuan") forState:UIControlStateSelected];
        [button setTitleColor:kColorFromStr(@"#707EB6") forState:UIControlStateNormal];
        [button setTitleColor:kColorFromStr(@"#11B1ED") forState:UIControlStateSelected];
        [view addSubview:button];
        [button alignVertical];
        button.right = kScreenW - 10;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,-4, 0, 0);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        _chooseButton = button;
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            sender.selected = !sender.isSelected;
            
            weakSelf.searchView.hidden = !sender.isSelected;
            
        }];
        //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.5, kScreenW, 0.5)];
        //    lineView.backgroundColor = kColorFromStr(@"#111419");
        //    [view addSubview:lineView];
        
        [self.view addSubview:view];
    }else{
        title = kLocat(@"H_Recordlist");
        self.navigationItem.title = kLocat(@"H_Recordlist");
    }
}

-(void)setupUI
{
    CGFloat y;
    if (_type == TPDealHistoryControllerTypeHistory) {
        y = kNavigationBarHeight;
    }else{
        y = kNavigationBarHeight + 56;
    }
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,y, kScreenW, kScreenH - y) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPDealDetailTopCell" bundle:nil] forCellReuseIdentifier:@"TPDealDetailTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UIDealDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"UIDealDetailBottomCell"];
    /**  可以防止tableView刷新的时候跳动  */
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.estimatedRowHeight = 180;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)loadDataWithCurrency:(NSString *)currency market:(NSString *)market type:(NSString *)type page:(NSInteger)page
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *url;
    if (_type == TPDealHistoryControllerTypeEntrust) {
        url = @"/Entrust/my_entrust";
        param[@"currency_name"] = currency;
        param[@"market"] = market;
            param[@"type"] = type;
    }else{
        url = @"/Entrust/my_entrust_history";
    }
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);

    
    __weak typeof(self)weakSelf = self;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];

        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            if (datas.count == 0 && weakSelf.dataArray.count == 0) {
                //无数据
                self.blankView.hidden = NO;

                [weakSelf.tableView reloadData];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                [weakSelf.dataArray addObject:dic];
            }
            [weakSelf.tableView reloadData];
            self.blankView.hidden = YES;

            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        _page ++;
                        [weakSelf loadDataWithCurrency:currency market:market type:type page:_page];
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
            
            if (weakSelf.dataArray.count == 0) {
                //无数据
                
                [weakSelf.tableView reloadData];
                self.blankView.hidden = NO;
            }else{
                NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
                if (code == 10100) {//重新登录
                    [kUserInfo clearUserInfo];
                    YJBaseNavController *vc = [[YJBaseNavController alloc] initWithRootViewController:[YJLoginViewController new]];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }            
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
    static NSString *rid = @"TPDealDetailTopCell";
    TPDealDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    if (_type == TPDealHistoryControllerTypeEntrust) {
        cell.type = 2;
        cell.arrowLabel.tag = indexPath.section;
        [cell.arrowLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelOrderAction:)]];
        
    }else{
        cell.type = 0;
    }
    
    
    
    cell.dataDic = self.dataArray[indexPath.section];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == TPDealHistoryControllerTypeHistory) {
        
        if ([self.dataArray[indexPath.section][@"trade_num"]doubleValue] > 0 ) {
            TPDealDetailController *vc = [TPDealDetailController new];
            vc.orderID = self.dataArray[indexPath.section][@"orders_id"];
            kNavPush(vc);
        }
        
    }
}

-(void)cancelOrderAction:(UITapGestureRecognizer *)tap
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"order_id"] = self.dataArray[tap.view.tag][@"orders_id"];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Depute/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        kHideHud;
        if (success) {
            [self.dataArray removeObjectAtIndex:tap.view.tag];
            [self.tableView reloadData];
            
            if (self.dataArray.count == 0) {
                self.blankView.hidden = NO;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidCancelOrderKey" object:nil];
            
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }else{
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)blankView
{
    if (_blankView == nil) {
        _blankView = [[UIView alloc] initWithFrame:_tableView.bounds];
        _blankView.backgroundColor = kTableColor;
        [_tableView addSubview:_blankView];
        UIImageView *noContentView = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 149)/2.0, 166 *kScreenHeightRatio, 149, 73)];
        [_blankView addSubview:noContentView];
        noContentView.image = kImageFromStr(@"lay_img_zwjl");
        
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, noContentView.bottom - 10, kScreenW, 14) text:kLocat(@"OTC_order_norecord") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
        [_blankView addSubview:label];
    }
    return _blankView;
}

-(UIView *)searchView
{
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:_tableView.frame];
        [self.view addSubview:_searchView];
        _searchView.backgroundColor = kTableColor;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
        lineView.backgroundColor = kColorFromStr(@"cccccc");
        [_searchView addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 30, 80, 14) text:kLocat(@"H_tradedui") font:PFRegularFont(14) textColor:k666666Color textAlignment:0 adjustsFont:YES];
        [_searchView addSubview:titleLabel];
        
        CGFloat w = (kScreenW - 24 - 29)/2.0;
        UIView *currencyView = [[UIView alloc] initWithFrame:kRectMake(12, 58, w, 44)];
//        currencyView.backgroundColor = kColorFromStr(@"#222631");
        kViewBorderRadius(currencyView, 0, 0.5, k999999Color);
        [_searchView addSubview:currencyView];
        
        
        UITextField *currencyTF = [[UITextField alloc] initWithFrame:kRectMake(6, 0, w - 12, currencyView.height)];
        [currencyView addSubview:currencyTF];
        currencyTF.font = PFRegularFont(14);
        currencyTF.textColor = k222222Color;
        
        currencyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"OTC_order_currency") attributes:@{NSForegroundColorAttributeName: k999999Color}];
        
        UILabel *midLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 20, 20)];
        [_searchView addSubview:midLabel];
        [midLabel alignHorizontal];
        midLabel.centerY = currencyView.centerY;
        midLabel.text = @"/";
        midLabel.textColor = k999999Color;
        midLabel.font = PFRegularFont(14);
        midLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *marketView = [[UIView alloc] initWithFrame:kRectMake(12, 58, w, 44)];
//        marketView.backgroundColor = kColorFromStr(@"#222631");
        kViewBorderRadius(marketView, 0, 0.5,k999999Color);
        [_searchView addSubview:marketView];
        marketView.right = kScreenW - 12;
        
        UITextField *marketTF = [[UITextField alloc] initWithFrame:kRectMake(6, 0, w - 12, currencyView.height)];
        [marketView addSubview:marketTF];
        marketTF.font = PFRegularFont(14);
        marketTF.textColor = k222222Color;
        marketTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kLocat(@"H_choosecurrency") attributes:@{NSForegroundColorAttributeName: k999999Color}];
        
        marketTF.userInteractionEnabled = NO;
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:kRectMake(0, 0, 14, 9)];
        [marketView addSubview:arrow];
        arrow.image = kImageFromStr(@"hq_icon_sanj");
        [arrow alignVertical];
        arrow.right = marketView.width - 5;
        
        CGFloat moveY = 55;
        __weak typeof(self)weakSelf = self;

        _showMarket = NO;
        [marketView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
           
            weakSelf.showMarket = !weakSelf.showMarket;
            
            if (weakSelf.showMarket) {
                [UIView animateWithDuration:0.25 animations:^{
                    _searchBottomView.y += moveY;
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.searchBottomView.y -= moveY;
                }];
            }
        }]];
        
        
        UIButton *bcbButton = [[UIButton alloc] initWithFrame:kRectMake(12, currencyView.bottom + 20, 100, 33) title:@"BCB" titleColor:kColorFromStr(@"#88A1BD") font:PFRegularFont(14) titleAlignment:0];
        bcbButton.backgroundColor = kColorFromStr(@"#36414E");

        [_searchView addSubview:bcbButton];
        [bcbButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            weakSelf.marketTF.text = @"BCB";
            weakSelf.showMarket = !weakSelf.showMarket;
            
            if (weakSelf.showMarket) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.searchBottomView.y += moveY;
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.searchBottomView.y -= moveY;
                }];
            }
            
        }];
        
        


        UIButton *ethButton = [[UIButton alloc] initWithFrame:kRectMake(bcbButton.right + 20, currencyView.bottom + 20, 100, 33) title:@"ETH" titleColor:kColorFromStr(@"#88A1BD") font:PFRegularFont(14) titleAlignment:0];
        ethButton.backgroundColor = kColorFromStr(@"#36414E");
        [_searchView addSubview:ethButton];
        
        [ethButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            weakSelf.marketTF.text = @"ETH";
            weakSelf.showMarket = !weakSelf.showMarket;
            
            if (weakSelf.showMarket) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.searchBottomView.y += moveY;
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.searchBottomView.y -= moveY;
                }];
            }
        }];

        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, 58 + 44, kScreenW, 132 + 50)];
        [_searchView addSubview:bottomView];
//        bottomView.backgroundColor = kColorFromStr(@"#222631");
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:kRectMake(12, 30, 100, 14) text:kLocat(@"H_orderstatus") font:PFRegularFont(14) textColor:k666666Color textAlignment:0 adjustsFont:0];
        [bottomView addSubview:statusLabel];
        
        UIButton *buyButton = [[UIButton alloc] initWithFrame:kRectMake(12, 59, 120, 33) title:kLocat(@"OTC_buy") titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:0];
        [bottomView addSubview:buyButton];
        [buyButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#36414E")] forState:UIControlStateNormal];
        [buyButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#03C086")] forState:UIControlStateSelected];

        buyButton.tag = 0;

        UIButton *sellButton = [[UIButton alloc] initWithFrame:kRectMake(buyButton.right + 10, 59, 120, 33) title:@"賣出" titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:0];
        [bottomView addSubview:sellButton];
        [sellButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#36414E")] forState:UIControlStateNormal];
        [sellButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#EA6E44")] forState:UIControlStateSelected];
        sellButton.tag = 1;
        
        [buyButton addTarget:self action:@selector(buyOrSellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [sellButton addTarget:self action:@selector(buyOrSellButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        
        UIButton *resetButton = [[UIButton alloc] initWithFrame:kRectMake(0, 132, kScreenW/2.0, 50) title:kLocat(@"H_Reset") titleColor:kColorFromStr(@"#9CC1EE") font:PFRegularFont(14) titleAlignment:0];
        [bottomView addSubview:resetButton];
        resetButton.backgroundColor = kColorFromStr(@"#8A94A8");
        [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW/2.0, 132, kScreenW/2.0, 50) title:kLocat(@"Confirm") titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:0];
        [bottomView addSubview:confirmButton];
        confirmButton.backgroundColor = kColorFromStr(@"#6189C5");
        [confirmButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];

        
        _searchBottomView = bottomView;
        _marketTF = marketTF;
        _searchView.userInteractionEnabled = YES;
        _buyButton = buyButton;
        _sellButton = sellButton;
        _currencyTF = currencyTF;
        
        [_searchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            _searchView.hidden = YES;
            _chooseButton.selected = NO;

        }]];
        
    }
    return _searchView;
}


-(void)buyOrSellButtonAction:(UIButton *)button
{
    if (button.tag == 0) {
        _buyButton.selected = !button.selected;
        _sellButton.selected = NO;
    }else{
        _sellButton.selected = !button.selected;
        _buyButton.selected = NO;
    }
}
-(void)resetAction
{
    _currencyTF.text = @"";
    _marketTF.text = @"";
    _buyButton.selected = NO;
    _sellButton.selected = NO;
}

-(void)searchAction
{
    [self hideKeyBoard];
    
    if (_currencyTF.text.length == 0) {
        [self showTips:@"請輸入幣種"];
        return;
    }
    if (_marketTF.text.length == 0) {
        [self showTips:@"請選擇計價單位"];
        return;
    }

    _chooseButton.selected = NO;
    _searchView.hidden = YES;
    
    _page = 1;
    NSString *type;
    
    if (_sellButton.selected) {
        type = @"sell";
    }
    if (_buyButton.selected) {
        type = @"buy";
    }
    [self loadDataWithCurrency:_currencyTF.text market:_marketTF.text type:type page:_page];
    
}


@end
