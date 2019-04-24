


//
//  TPOTCADDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCADDetailController.h"
#import "TPOTCADListMidCell.h"
#import "TPOTCADDoneTopCell.h"
#import "TPOTCADCurrentTopCell.h"
#import "TPOTCADDetailListCell.h"
#import "TPOTCSingleOrderModel.h"
#import "TPOTCOrderDetailController.h"
#import "TPOTCTradeListModel.h"


@interface TPOTCADDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

//@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UIView *leftView;
@property(nonatomic,strong)UIView *rightView;

/**  新消息  */
@property(nonatomic,strong)NSMutableArray<TPOTCSingleOrderModel *> *nwOrderArray;
/**  已完成  */
@property(nonatomic,strong)NSMutableArray<TPOTCSingleOrderModel *> *doneOrderArray;
@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,assign)NSInteger nwPage;
@property(nonatomic,assign)NSInteger donePage;



@end

@implementation TPOTCADDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _dataArray = [NSMutableArray array];
    _isNew = YES;
    _nwPage = 1;
    _donePage = 1;
    _nwOrderArray = [NSMutableArray array];
    _doneOrderArray = [NSMutableArray array];
    [self setupUI];


    [self loadDataWith:_nwPage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"kUserDidPermitTheOrderKey" object:nil];

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
}

-(void)setupUI
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.title = kLocat(@"OTC_ad_addetail");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStylePlain];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADDoneTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADDoneTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADListMidCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADListMidCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADCurrentTopCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADCurrentTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCADDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCADDetailListCell"];

    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    __weak typeof(self)weakSelf = self;

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefresh = YES;
        if (_isNew) {
            _nwPage = 1;
            [weakSelf loadDataWith:_nwPage];
        }else{
            _donePage = 1;
            [weakSelf loadDataWith:_donePage];
        }
    }];
    
}
-(void)loadDataWith:(NSInteger)page
{
    __weak typeof(self)weakSelf = self;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);
    param[@"orders_id"] = _model.orders_id;
    
    if (_isNew) {
        param[@"complete"] = @"0";
    }else{
        param[@"complete"] = @"1";
    }
    
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/orders_trade_log"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (_isNew) {
                if (datas.count == 0 && _nwOrderArray.count == 0) {
                    [self showTips:kLocat(@"OTC_order_norecord")];
                    [weakSelf.tableView reloadData];
                    return ;
                }
                if (page == 1) {
                    [_nwOrderArray removeAllObjects];
                }
                for (NSDictionary *dic in datas) {
                    TPOTCSingleOrderModel *model = [TPOTCSingleOrderModel modelWithJSON:dic];
                    [self.nwOrderArray addObject:model];
                }
            }else{
                if (datas.count == 0 && _doneOrderArray.count == 0) {
                    [self showTips:kLocat(@"OTC_order_norecord")];
                    [weakSelf.tableView reloadData];
                    return ;
                }
                if (page == 1) {
                    [_doneOrderArray removeAllObjects];
                }
                for (NSDictionary *dic in datas) {
                    TPOTCSingleOrderModel *model = [TPOTCSingleOrderModel modelWithJSON:dic];
                    [self.doneOrderArray addObject:model];
                }
            }
            
            [weakSelf.tableView reloadData];
            
            _isRefresh = NO;
            if (datas.count >= 10) {
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    if (!_isRefresh) {
                        
                        if (_isNew) {
                            _nwPage ++;
                            [weakSelf loadDataWith:_nwPage];
                        }else{
                            _donePage++;
                            [weakSelf loadDataWith:_donePage];
                        }
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        if (_isNew) {
            
            return MAX(1, self.nwOrderArray.count);
            
//            return self.nwOrderArray.count;
        }else{
            return MAX(1, self.doneOrderArray.count);

//            return self.doneOrderArray.count;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (_isHistory) {
            if (indexPath.row == 0) {
                
                static NSString *rid = @"TPOTCADDoneTopCell";
                TPOTCADDoneTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                cell.model = _model;
                
                return cell;
            }else{
                static NSString *rid = @"TPOTCADListMidCell";
                TPOTCADListMidCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                cell.model = _model;
                cell.cancelButton.hidden = YES;
                return cell;
            }
        }else{
            if (indexPath.row == 0) {
                static NSString *rid = @"TPOTCADCurrentTopCell";
                TPOTCADCurrentTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                cell.model = _model;
                return cell;
                
            }else{
                static NSString *rid = @"TPOTCADListMidCell";
                TPOTCADListMidCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                [cell.cancelButton addTarget:self action:@selector(showTipsView:) forControlEvents:UIControlEventTouchUpInside];
                cell.model = _model;
                return cell;
            }
        }
    }else{

        static NSString *rid = @"TPOTCADDetailListCell";
        TPOTCADDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }

        UITableViewCell *emptyCell = [UITableViewCell new];
        emptyCell.contentView.backgroundColor = kTableColor;
        UIImageView *noContentView = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 149)/2.0, 20, 149, 73)];
        [emptyCell.contentView addSubview:noContentView];
        noContentView.image = kImageFromStr(@"lay_img_zwjl");
        
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, noContentView.bottom - 10, kScreenW, 14) text:kLocat(@"OTC_order_norecord") font:PFRegularFont(14) textColor:k666666Color textAlignment:1 adjustsFont:YES];
        [emptyCell.contentView addSubview:label];
        emptyCell.selectionStyle = 0;
        
        
        if (_isNew) {//新消息
            if (self.nwOrderArray.count == 0) {
                return emptyCell;
            }
            cell.model = self.nwOrderArray[indexPath.row];
            
            
        }else{//已完成
            if (self.doneOrderArray.count == 0) {
                return emptyCell;
            }
            cell.model = self.doneOrderArray[indexPath.row];
        }
        cell.msgButton.tag = indexPath.row;
        [cell.msgButton addTarget:self action:@selector(showMsgVC:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
    }
}

-(void)showMsgVC:(UIButton *)button
{
    NSString *tradeId;
    if (_isNew) {
        tradeId = self.nwOrderArray[button.tag].trade_id;
    }else{
        tradeId = self.doneOrderArray[button.tag].trade_id;
    }

    BaseWebViewController *vc = [[BaseWebViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,@"/Api/Jim/chat"];
    vc.showNaviBar = YES;
    vc.webViewFrame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH -kNavigationBarHeight);
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//简体
        lang = ThAI;
    }
    vc.cookieValue = [NSString stringWithFormat:@"document.cookie = 'odrtoken1=%@';document.cookie = 'odrplatform=ios';document.cookie = 'odruuid=%@';document.cookie = 'odrthink_language=%@';document.cookie = 'odrtrade_id=%@';document.cookie = 'odruserId=%@'",kUserInfo.token,[Utilities randomUUID],lang,tradeId,@(kUserInfo.uid)];
    vc.titleString = kLocat(@"OTC_buyDetail_chat");

    kNavPush(vc);
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_isHistory) {
            if (indexPath.row == 0) {
                return 58;
            }else{
                return 145;
            }
        }else{
            if (indexPath.row == 0) {
                return 44;
            }else{
                return 165;
            }
        }
    }else{
        
        if (_isNew) {//新消息
            if (self.nwOrderArray.count == 0) {
                return 140;
            }
            return 130 + 5;
        }else{//已完成
            if (self.doneOrderArray.count == 0) {
                return 140;
            }
            return 130 + 5;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section) {
        return 0.01;
    }else{
        return 5;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 40;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 40)];
        view.backgroundColor = kWhiteColor;
        
        UIView *lineView111 = [[UIView alloc] initWithFrame:CGRectMake(0, 38, kScreenW, 3)];
        lineView111.backgroundColor = kTableColor;
        [view addSubview:lineView111];
        
        
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:kRectMake(95 *kScreenWidthRatio, 0, 48, view.height) text:kLocat(@"OTC_ad_newmsg") font:PFRegularFont(16) textColor:kColorFromStr(@"#979CAD") textAlignment:1 adjustsFont:YES];
        [view addSubview:leftLabel];
        leftLabel.userInteractionEnabled = YES;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, leftLabel.width, 2)];
        lineView.backgroundColor = kColorFromStr(@"#066B98");
        [view addSubview:lineView];
        lineView.centerX = leftLabel.centerX;
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:kRectMake(95 *kScreenWidthRatio, 0, 48, view.height) text:kLocat(@"OTC_order_done") font:PFRegularFont(16) textColor:kColorFromStr(@"#979CAD") textAlignment:1 adjustsFont:YES];
        [view addSubview:rightLabel];
        rightLabel.right = kScreenW - 95 *kScreenWidthRatio;
        rightLabel.userInteractionEnabled = YES;
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 38, leftLabel.width, 2)];
        lineView1.backgroundColor = kColorFromStr(@"#066B98");
        [view addSubview:lineView1];
        lineView1.centerX = rightLabel.centerX;

        [leftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction:)]];
        [rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction:)]];
  
        _leftView = lineView;
        _rightView = lineView1;
        _leftLabel = leftLabel;
        _rightLabel = rightLabel;
        _leftLabel.tag = 0;
        _rightLabel.tag = 1;

        if (_isNew) {
            _leftLabel.textColor = kColorFromStr(@"#066B98");
            _rightLabel.textColor = k666666Color;
        }else{
            _rightLabel.textColor = kColorFromStr(@"#066B98");
            _leftLabel.textColor = k666666Color;
        }
        
        _leftView.hidden = !_isNew;
        _rightView.hidden = _isNew;
        return view;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat h;
    if (section ) {
        h = 0.01;
    }else{
        h = 5;
    }
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, h)];
    view.backgroundColor = kTableColor;
    return view;
//    return nil;
}
-(void)headViewTapAction:(UITapGestureRecognizer *)tap
{
    
    if (tap.view.tag == 0) {
        if (_isNew) {
            return;
        }else{
            _isNew = YES;

            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
    }else{
        if (_isNew) {
            _isNew = NO;
            
            if (_doneOrderArray.count == 0) {
                [self loadDataWith:_donePage];
            }else{
                
                [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];

        }else{
            return;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        TPOTCSingleOrderModel *model;
        if (_isNew) {
            if (self.nwOrderArray.count == 0) {
                return;
            }
            model = self.nwOrderArray[indexPath.row];
        }else{
            if (self.doneOrderArray.count == 0) {
                return;
            }
            model = self.doneOrderArray[indexPath.row];
        }

        TPOTCOrderDetailController *vc = [TPOTCOrderDetailController new];
        NSInteger status = model.status.integerValue;
      //  status 0未付款 1已付款 2申诉中 3已完成 4已取消

        if (status == 0) {//
            vc.type = TPOTCOrderDetailControllerTypeNotPay;
        }else if (status == 1){
            vc.type = TPOTCOrderDetailControllerTypePaid;
        }else if (status == 2){
            vc.type = TPOTCOrderDetailControllerTypeAppleal;
        }else if (status == 3){
            vc.type = TPOTCOrderDetailControllerTypeDone;
        }else if (status == 4){
            vc.type = TPOTCOrderDetailControllerTypeCancel;
        }
        
        //创建模型
        TPOTCTradeListModel *mm = [TPOTCTradeListModel new];
        mm.currency_name = model.currency_name;
        mm.trade_id = model.trade_id;
        mm.type = @"sell";
        
        vc.model = mm;
        kNavPush(vc);
    }
}





-(void)cancelAdAction:(UIButton *)button
{
    [button.superview.superview removeFromSuperview];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"orders_id"] = _model.orders_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/OrdersOtc/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {

            [self showTips:[responseObj ksObjectForKey:kMessage]];
            
            TPCurrencyModel *model = [TPCurrencyModel new];
            model.currencyID = _currencyID;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kuserDidCancelAdActionKey" object:model];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });

        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

-(void)showTipsView:(UIButton *)button
{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 195)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 63) text:kLocat(@"OTC_ad_warning") font:PFRegularFont(18) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, 150, midView.width/2, 45) title:kLocat(@"Cancel") titleColor:kColorFromStr(@"#31AAD7") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton*   sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#DEEAFC");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, 150, midView.width/2, 45) title:kLocat(@"net_alert_load_message_sure") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#11B1ED");
    confirmlButton.tag = button.tag;
    [confirmlButton addTarget:self action:@selector(cancelAdAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-15, midView.width - 56, midView.height - 45 - titleLabel.height) text:@"撤銷廣告後廣告將會直接切換為完成狀態，已扣除的數量及手續費將不再退還（廣告發布後5小時內撤銷將收取1‰手續費，超過5小時不收取手續費）。且撤銷後不可逆轉，是否確定撤銷？" font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
//    [midView addSubview:tipsLabel];
    tipsLabel.numberOfLines = 0;
    
    UITextView *tv = [[UITextView alloc] initWithFrame:kRectMake(28, titleLabel.bottom-20, midView.width - 56, midView.height - titleLabel.bottom - 45)];
    
    [midView addSubview:tv];
    tv.font = PFRegularFont(14);
    tv.editable = NO;
    tv.textColor = k666666Color;
    tv.text = kLocat(@"s0112_OTCCancelTips");
    
    
}



-(void)refreshData
{
    _nwPage = 1;
    [self loadDataWith:_nwPage];
}


@end
