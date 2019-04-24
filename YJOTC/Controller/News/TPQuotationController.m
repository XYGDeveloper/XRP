//
//  TPQuotationController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPQuotationController.h"
#import "TPBiToBiListCell.h"
#import "TPDealHistoryController.h"
#import "TPQuotationModel.h"
#import "TPTradeMallController.h"
#import "TPCurrencyInfoController.h"
#import "TPOTCBuyListController.h"
#import "TPNewsViewController.h"

@interface ZYNOHighlightedButton : UIButton

- (void)setHighlighted:(BOOL)highlighted;

@end

@implementation ZYNOHighlightedButton

-(void)setHighlighted:(BOOL)highlighted
{
    
}

@end


@interface TPQuotationController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ZJScrollPageViewDelegate,UITextFieldDelegate>

@property(nonatomic,assign)BOOL isBCB;

@property(nonatomic,strong)UIButton *BCBButton;
@property(nonatomic,strong)UIButton *ETHButton;
@property(nonatomic,strong)UITextField *searchTF;
@property(nonatomic,strong)UIView *midView;
@property(nonatomic,strong)HXSearchBar *searchBar;
@property(nonatomic,strong)UIButton *searchButton;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<TPQuotationModel *> *BCBArrays;

@property(nonatomic,strong)NSMutableArray<TPQuotationModel *> *ETHArrays;

@property(nonatomic,copy)NSString *keyWord;


@property(nonatomic,assign)BOOL firstLoad;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;


@property(nonatomic,strong)UIView *searchView;

@property(nonatomic,strong)NSMutableArray<XPQuotationModel*> *XRPArrays;

@property(nonatomic,strong)NSMutableArray<XPQuotationModel*> *USDTArrays;

@property(nonatomic,copy)NSArray *dataArr;



@end

@implementation TPQuotationController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstLoad = YES;
    _XRPArrays = [NSMutableArray new];
    _USDTArrays = [NSMutableArray new];
    [self loadBBData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)loadBBData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/quotation1"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        [[EmptyManager sharedManager] removeEmptyFromView:self.view];

        if (success) {
            _dataArr = [responseObj ksObjectForKey:kData];
            _XRPArrays = [NSMutableArray new];
            _USDTArrays = [NSMutableArray new];
//            for (NSDictionary *dic in [responseObj ksObjectForKey:kData][0][@"data_list"]) {
//                [self.USDTArrays addObject:[XPQuotationModel modelWithJSON:dic]];
//            }
//
//            for (NSDictionary *dic in [[responseObj ksObjectForKey:kData] lastObject][@"data_list"]) {
//                [self.XRPArrays addObject:[XPQuotationModel modelWithJSON:dic]];
//            }
            [self setupUI];

        }else{
            [[EmptyManager sharedManager]showNetErrorOnView:self.view response:nil operationBlock:^{
                [self loadBBData];
            }];
        }
    }];
}





-(void)setupUI
{
    [self addLeftBarButtonWithImage:kImageFromStr(@"lay_icon_user") action:@selector(avatarAction)];

    self.view.backgroundColor = kColorFromStr(@"#225686");
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    
    style.showCover = YES;
    style.coverBackgroundColor = kColorFromStr(@"#3284CA");
    style.coverCornerRadius = 4;
    
    //显示滚动条
    style.showLine = NO;
    style.scrollLineColor = kColorFromStr(@"#066B98");
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollLineHeight = 2;
    style.titleFont = PFRegularFont(14);
    style.normalTitleColor = k222222Color;
    style.selectedTitleColor = kColorFromStr(@"#066B98");
//        style.autoAdjustTitlesWidth = YES;
    style.adjustCoverOrLineWidth = NO;
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 44;
    style.scrollTitle = YES;
    
    style.normalTitleColor = kWhiteColor;
    style.selectedTitleColor = kWhiteColor;
    style.contentViewBounces = NO;
    
//    self.titles = @[@"XRP",@"USDT"].mutableCopy;
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_dataArr.count];

    for (NSDictionary *dic in _dataArr) {
        [titles addObject:[NSString stringWithFormat:@" %@        ",dic[@"name"]]];
    }
    
    
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height -kNavigationBarHeight) segmentStyle:style titles:titles.mutableCopy parentViewController:self delegate:self];
    //    _scrollPageView.contentView.collectionView.bounces = NO;
        _scrollPageView.segmentView.backgroundColor = kColorFromStr(@"#225686");
        _scrollPageView.contentView.backgroundColor = kColorFromStr(@"#225686");;
        _scrollPageView.contentView.collectionView.backgroundColor = kColorFromStr(@"#225686");
    [self.view addSubview:_scrollPageView];
    
//    [self addRightBarButtonWithFirstImage:kImageFromStr(@"mar_icon_search") action:@selector(searchAction)];
    
    
    return;
    
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH - kNavigationBarHeight - kTabbarItemHeight) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPBiToBiListCell" bundle:nil] forCellReuseIdentifier:@"TPBiToBiListCell"];
    
    
    __weak typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDateWithKeyWord:_keyWord];
    }];
    
    
    
    [self setupNavi];
}






-(NSInteger)numberOfChildViewControllers
{
    return _dataArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    TPNewsViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;



    
    if (!childVc) {
        childVc = [TPNewsViewController new];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *listModels = [NSMutableArray array];
    
    for (NSDictionary *dic in _dataArr[index][@"data_list"]) {
        [arr addObject:[XPQuotationModel modelWithJSON:dic]];
        
        ListModel *model = [ListModel modelWithJSON:dic];
        [listModels addObject:model];
//        kLOG(@"%@",model);
    }
    
    childVc.ListModelArray = listModels.mutableCopy;
    childVc.dataArray = arr.mutableCopy;
    childVc.index = index;
    
//    childVc.model = self.dataArr[index];
    return childVc;
}


-(void)searchAction
{
    self.searchView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.searchView.alpha = 1;
        self.searchView.frame = kRectMake(0, kNavigationBarHeight, kScreenW, 44);
        self.scrollPageView.frame = CGRectMake(0, kNavigationBarHeight + 44, self.view.bounds.size.width, self.view.bounds.size.height -kNavigationBarHeight-kTabbarItemHeight - 44);
    }];
    
}


-(void)setupNavi
{
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, kNavigationBarHeight)];
    topView.backgroundColor = kColorFromStr(@"#1F2225");
    
    UIView *midView = [[UIView alloc]initWithFrame:kRectMake(0, 0, 170, 30)];
    [topView addSubview:midView];
    midView.backgroundColor = topView.backgroundColor;
    kViewBorderRadius(midView, 0, 1, kColorFromStr(@"#A74125"));
    [midView alignHorizontal];
    midView.bottom = topView.height - 5;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, midView.width/2, midView.height) title:@"BCB" titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:leftButton];
    [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#A74125")] forState:UIControlStateSelected];

    
    [leftButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#1F2225")] forState:UIControlStateNormal];
    leftButton.selected = YES;
    leftButton.tag = 0;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, leftButton.width, leftButton.height) title:@"ETH" titleColor:kWhiteColor font:PFRegularFont(18) titleAlignment:0];
    [midView addSubview:rightButton];
    [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#A74125")] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#1F2225")] forState:UIControlStateNormal];
    rightButton.tag = 1;
    
    [self.view addSubview:topView];
    _isBCB = YES;
    [rightButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //搜索
    UIButton *searchButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 59, 0, 59, 35)];
//    [searchButton setTitle:@"🔍" forState:UIControlStateNormal];
    
    [searchButton setImage:kImageFromStr(@"lay_icon_search") forState:UIControlStateNormal];
    [topView addSubview:searchButton];
//    searchButton.backgroundColor = kYellowColor;
    searchButton.centerY = midView.centerY;
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  
    
    HXSearchBar *searchBar = [[HXSearchBar alloc]initWithFrame:kRectMake(59, 0, kScreenW - 59 - 19, searchButton.height)];
    searchBar.showsCancelButton = YES;
    searchBar.searchBarTextField.textColor = kColorFromStr(@"#CDD2E3");
    searchBar.searchBarTextField.font = PFRegularFont(16);
    searchBar.searchBarTextField.backgroundColor = topView.backgroundColor;
    searchBar.cursorColor = kColorFromStr(@"#CDD2E3");
    searchBar.placeholder = @"搜索幣種";
    
    searchBar.hidden = YES;
    [topView addSubview:searchBar];
    searchBar.centerY = midView.centerY;
    searchBar.backgroundColor = topView.backgroundColor;;
    searchBar.searchBarTextField.leftViewMode = UITextFieldViewModeNever;

    searchBar.tintColor = topView.backgroundColor;
    searchBar.barTintColor = topView.backgroundColor;
    [searchBar.cancleButton setTitleColor:kColorFromStr(@"#CDD2E3") forState:UIControlStateNormal];
    
    searchBar.delegate = self;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.height - 4, searchBar.width - 10 - 40, 1)];
    lineView.backgroundColor = kColorFromStr(@"#BBBFD1");
    [searchBar addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    lineView1.backgroundColor = topView.backgroundColor;
    [searchBar addSubview:lineView1];
    
    
    _BCBButton = leftButton;
    _ETHButton = rightButton;
    _midView = midView;
    _searchBar = searchBar;
    _searchButton = searchButton;
    

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

-(void)loadDateWithKeyWord:(NSString *)keyWord
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (_isBCB) {
        param[@"market"] = @"BCBcy";
    }else{
        param[@"market"] = @"ETH";
    }
    if (keyWord.length > 0) {
        param[@"keyword"] = keyWord;
    }
    
    if (_firstLoad) {
        kShowHud;
    }
    
//    kShowHud;
    
    [kNetwork_Tool POST_HTTPS:@"/api/trade/quotation" andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (_firstLoad) {
            _firstLoad = NO;
            kHideHud;
        }
        [_tableView.mj_header endRefreshing];
//        kHideHud;
        if (success) {
            NSArray *datas = [responseObj ksObjectForKey:kData];
            kLOG(@"%@",datas);
            if (_isBCB) {
                
                [self.BCBArrays removeAllObjects];
                for (NSDictionary *dic in datas) {
                    [self.BCBArrays addObject:[TPQuotationModel modelWithJSON:dic]];
                }
            }else{
                [self.ETHArrays removeAllObjects];
                for (NSDictionary *dic in datas) {
                    [self.ETHArrays addObject:[TPQuotationModel modelWithJSON:dic]];
                }
            }
            [self.tableView reloadData];

        }else{
            
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            if (_isBCB) {
                [self.BCBArrays removeAllObjects];
            }else{
                [self.ETHArrays removeAllObjects];
            }
            [self.tableView reloadData];
        }
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isBCB) {
        return self.BCBArrays.count;
    }else{
        return self.ETHArrays.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"TPBiToBiListCell";
    TPBiToBiListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    
    cell.isBCB = _isBCB;
    if (_isBCB) {
        cell.model = self.BCBArrays[indexPath.section];
    }else{
        cell.model = self.ETHArrays[indexPath.section];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TPTradeMallController *vc = [[TPTradeMallController alloc] init];
    TPCurrencyInfoController *vc = [[TPCurrencyInfoController alloc] init];

    if (_isBCB) {
        vc.currencyID = self.BCBArrays[indexPath.section].currency_id;
        vc.currencyName = self.BCBArrays[indexPath.section].currency_mark;

    }else{
        vc.currencyID = self.ETHArrays[indexPath.section].currency_id;
        vc.currencyName = self.ETHArrays[indexPath.section].currency_mark;
    }
    
    vc.isETH = !_isBCB;
    kNavPush(vc);
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
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









-(void)topButtonAction:(UIButton *)button
{
    if (button.isSelected) {
        return;
    }else{
        if (button.tag == 0) {
            _BCBButton.selected = YES;
            _ETHButton.selected = NO;
        }else{
            _BCBButton.selected = NO;
            _ETHButton.selected = YES;
        }
    }
    _isBCB = _BCBButton.isSelected;
    [self loadDateWithKeyWord:@""];
}

-(void)searchButtonAction:(UIButton *)button
{
    if (button.x > 50) {
        button.x = 0;
        _searchBar.hidden = NO;
        _midView.hidden = YES;
        _searchBar.text = @"";
        if (_isBCB) {
            [self.BCBArrays removeAllObjects];
        }else{
            [self.ETHArrays removeAllObjects];
        }
        [self.tableView reloadData];
        [_searchBar becomeFirstResponder];
    }else{
        
        return;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        return;
    }
    
    [self hideKeyBoard];
    _keyWord = searchBar.text;
    [self loadDateWithKeyWord:searchBar.text];    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _keyWord = searchText;
    [self loadDateWithKeyWord:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self hideKeyBoard];
    searchBar.hidden = YES;
    _midView.hidden = NO;
    
    _searchButton.x = kScreenW - 59;
    _keyWord = @"";
    [self loadDateWithKeyWord:@""];
    
}










-(NSMutableArray *)BCBArrays
{
    if (_BCBArrays == nil) {
        _BCBArrays = [NSMutableArray array];
    }
    return _BCBArrays;
}
-(NSMutableArray *)ETHArrays
{
    if (!_ETHArrays) {
        _ETHArrays = [NSMutableArray array];
    }
    return _ETHArrays;
}

-(UIView *)searchView
{
    if (_searchView == nil) {
        UIView *v = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight, kScreenW, 44)];
        [self.view addSubview:v];
        v.backgroundColor = kColorFromStr(@"#225686");
        _searchView = v;
        
        
//        UIView *midView = [[UIView alloc] initWithFrame:kRectMake(12, 0, 310, 30)];
//        [v addSubview:midView];
//        midView.backgroundColor = kColorFromStr(@"3284CA");
//        kViewBorderRadius(midView, 15, 0, kRedColor);
        
        UITextField *tf = [[UITextField alloc] initWithFrame:kRectMake(12, 0, kScreenW - 53-12, 30)];
        tf.font = PFRegularFont(14);
        tf.placeholder = @"Search";;
        tf.textColor = kWhiteColor;
        kTextFieldPlaceHoldColor(tf, kColorFromStr(@"#DBEEFF"));
        kViewBorderRadius(tf, 15, 0, kRedColor);
        tf.textAlignment = 1;
        tf.borderStyle = UITextBorderStyleNone;
        tf.backgroundColor = kColorFromStr(@"#3284CA");
        [v addSubview:tf];
        [tf alignVertical];
        tf.delegate = self;
        UIView *leftView = [[UIView alloc] initWithFrame:kRectMake(0, 0, 14, 30)];
        tf.leftView = leftView;
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.returnKeyType = UIReturnKeySearch;
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(tf.right, 0, 53, v.height) title:kLocat(@"x_xfold") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
        [v addSubview:button];
        [button addTarget:self action:@selector(hideSearchView) forControlEvents:UIControlEventTouchUpInside];
 
        
    }
    return _searchView;
}
-(void)hideSearchView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.searchView.alpha = 0;
        self.scrollPageView.frame = CGRectMake(0, kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height -kNavigationBarHeight);

    } completion:^(BOOL finished) {
        self.searchView.hidden = YES;
    }];
 
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textAlignment = 0;
}

@end
