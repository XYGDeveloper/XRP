//
//  TPTradeMallController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPTradeMallController.h"
#import "UITradeMallCell.h"
#import "TPDealDetailTopCell.h"
#import "TPTradeEntrustCell.h"
#import "TPNewsDrawerController.h"
#import "TPQuotationModel.h"
#import "TPDealHistoryController.h"

@interface TPTradeMallController ()<UITableViewDelegate,UITableViewDataSource,NTESVerifyCodeManagerDelegate,UITradeMallCellDelegate,UITextFieldDelegate,XWMoneyTextFieldLimitDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,strong)NSArray *buyRecords;
@property(nonatomic,strong)NSArray *sellRecords;

@property(nonatomic,strong)XNCustomTextfield *priceTF;
@property(nonatomic,strong)XNCustomTextfield *volumeTF;

@property(nonatomic,copy)NSString *cny;
@property(nonatomic,copy)NSString *baseCny;
@property(nonatomic,copy)NSString *nwPrice;
@property(nonatomic,strong)NSString *availableCurrencyVolume;

@property(nonatomic,strong)UILabel *progressLabel;

@property(nonatomic,strong)UISlider *slider;


@property(nonatomic,strong)UILabel *currentPriceLabel;
@property(nonatomic,strong)UILabel *currentCNYLabel;
@property(nonatomic,strong)UILabel *currencyNameLabel;
@property(nonatomic,strong)UILabel *availableCurrencyLabel;
@property(nonatomic,strong)UILabel *aboutMoneyLabel;
@property(nonatomic,strong)UIButton *actionButton;
@property(nonatomic,strong)UILabel *dealLabel;

@property(nonatomic,strong)NSArray *entrustArray;

@property(nonatomic,assign)double scope;


@property(nonatomic,copy)NSString *currencyNum;
@property(nonatomic,copy)NSString *currencyTradeNum;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)BOOL firstLoad;




@end

@implementation TPTradeMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;
    [self setupUI];

    [self loadPanKouDataWith:_currencyID];
    [self loadCurrencyInfo];
    [self loadUserCurrencyInfoVolume];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSelecteNewCurrency:) name:@"kUserDidSelectedNewCurrencyKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllData) name:@"kUserDidCancelOrderKey" object:nil];

    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateAllData];
    }];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadPanKouDataWith:) userInfo:nil repeats:YES];
//    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self initVerifyConfigure];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
}
-(void)setupUI
{
    self.enablePanGesture = NO;
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"UITradeMallCell" bundle:nil] forCellReuseIdentifier:@"UITradeMallCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPTradeEntrustCell" bundle:nil] forCellReuseIdentifier:@"TPTradeEntrustCell"];
    /**  可以防止tableView刷新的时候跳动  */
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [self setNavi];
}
-(void)setNavi
{
    [self addRightTwoBarButtonsWithFirstImage:kImageFromStr(@"hq_icon_listno") firstAction:@selector(showDrawer) secondImage:kImageFromStr(@"hq_icon_hqt") secondAction:@selector(showKline)];
}

-(void)updateAllData
{
    _firstLoad = YES;
    [self loadPanKouDataWith:_currencyID];
    [self loadCurrencyInfo];
    [self loadUserCurrencyInfoVolume];
}



-(void)showKline
{
    [self hideKeyBoard];
    kNavPop;
}
-(void)showDrawer
{
    [self hideKeyBoard];

    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:kCWSCREENWIDTH * 0.86 maskAlpha:0.4 scaleY:1.0 direction:CWDrawerTransitionFromLeft backImage:nil];
    TPNewsDrawerController *vc = [[TPNewsDrawerController alloc] init];
    vc.currencyID = _currencyID;
    YJBaseNavController *baseVC = [[YJBaseNavController alloc] initWithRootViewController:vc];
    [self cw_showDrawerViewController:baseVC animationType:CWDrawerAnimationTypeDefault configuration:conf];
}


#pragma mark - 获取盘口数据

-(void)loadPanKouDataWith:(NSString *)currencyID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency"] = _currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Entrust/tradall_buy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];

        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            self.buyRecords = dic[@"buy_record"];
            self.sellRecords = dic[@"sell_record"];
            if (_firstLoad) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isBuy) {
                        
                        if (self.sellRecords.count) {
                            _priceTF.text = [self.sellRecords lastObject][@"price"];
                        }else{
                            _priceTF.text = _nwPrice;
                        }
                        
                    }else{
                        
                        if (self.buyRecords.count) {
                            _priceTF.text = [self.buyRecords firstObject][@"price"];
                        }else{
                            _priceTF.text = _nwPrice;
                        }
                    }
                    _firstLoad = NO;
                    
                });
            }
            
            
            
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
    }];

}
/**  获取当前交易币信息价格 */
-(void)loadCurrencyInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency"] = _currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Entrust/icon_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];

        if (success) {
            NSDictionary *dic = [responseObj ksObjectForKey:kData][@"currency"];
            _currencyName = dic[@"currency_name"];
            _nwPrice = ConvertToString(dic[@"new_price"]);
            
            
            if (_nwPrice.doubleValue > 0) {
                
                if (_isBuy) {
                    NSString *result = [NSString stringWithFormat:@"%.4f",_currencyTradeNum.doubleValue/_nwPrice.doubleValue];
                    _progressLabel.text = [NSString stringWithFormat:@"%@ %@",result,_currencyName];
                }else{
                    _progressLabel.text = [NSString stringWithFormat:@"%@ %@",_currencyNum,_currencyName];
                }
            }
            
            
            
            _cny = dic[@"cny"];
            _baseCny = dic[@"base_cny"];
            
            _currentCNYLabel.text = [NSString stringWithFormat:@"≈%@ CNY",_cny];
            _currentPriceLabel.text = _nwPrice;
            
            if ([dic[@"new_price_status"]intValue] > 0 ) {
                _currentPriceLabel.textColor = kColorFromStr(@"03C086");
            }else{
                _currentPriceLabel.textColor = kColorFromStr(@"EA6E44");
            }
            
            
//            _currentPriceLabel.text = ConvertToString(_nwPrice);

            
            NSString *priceScr = [NSString stringWithFormat:@"%@",@([_nwPrice floatValue])];
            
            NSArray *arr = [priceScr componentsSeparatedByString:@"."];
            if (arr.count == 1) {
                _scope = 1;
            }else{
                NSInteger length = [arr.lastObject length];
                _scope =  1/pow(10, length);
            }
            
            
            _currencyNameLabel.text = _currencyName;
            
//            if (_isBuy) {
//                _currencyNameLabel.text = _currencyName;
//            }else{
//                _currencyNameLabel.text = @"BCB";
//            }
            
            
            
            self.navigationItem.title = [NSString stringWithFormat:@"%@/%@",_model.currency_mark,_model.trade_currency_mark];;

            
            
            if (_isBuy) {
                [_actionButton setTitle:[NSString stringWithFormat:@"買入 %@",_currencyName] forState:UIControlStateNormal];
                _actionButton.backgroundColor = kColorFromStr(@"#03C086");
                

            }else{
                
                [_actionButton setTitle:[NSString stringWithFormat:@"賣出 %@",_currencyName] forState:UIControlStateNormal];
                _actionButton.backgroundColor = kColorFromStr(@"#EA6E44");
            }
            
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];

            
        }
    }];
}

#pragma mark - 获取委托数据
/**  获取当前币的数量  委托信息*/
-(void)loadUserCurrencyInfoVolume
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency"] = _currencyID;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Entrust/tradall_buy_top"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [_tableView.mj_header endRefreshing];

        if (success) {
           
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            
            _availableCurrencyVolume = dic[@"currency_trade_num"];
            
            
            _currencyTradeNum = dic[@"currency_trade_num"];
            _currencyNum = dic[@"currency_num"];
            
            if (_nwPrice.doubleValue > 0) {
                
                if (_isBuy) {
                    NSString *result = [NSString stringWithFormat:@"%.4f",_currencyTradeNum.doubleValue/_nwPrice.doubleValue];
                    _progressLabel.text = [NSString stringWithFormat:@"%@ %@",result,_currencyName];
                }else{
                    _progressLabel.text = [NSString stringWithFormat:@"%@ %@",_currencyNum,_currencyName];
                }
            }
            
            
            
            if (_isETH) {
                if (_isBuy) {
                    _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@BCB",_currencyTradeNum];
                }else{
                    
                    _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@%@",dic[@"currency_num"],_currencyName];
                }
            }else{
                
                if (_isBuy) {
                    _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@BCB",_currencyTradeNum];
                }else{
                    
                    _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@%@",_currencyNum,_currencyName];
                }
            }
            
            
            self.entrustArray = dic[@"trade"];
            
            [self.tableView reloadData];
            
        }else{
  
        }
    }];
}






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }else{
        if (self.entrustArray.count > 0) {
            return self.entrustArray.count;
        }else{
            return 1;
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static NSString *rid = @"UITradeMallCell";
        UITradeMallCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        [cell.buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sellButton addTarget:self action:@selector(sellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.minusButton addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.actionButton addTarget:self action:@selector(buyOrSellAction) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.slide addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventValueChanged];
        
        
        
        if (_isBuy) {
            [cell.actionButton setTitle:[NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_buy"),_model.currency_mark] forState:UIControlStateNormal];
            cell.actionButton.backgroundColor = kRiseColor;
            
            cell.buyButton.selected = YES;
            cell.sellButton.selected = NO;
        }else{
            [cell.actionButton setTitle:[NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_sell"),_model.currency_mark] forState:UIControlStateNormal];
            cell.actionButton.backgroundColor = kFallColor;
            
            cell.buyButton.selected = NO;
            cell.sellButton.selected = YES;
        }
        
        cell.buyArray = self.buyRecords;
        cell.sellArray = self.sellRecords;
        cell.delegate = self;
        cell.priceTF.delegate = self;
        cell.amountTF.delegate = self;
        _slider = cell.slide;
        _priceTF = cell.priceTF;
        _volumeTF = cell.amountTF;
        _progressLabel = cell.progressEndLabel;
//        _volumeTF.limit.delegate = self;
//        _volumeTF.limit.max = _availableCurrencyVolume;
        
        _currencyNameLabel = cell.currencyNameLabel;
        _currentCNYLabel = cell.currentCNYLabel;
        _currentPriceLabel = cell.currentPriceLabel;
        _aboutMoneyLabel = cell.aboutMoneyLabel;
        _availableCurrencyLabel = cell.availableCurrencyLabel;
        _actionButton = cell.actionButton;
        _dealLabel = cell.dealLabel;
        
        if (_currencyName) {
//            if (_isBuy) {
                _currencyNameLabel.text = _currencyName;
//            }else{
//                _currencyNameLabel.text = @"BCB";
//            }

        }
        if (_cny) {
            _currentCNYLabel.text = [NSString stringWithFormat:@"≈%@ CNY",_cny];
        }
        if (_nwPrice) {
            _currentPriceLabel.text = _nwPrice;
        }

        if (_availableCurrencyVolume) {
            
            if (_isBuy) {
                _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@BCB",_currencyTradeNum];
            }else{
                _availableCurrencyLabel.text = [NSString stringWithFormat:@"可用 %@%@",_currencyNum,_currencyName];
            }
        }
        
        
        return cell;
    }else{
        if (self.entrustArray.count == 0) {
            UITableViewCell *cell = [UITableViewCell new];
            cell.contentView.backgroundColor = kWhiteColor;
            UIImageView *noContentView = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 149)/2.0, 20, 149, 73)];
            [cell.contentView addSubview:noContentView];
            noContentView.image = kImageFromStr(@"lay_img_zwjl");
            
            UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, noContentView.bottom - 10, kScreenW, 14) text:kLocat(@"OTC_order_norecord") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
            [cell.contentView addSubview:label];
            cell.selectionStyle = 0;
            return cell;
        }else{
            
            static NSString *rid = @"TPTradeEntrustCell";
            TPTradeEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }

            cell.dataDic = self.entrustArray[indexPath.row];
            cell.cancelButton.tag = indexPath.row;
            [cell.cancelButton addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }

        
    }
    return  nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 499;
    }else{
        if (self.entrustArray.count > 0) {
            return 110;
        }else{
            return 140;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 56;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 40 + 16)];
    view.backgroundColor = kWhiteColor;
    
    UILabel *label= [[UILabel alloc] initWithFrame:kRectMake(12, 20, 200, 16) text:kLocat(@"k_MyassetDetailViewController_tableview_header_label") font:PFRegularFont(16) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 65, view.height) title:kLocat(@"R_All") titleColor:k666666Color font:PFRegularFont(14) titleAlignment:0];
    
    [view addSubview:button];
    [button alignVertical];
    button.right = kScreenW - 10;
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-4, 0, 0);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    __weak typeof(self)weakSelf = self;

    [button setImage:kImageFromStr(@"mairu_icon_14") forState:UIControlStateNormal];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        TPDealHistoryController *vc = [[TPDealHistoryController alloc] init];
        vc.type = TPDealHistoryControllerTypeEntrust;
        vc.currencyName = weakSelf.currencyName;
        vc.markName = @"BCB";
        kNavPushSafe(vc);
    }];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.5, kScreenW, 0.5)];
//    lineView.backgroundColor = kColorFromStr(@"#111419");
//    [view addSubview:lineView];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - 点击事件

-(void)buyButtonAction:(UIButton *)button
{
    if (button.selected == NO) {
        _isBuy = YES;
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }

    if (_isBuy) {
        
        if (self.sellRecords.count) {
            _priceTF.text = [self.sellRecords lastObject][@"price"];
        }else{
            _priceTF.text = _nwPrice;
        }
        
    }else{
        
        if (self.buyRecords.count) {
            _priceTF.text = [self.buyRecords firstObject][@"price"];
        }else{
            _priceTF.text = _nwPrice;
        }
    }
    
    
}
-(void)sellButtonAction:(UIButton *)button
{
    if (button.selected == NO) {
        _isBuy = NO;
        [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        _progressLabel.text = [NSString stringWithFormat:@"%@ %@",_currencyNum,_currencyName];
    }
    if (_isBuy) {
        
        if (self.sellRecords.count) {
            _priceTF.text = [self.sellRecords lastObject][@"price"];
        }else{
            _priceTF.text = _nwPrice;
        }
        
    }else{
        
        if (self.buyRecords.count) {
            _priceTF.text = [self.buyRecords firstObject][@"price"];
        }else{
            _priceTF.text = _nwPrice;
        }
    }
}



#pragma mark - 加减事件
-(void)addAction
{
    [self hideKeyBoard];
    
//    NSArray *arr = [_priceTF.text componentsSeparatedByString:@"."];
//    if (arr.count == 1) {
//        _priceTF.text = [NSString stringWithFormat:@"%d",_priceTF.text.intValue + 1];
//    }else{
//        NSInteger length = [arr.lastObject length];
//        double result = _priceTF.text.doubleValue + 1/pow(10, length);
//        _priceTF.text = [NSString stringWithFormat:@"%@",@(result)];
//    }
    
//    double result = _priceTF.text.doubleValue + _scope;
//    _priceTF.text = [NSString stringWithFormat:@"%@",@(result)];
    
    kLOG(@"%@",@(_scope));
    
    if ([_priceTF.text isEqualToString:@""]) {
        _priceTF.text = _currentPriceLabel.text;
    }else{
        
        _priceTF.text = [NSString floatOne:_priceTF.text calculationType:CalculationTypeForAdd floatTwo:ConvertToString(@(_scope))];
    }
    
    _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%@CNY",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_baseCny]];
    [self textFieldTextDidChange:nil];
}
-(void)minusAction
{
    [self hideKeyBoard];

    if ([_priceTF.text isEqualToString:@""]) {
        _priceTF.text = _currentPriceLabel.text;
    }else{
    _priceTF.text = [NSString floatOne:_priceTF.text calculationType:CalculationTypeForSubtract floatTwo:ConvertToString(@(_scope))];
    }
    _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%@CNY",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_baseCny]];
    [self textFieldTextDidChange:nil];

}


#pragma mark - 点击价格的回调

-(void)didClickPanKouListWith:(NSDictionary *)dataDic
{
    [self hideKeyBoard];

    _priceTF.text = dataDic[@"price"];
    _priceTF.text = [NSString stringWithFormat:@"%@",@([dataDic[@"price"]floatValue])];

//    _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%fCNY",_priceTF.text.doubleValue * _baseCny.doubleValue];
    
    _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%@CNY",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_baseCny]];
    
    
    
    NSString *priceScr = [NSString stringWithFormat:@"%@",@([dataDic[@"price"]floatValue])];
    NSArray *arr = [priceScr componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        _scope = 1;
    }else{
        NSInteger length = [arr.lastObject length];
        _scope =  1/pow(10, length);
    }
    [self textFieldTextDidChange:nil];
}



#pragma mark -  交易->买卖币
-(void)tradeActionWith:(NSString *)price number:(NSString *)number currencyID:(NSString *)currencyID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    NSString *url;
    if (_isBuy) {
        url = @"/Trade/buy";
        param[@"buyprice"] = price;
        param[@"buynum"] = number;
    }else{
        url = @"/Trade/sell";
        param[@"sellprice"] = price;
        param[@"sellnum"] = number;
    }
    param[@"currency_id"] = _currencyID;
    param[@"validate"] = _verifyStr;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self updateAllData];
            [self showTips:[responseObj ksObjectForKey: kMessage]];
            _priceTF.text = @"";
            _volumeTF.text = @"";
            _dealLabel.text = @"交易额 --";
            _slider.value = 0;
            
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}
#pragma mark - 撤单
-(void)cancelOrderAction:(UIButton *)button
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"order_id"] = self.entrustArray[button.tag][@"orders_id"];

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Depute/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
    
        kHideHud;
        if (success) {
            [self loadPanKouDataWith:_currencyID];
            [self loadCurrencyInfo];
            [self loadUserCurrencyInfoVolume];
            
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }else{
            [self loadPanKouDataWith:_currencyID];
            [self loadCurrencyInfo];
            [self loadUserCurrencyInfoVolume];
            
            [self showTips:[responseObj ksObjectForKey: kMessage]];
        }
        
    }];
}

#pragma mark - 滑动事件
-(void)slideAction:(UISlider *)slider
{
    if (_isBuy) {
        double price ;
        if (_priceTF.text.length == 0) {
            price = _nwPrice.doubleValue;
        }else{
            price = _priceTF.text.doubleValue;
        }
        
        if (price > 0) {
            _volumeTF.text = [NSString stringWithFormat:@"%.4f",_currencyTradeNum.doubleValue / price * slider.value];
        }else{
            _volumeTF.text = @"";
        }
        
    }else{
        _volumeTF.text = [NSString floatOne:_currencyNum calculationType:CalculationTypeForMultiply floatTwo:ConvertToString(@(slider.value))];
    }
    double dealVolume = _priceTF.text.doubleValue * _volumeTF.text.doubleValue;

    if (dealVolume > 0) {
        _dealLabel.text = [NSString stringWithFormat:@"交易额 %@BCB",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_volumeTF.text]];
    }else{
        _dealLabel.text = [NSString stringWithFormat:@"交易额 --"];
    }
    
    
    if (_currencyTradeNum.doubleValue <= 0) {
        _progressLabel.text = [NSString stringWithFormat:@"0 %@",_currencyName];
    }else{
        NSString *price;
        if (_priceTF.text.doubleValue > 0) {
            price = _priceTF.text;
        }else{
            if (_currentPriceLabel.text.doubleValue > 0) {
                price = _currentPriceLabel.text;
            }else{
                price = @"0";
            }
        }
        
        if (price.doubleValue > 0) {
            
            if (_isBuy) {
                NSString *result = [NSString stringWithFormat:@"%.4f",_currencyTradeNum.doubleValue/price.doubleValue];
                _progressLabel.text = [NSString stringWithFormat:@"%@ %@",result,_currencyName];
                
            }else{
                _progressLabel.text = [NSString stringWithFormat:@"%@ %@",_currencyNum,_currencyName];
            }
        }else{
            if (_isBuy) {
//                NSString *result = [NSString stringWithFormat:@"%.4f",_currencyTradeNum.doubleValue/price.doubleValue];
                _progressLabel.text = [NSString stringWithFormat:@"-- %@",_currencyName];
                
            }else{
                _progressLabel.text = [NSString stringWithFormat:@"%@ %@",_currencyNum,_currencyName];
            }
        }
        
    }
    
}

#pragma mark - 输入框通知

-(void)textFieldTextDidChange:(NSNotification *)noti
{
    if (noti.object == _priceTF) {
//        _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%fCNY",_priceTF.text.doubleValue * _baseCny.doubleValue];
        
        _aboutMoneyLabel.text = [NSString stringWithFormat:@"≈%@CNY",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_baseCny]];
        
    }
    
    double dealVolume = _priceTF.text.doubleValue * _volumeTF.text.doubleValue;
    if (dealVolume > 0) {
        _dealLabel.text = [NSString stringWithFormat:@"交易额 %@BCB",[NSString floatOne:_priceTF.text calculationType:CalculationTypeForMultiply floatTwo:_volumeTF.text]];
    }else{
        _dealLabel.text = [NSString stringWithFormat:@"交易额 --"];
    }
    if (noti.object == _volumeTF) {

        if (_isBuy) {
            
            if (_currencyTradeNum.doubleValue <= 0) {
                [self showTips:@"可用余额为0"];
                _volumeTF.text = @"0";
                return;
            }
            
            _slider.value = _volumeTF.text.doubleValue /(_currencyTradeNum.doubleValue/_nwPrice.doubleValue);

        }else{
            if (_currencyNum.doubleValue <= 0) {
                [self showTips:@"可用余额为0"];
                _volumeTF.text = @"0";
                return;
            }
            _slider.value = _volumeTF.text.doubleValue / _currencyNum.doubleValue;

        }
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField == _priceTF) {
        int i = 0;
        int a = 0;
        while (i < _priceTF.text.length) {
            NSString * string1 = [_priceTF.text substringWithRange:NSMakeRange(i, 1)];
            if ([string1 isEqualToString:@"."]) {
                a++;
            }
            i++;
        }
        if (a > 1) {
            _priceTF.text = @"";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if([textField.text length] == 0){
                if(single == '.') {
//                    showMsg(@"数据格式有误");
                    kLOG(@"数据格式有误");
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
//                    showMsg(@"数据格式有误");
                    kLOG(@"数据格式有误");

                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
//                    NSRange ran = [textField.text rangeOfString:@"."];
//                    if (range.location - ran.location <= 2) {
                        return YES;
//                    }else{
////                        showMsg(@"最多两位小数");
//                        kLOG(@"最多两位小数");
//
//                        return NO;
//                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            showMsg(@"数据格式有误");
            kLOG(@"数据格式有误");

            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}






-(void)userDidSelecteNewCurrency:(NSNotification *)noti
{
//    TPQuotationModel *model = noti.object;
    TPTradeMallController *vc = noti.object;
    _model = vc.model;
    _currencyName = vc.currencyName;
    _currencyID = vc.currencyID;
    _isBuy = YES;
    
    _slider.value = 0;
    _progressLabel.text = @"";
    _priceTF.text = @"";
    _volumeTF.text = @"";
    
    [self loadPanKouDataWith:_currencyID];
    [self loadCurrencyInfo];
    [self loadUserCurrencyInfoVolume];
}
#pragma mark - 图形
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
-(void)buyOrSellAction
{
    [self hideKeyBoard];
///////限制条件
    if (_priceTF.text.length == 0) {
        [self showTips:@"請輸入價格"];
        return;
    }
    if (_volumeTF.text.length == 0) {
        [self showTips:@"請輸入數量"];
        return;
    }
    
    
    [self showVerifyInfo];
}


-(void)showVerifyInfo
{

    [self.manager openVerifyCodeView:nil];
}
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        
        [self tradeActionWith:_priceTF.text number:_volumeTF.text currencyID:_currencyID];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}

-(NTESVerifyCodeManager *)manager
{
    if (_manager == nil) {
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        _manager.alpha = 0;
        _manager.frame = CGRectNull;
        _manager.lang = [Utilities getLangguageForNTESVerifyCode];
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    return _manager;
}




@end
