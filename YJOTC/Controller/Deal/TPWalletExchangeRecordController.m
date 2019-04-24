//
//  TPWalletExchangeRecordController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeRecordController.h"
#import "TPWalletExchangeRecordCell.h"
#import "TPWalletExchangeDetailView.h"



@interface TPWalletExchangeRecordController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *cancelView;
@property(nonatomic,strong)TPWalletExchangeDetailView *infoView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@end

@implementation TPWalletExchangeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self setupUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setupUI
{
    self.navigationItem.title = @"換幣記錄";
    self.enablePanGesture = NO;
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kColorFromStr(@"#111419");
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletExchangeRecordCell" bundle:nil] forCellReuseIdentifier:@"TPWalletExchangeRecordCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletExchangeRecordCell1" bundle:nil] forCellReuseIdentifier:@"TPWalletExchangeRecordCell1"];

    
    
    
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
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"page"] = @(page);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Exchange/log"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            
            if (datas.count == 0 && _dataArray.count == 0) {
                [self showTips:@"暂无订单"];
                return ;
            }
            if (page == 1) {
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in datas) {
                [self.dataArray addObject:dic];
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
-(void)loadCurrencyPriceWith:(NSString *)from to:(NSString *)to
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"from_id"] = from;
    param[@"to_id"] = to;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Exchange/from_to_cny"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            double fromPrice = [[responseObj ksObjectForKey:kData][@"from"][@"cny"] doubleValue];
            double toPrice = [[responseObj ksObjectForKey:kData][@"to"][@"cny"] doubleValue];

            
            //价格
            _infoView.leftPriceLabel.text = ConvertToString([responseObj ksObjectForKey:kData][@"from"][@"cny"]);
            
            _infoView.rightPriceLabel.text = ConvertToString([responseObj ksObjectForKey:kData][@"to"][@"cny"]);
            //手续费
            double fee = [self.dataArray[_index][@"fee"] doubleValue]/100;
            double feeRes = [self.dataArray[_index][@"from_num"] doubleValue] * fee * fromPrice / toPrice;
            
            _infoView.feeLabel.text = [NSString stringWithFormat:@"手續費：%.6f%@",feeRes,self.dataArray[_index][@"to_name"]];
            
            //预计到账
            double real = [self.dataArray[_index][@"from_num"] doubleValue] * (1-fee) * fromPrice / toPrice;
            _infoView.realLabel.text = [NSString stringWithFormat:@"%.6f%@",real,self.dataArray[_index][@"to_name"]];
            
            //估值
            
            _infoView.cnyLabel.text = [NSString stringWithFormat:@"估值：約%.2fCNY",[self.dataArray[_index][@"from_num"] doubleValue] * fromPrice];
            
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

    static NSString *rid = @"TPWalletExchangeRecordCell";
    TPWalletExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];

    }
    if ([self.dataArray[indexPath.section][@"status"] intValue] == 0) {
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60.0f];
        cell.delegate = self;
    }else{
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:0.0f];

        cell.delegate = nil;
    }
    cell.contentView.tag = indexPath.section;
    
    
    cell.dataDic = self.dataArray[indexPath.section];

    return cell;
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:kColorFromStr(@"#E43041") title:@"撤销"];
    
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    kLOG(@"删除动作");
    _index = cell.contentView.tag;
    
    [self showCancelViewWith:_index];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _index = indexPath.section;
    [self showInfoView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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



-(void)showCancelViewWith:(NSInteger)tag
{
    _cancelView = [[UIView alloc] initWithFrame:kScreenBounds];
    _cancelView.backgroundColor = [kBlackColor colorWithAlphaComponent:.64];
    [kKeyWindow addSubview:_cancelView];

    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(0, 230 *kScreenHeightRatio, 325 *kScreenWidthRatio, 144)];
    [_cancelView addSubview:midView];
    [midView alignHorizontal];
    midView.backgroundColor = kWhiteColor;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(midView.width / 2.0, midView.height - 45, midView.width / 2.0, 45) title:@"确定" titleColor:kWhiteColor font:PFRegularFont(15) titleAlignment:0];
    confirmButton.backgroundColor = kColorFromStr(@"#4C9EE4");
    [midView addSubview:confirmButton];
    confirmButton.tag = tag;
    [confirmButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, midView.height - 45, midView.width / 2.0, 45) title:@"取消" titleColor:kColorFromStr(@"#9BBBEB") font:PFRegularFont(15) titleAlignment:0];
    cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    [midView addSubview:cancelButton];
    
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        
        [_cancelView removeFromSuperview];
        _cancelView = nil;
        
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 40, midView.width, 16) text:@"是否確認撤銷該訂單" font:PFRegularFont(16) textColor:k323232Color textAlignment:1 adjustsFont:YES];
    
    [midView addSubview:tipsLabel];
}

-(void)cancelAction:(UIButton *)button
{
    
    [_cancelView removeFromSuperview];
    _cancelView = nil;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"log_id"] = self.dataArray[button.tag][@"log_id"];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Exchange/cancel"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
       
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            //刷新
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[button.tag]];
            dic[@"status"] = @"-1";
            dic[@"update_time"] = [NSDate returnTimeWithSecond:[NSDate date].timestamp formatter:@"yyyy-MM-dd HH:mm:ss"];
            
            [self.dataArray replaceObjectAtIndex:button.tag withObject:dic];
            [self.tableView reloadData];

        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}

-(void)showInfoView
{

    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:.64];
    [kKeyWindow addSubview:bgView];
    
   TPWalletExchangeDetailView *infoView = [[[NSBundle mainBundle] loadNibNamed:@"TPWalletExchangeDetailView" owner:nil options:nil] lastObject];
    [bgView addSubview:infoView];
    infoView.frame = kRectMake(0, 220 * kScreenHeightRatio, kScreenW, 135+45);
    bgView.userInteractionEnabled = YES;
    infoView.dataDic = self.dataArray[_index];
    if ([self.dataArray[_index][@"status"] intValue] == 0) {
        [self loadCurrencyPriceWith:self.dataArray[_index][@"currency_id"] to:self.dataArray[_index][@"to_currency_id"]];
    }
    _infoView = infoView;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(UITapGestureRecognizer * sender) {
        [sender.view removeFromSuperview];
    }]];
    
}


-(void)backAction
{
    if (_killLastVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super backAction];
    }
}




@end
