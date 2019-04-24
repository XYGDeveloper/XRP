//
//  TPWalletViewController.m
//  YJOTC
//
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletViewController.h"
#import "TPWalletListCell.h"
#import "TPWalletRecevieController.h"
#import "TPWalletCurrencyInfoController.h"
#import "FSPieChartView.h"
#import "TPWalletExchangeController.h"
#import "TPWalletLockController.h"
#import "TPWalletCurrencyModel.h"
#import "NSString+ZYMoney.h"
#import "TPWalletAccountBookController.h"
#import "TPWalletExchangeController.h"
#import "TPWalletSendListController.h"


@interface TPWalletViewController ()<UITableViewDelegate,UITableViewDataSource,FSPieChartViewDelegate, FSPieChartViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIButton *rightButton;

@property (nonatomic, strong) FSPieChartView *chartView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property(nonatomic,strong)NSArray *colorArray;

@property(nonatomic,strong)NSMutableArray<TPWalletCurrencyModel *> *currencyArray;

@property(nonatomic,strong)UILabel *selectedCurrencyNameLabel;
@property(nonatomic,strong)UILabel *selectedCurrencyCNYLabel;
@property(nonatomic,strong)UIView *tipsView;


@property(nonatomic,assign)NSInteger selectedIndex;


@property(nonatomic,assign)BOOL isEmpty;

@property(nonatomic,assign)BOOL firstLoad;




@end

@implementation TPWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;
    _currencyArray = [NSMutableArray array];
    [self loadData];
    [self setupUI];
    [self initNavi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"kUserDidSendCurrencySuccessKey" object:nil];

    

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
    
    self.navigationItem.title = kLocat(@"Z_Wallet");
    
    self.topView.y = kNavigationBarHeight;

    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,self.topView.bottom, kScreenW, kScreenH - self.topView.bottom) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletListCell" bundle:nil] forCellReuseIdentifier:@"TPWalletListCell"];
    
    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self loadData];
}
-(void)loadData
{
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
//            _tableView.tableHeaderView = [self setupHeadView];

            [self.tableView reloadData];
            
        }else{
            
        }
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPWalletListCell";
    TPWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    cell.model = self.currencyArray[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPWalletCurrencyInfoController *vc = [TPWalletCurrencyInfoController new];
    
    vc.model = self.currencyArray[indexPath.row];
    
    kNavPush(vc);
}



-(void)topButtonAction:(UIButton *)button
{

    switch (button.tag) {
        case 0://轉賬
        {
            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
        case 1:
        {
            TPWalletSendListController *vc = [TPWalletSendListController new];
            kNavPush(vc);
        }
            break;
        case 2:
        {
            kNavPush([TPWalletRecevieController new]);
        }
            break;
        case 3://賬本
        {
            kNavPush([TPWalletAccountBookController new]);
        }
            break;
        case 4:
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.topView.height = 0;
                self.tableView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight);
            }];
        }
            break;
        case 5:
        {
            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
        case 6:
        {
            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
        case 7:
        {
            [self showTips:kLocat(@"g_jqqd")];
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return [self createTopViewWithTitle:kLocat(@"M_AssetList")];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.currencyArray.count == 0) {
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
    [headerView addSubview:[self createTopViewWithTitle:kLocat(@"M_balance")]];
    headerView.backgroundColor = kWhiteColor;
    
    self.selectedIndex = 100;

    self.titleArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    double totle = 0;
    
    for (TPWalletCurrencyModel *model in self.currencyArray) {
        [self.dataArray addObject: model.cny_total.numberValue];
        totle += model.cny_total.doubleValue;
    }
    
//    [self.titleArray addObjectsFromArray:@[@"BCB", @"BTC", @"ETH",@"USDT"]];
//    for (int i = 0; i < self.titleArray.count; i++) {
//        int rand = arc4random() % 101;
//        [self.dataArray addObject:@(rand)];
//    }
    
    
    FSPieChartView *pieChartView = [[FSPieChartView alloc] initWithFrame:kRectMake(0, 25+48, 100, 100)];
    pieChartView.delegate = self;
    pieChartView.dataSource = self;
    [headerView addSubview:pieChartView];
    [pieChartView alignHorizontal];
    self.chartView = pieChartView;
    pieChartView.backgroundColor = kClearColor;
    
    
    if (totle <= 0) {
        _isEmpty = YES;
    }else{
        _isEmpty = NO;
    }
    
    UILabel *CNYlabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 70, 13) text:[NSString stringWithFormat:@"¥%.2f",totle] font:PFRegularFont(12) textColor:k666666Color textAlignment:1 adjustsFont:YES];
    [pieChartView addSubview:CNYlabel];
    [CNYlabel alignHorizontal];
    [CNYlabel alignVertical];
    
    
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:kRectMake(50, pieChartView.bottom + 15, kScreenW - 100, 30)];
    [headerView addSubview:scView];
    scView.backgroundColor = kClearColor;
    scView.showsVerticalScrollIndicator = NO;
    scView.showsHorizontalScrollIndicator = NO;
    
    CGFloat w = 42;
    for (NSInteger i = 0; i < self.currencyArray.count; i++) {
        
        UIView *colorView = [self createColorViewWithTitle:self.currencyArray[i].currency_name color:kColorFromStr(self.currencyArray[i].rgb)];
        colorView.frame = kRectMake(i * (w + 30), 5, w, 20);
        [scView addSubview:colorView];
        
        scView.contentSize = kSizeMake(colorView.right+10, 0);
    }
    
    if (scView.contentSize.width < scView.width) {

        scView.x = (kScreenW - scView.contentSize.width)/2;
    }
    
    UIView *tipsView = [[UIView alloc] initWithFrame:kRectMake(30 * kScreenWidthRatio, 25+48, 75, 40)];
    tipsView.backgroundColor = kColorFromStr(@"#636466");
    [headerView addSubview:tipsView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:kRectMake(5, 7, tipsView.width - 10, 12) text:@"BTC" font:PFRegularFont(12) textColor:kColorFromStr(@"#DDDDDD") textAlignment:0 adjustsFont:YES];
    [tipsView addSubview:nameLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:kRectMake(5, 23, tipsView.width - 10, 12) text:@"￥0.00" font:PFRegularFont(10) textColor:kColorFromStr(@"#DDDDDD") textAlignment:0 adjustsFont:YES];
    [tipsView addSubview:moneyLabel];
    _tipsView = tipsView;
    _tipsView.hidden = YES;
    _selectedCurrencyCNYLabel = moneyLabel;
    _selectedCurrencyNameLabel = nameLabel;
    return headerView;
}


-(void)rightButtonAction:(UIButton *)button
{
//    [self.view bringSubviewToFront:self.topView];
    if (self.topView.height == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.topView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 130);
            self.tableView.frame = kRectMake(0, self.topView.bottom, kScreenW, kScreenH - self.topView.bottom );
        }];
    }
}
-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 130)];
        [self.view addSubview:_topView];
        _topView.backgroundColor = kColorFromStr(@"#225686");
        
        //        CGFloat w = 22 + 20 ;
        CGFloat w = kScreenW/5;
        CGFloat h = _topView.height/2;
        NSInteger totalColumns = 5;
        CGFloat margin = 0;
        NSArray *titles = @[kLocat(@"x_xzhaunzhan"),kLocat(@"K_Scan"),kLocat(@"W_receive"),kLocat(@"x_xzhangben"),kLocat(@"OTC_main_hide"),kLocat(@"x_Minebooosplan"),kLocat(@"x_xassetbank"),kLocat(@"M_XRPassset")];
        NSArray *icons = @[@"pay_icon_zb",@"pay_icon_sys",@"pay_icon_zsshou",@"pay_icon_zab",@"poc_icon_hide",@"pay_icon_boss",@"pay_icon_blank",@"pay_icon_xrp+"];
        
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
    
}
-(UIView *)createTopViewWithTitle:(NSString *)str
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 46)];
    view.backgroundColor = kTableColor;
    UILabel *line = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 2, 16)];
    line.backgroundColor = kNaviColor;
    [view addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 200, 16) text:str font:PFRegularFont(16) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
    [view addSubview:label];
    label.centerY = line.centerY;
    return view;
}

#pragma mark - 饼状图
- (NSInteger)numberOfSectionForChartView:(FSPieChartView *)chartView {
    if (_isEmpty) {
        return 1;
    }
    
    return self.currencyArray.count;
}
- (CGFloat)pieChartView:(FSPieChartView *)chartView percentageDataForSection:(NSInteger)section {
    
    if (_isEmpty) {
        return 1;
    }
    
    return [self.dataArray[section] floatValue] / [[self.dataArray valueForKeyPath:@"@sum.floatValue"] floatValue];
}
- (UIColor *)pieChartView:(FSPieChartView *)chartView colorForSection:(NSInteger)section
{
    if (_isEmpty) {
        return [UIColor grayColor];
    }
    return kColorFromStr(self.currencyArray[section].rgb);
}
- (UIColor *)innerCircleBackgroundColorForChartView:(FSPieChartView *)chartView
{
    
    return kWhiteColor;
}
- (CGFloat)innerCircleRadiusForChartView:(FSPieChartView *)chartView
{
    return 35;
}

-(void)pieChartView:(FSPieChartView *)chartView didSelectItemForSection:(NSInteger)section
{
    if (_isEmpty ) {
        return;
    }
    
    _selectedCurrencyNameLabel.text = self.currencyArray[section].currency_name;
    _selectedCurrencyCNYLabel.text = [NSString stringWithFormat:@"¥%@",[NSString stringChangeMoneyWithStr:self.currencyArray[section].cny_total numberStyle:NSNumberFormatterDecimalStyle]];
    
    static int i = 0;
    i++;
    if (i%2) {
        
        if (section == self.selectedIndex) {
            self.tipsView.hidden = YES;
            self.selectedIndex = 10000;
        }else{
            self.tipsView.hidden = NO;
            self.selectedIndex = section;
        }
        
    }
    
}
-(void)pieChartView:(FSPieChartView *)chartView didDeselectItemForSection:(NSInteger)section
{
    if (_isEmpty ) {
        return;
    }
    self.tipsView.hidden = YES;
}
-(void)didDeselectAllSectionForChartView:(FSPieChartView *)chartView
{
    if (_isEmpty ) {
        return;
    }
    self.tipsView.hidden = YES;
    self.selectedIndex = 10000;
}

#pragma mark - 颜色对比

-(UIView *)createColorViewWithTitle:(NSString *)title color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, 12 + 30, 20)];
    view.backgroundColor = kClearColor;
    UILabel *colorV = [[UILabel alloc] initWithFrame:kRectMake(0, 8, 6, 6)];
    colorV.backgroundColor = color;
    [view addSubview:colorV];

    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 40, 20) text:title font:PFRegularFont(13) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [view addSubview:label];

    return view;
}











-(NSArray *)colorArray
{
    if (_colorArray == nil) {
        _colorArray = @[kColorFromStr(@"#11B1ED"),kColorFromStr(@"#03C086"),kColorFromStr(@"#D56521"),kColorFromStr(@"#9924CA"),kYellowColor,kRedColor,kWhiteColor,[UIColor purpleColor],[UIColor orangeColor],kLightGrayColor];
    }
    return _colorArray;
}







@end
