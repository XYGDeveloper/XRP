//
//  XPWalletPieView.m
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPWalletPieView.h"
#import "FSPieChartView.h"
#import "NSString+ZYMoney.h"
#import "TPWalletViewController.h"




@interface XPWalletPieView ()<FSPieChartViewDelegate, FSPieChartViewDataSource>
@property(nonatomic,strong)UIView *bgView;
@property (nonatomic, strong) FSPieChartView *chartView;
@property(nonatomic,assign)BOOL isEmpty;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *selectedCurrencyNameLabel;
@property(nonatomic,strong)UILabel *selectedCurrencyCNYLabel;
@property(nonatomic,strong)UIView *tipsView;
@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,strong)UIView *loginView;


@end

@implementation XPWalletPieView


-(void)setNotLogin:(BOOL)notLogin
{
    _notLogin = notLogin;
    
    _loginView.hidden = NO;
    
    
    
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 50)];
    view.backgroundColor = kTableColor;
    UILabel *line = [[UILabel alloc] initWithFrame:kRectMake(12, 20, 2, 20)];
    line.backgroundColor = kNaviColor;
    [view addSubview:line];
    [line alignVertical];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(20, 0, 200, 16) text:kLocat(@"M_balance") font:PFRegularFont(16) textColor:kColorFromStr(@"#222222") textAlignment:0 adjustsFont:0];
    [view addSubview:label];
    label.centerY = line.centerY;
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 38, 40) title:kLocat(@"W_more") titleColor:kColorFromStr(@"#066B98") font:PFRegularFont(14) titleAlignment:0];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [view addSubview:button];
    [button alignVertical];
    button.right = kScreenW - 12;
//    [button addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    [self addSubview:view];
    
    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
        if (isInvalid) {
            [vc gotoLoginVC];
        }else{
            [vc.navigationController pushViewController:[TPWalletViewController new] animated:YES];
        }
    }];
    
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(12, view.bottom, self.width - 24, self.height - 50 - 6)];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    _bgView = bgView;
    bgView.backgroundColor = kWhiteColor;
    //    kViewBorderRadius(_bgView, 4, 0, kYellowColor);
    [bgView.layer setCornerRadius:8];
    
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    bgView.layer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    bgView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    bgView.layer.shadowRadius = 2;//阴影半径，默认3
    
    _loginView = [[UIView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:_loginView];
    _loginView.hidden = YES;
    UIButton *loginButton = [[UIButton alloc] initWithFrame:kRectMake(0, 59, 210 *kScreenWidthRatio, 34) title:kLocat(@"LLogin") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [_loginView addSubview:loginButton];
    [loginButton alignHorizontal];
    kViewBorderRadius(loginButton, 17, 0, kRedColor);
    [loginButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
        [vc gotoLoginVC];
    }];
    [loginButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#6189C5")] forState:UIControlStateNormal];
    
    UIButton*registerButton = [[UIButton alloc] initWithFrame:kRectMake(0, loginButton.bottom+12, loginButton.width, loginButton.height) title:kLocat(@"LRegister") titleColor:kColorFromStr(@"6189C5") font:PFRegularFont(16) titleAlignment:0];
    [_loginView addSubview:registerButton];
    [registerButton alignHorizontal];
    kViewBorderRadius(registerButton, 17, 0.5, kColorFromStr(@"#6189C5"));
    [registerButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        YJBaseViewController *vc = (YJBaseViewController *)[kKeyWindow visibleViewController];
        [vc gotoRegisterVC];
    }];
}



-(void)setCurrencyArray:(NSArray<TPWalletCurrencyModel *> *)currencyArray
{
    _currencyArray = currencyArray;
    
    [_bgView removeAllSubviews];
    self.dataArray = [NSMutableArray array];
    
    double totle = 0;
    
    for (TPWalletCurrencyModel *model in self.currencyArray) {
        [self.dataArray addObject: model.cny.numberValue];
        totle += model.cny.doubleValue;
    }
    
    FSPieChartView *pieChartView = [[FSPieChartView alloc] initWithFrame:kRectMake(0, 20, 100, 100)];
    pieChartView.delegate = self;
    pieChartView.dataSource = self;
    [_bgView addSubview:pieChartView];
    [pieChartView alignHorizontal];
    self.chartView = pieChartView;
    pieChartView.backgroundColor = kWhiteColor;
    
    if (totle <= 0) {
        _isEmpty = YES;
    }else{
        _isEmpty = NO;
    }
    
    UILabel *CNYlabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, 70, 13) text:[NSString stringWithFormat:@"%@%.2f",self.currencyArray.firstObject.nw_price_unit,totle] font:PFRegularFont(12) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    [pieChartView addSubview:CNYlabel];
    [CNYlabel alignHorizontal];
    [CNYlabel alignVertical];
    
    
    UIView *tipsView = [[UIView alloc] initWithFrame:kRectMake(30 * kScreenWidthRatio, 25, 75, 40)];
    tipsView.backgroundColor = kColorFromStr(@"#626776");
    [_bgView addSubview:tipsView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:kRectMake(5, 7, tipsView.width - 10, 12) text:@"BTC" font:PFRegularFont(12) textColor:kWhiteColor textAlignment:0 adjustsFont:YES];
    [tipsView addSubview:nameLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:kRectMake(5, 23, tipsView.width - 10, 12) text:@"￥0.00" font:PFRegularFont(10) textColor:kWhiteColor textAlignment:0 adjustsFont:YES];
    [tipsView addSubview:moneyLabel];
    _tipsView = tipsView;
    _tipsView.hidden = YES;
    _selectedCurrencyCNYLabel = moneyLabel;
    _selectedCurrencyNameLabel = nameLabel;

    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:kRectMake(10, pieChartView.bottom + 12, _bgView.width-20, 60)];
    [_bgView addSubview:scView];
    scView.backgroundColor = kWhiteColor;
    scView.showsVerticalScrollIndicator = NO;
    scView.showsHorizontalScrollIndicator = NO;
    
    CGFloat w = 80;
    for (NSInteger i = 0; i < self.currencyArray.count; i++) {
        
//        UIView *colorView = [self createColorViewWithTitle:self.currencyArray[i].currency_name color:kColorFromStr(self.currencyArray[i].rgb)];
        UIView *colorView = [self createColorViewWithTitle:self.currencyArray[i].currency_mark color:kColorFromStr(self.currencyArray[i].rgb) cny:[NSString stringWithFormat:@"%@%@",self.currencyArray[i].nw_price_unit,self.currencyArray[i].cny] vol:[NSString stringWithFormat:@"%@ %@",self.currencyArray[i].money,self.currencyArray[i].currency_mark]];
        
        colorView.frame = kRectMake(i * (w + 15), 0, w, scView.height);
        [scView addSubview:colorView];
        
//        scView.contentSize = kSizeMake(colorView.right+10, 0);
    }
    scView.contentSize = kSizeMake((self.currencyArray.count*(w+18))-18, 0);

    
    
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

    _selectedCurrencyNameLabel.text = self.currencyArray[section].currency_mark;
    _selectedCurrencyCNYLabel.text = [NSString stringWithFormat:@"$%@",[NSString stringChangeMoneyWithStr:self.currencyArray[section].cny numberStyle:NSNumberFormatterDecimalStyle]];
    
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

-(UIView *)createColorViewWithTitle:(NSString *)title color:(UIColor *)color cny:(NSString *)cny vol:(NSString *)vol
{
    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, 80, 60)];
    view.backgroundColor = kClearColor;
    UILabel *colorV = [[UILabel alloc] initWithFrame:kRectMake(0, 8, 6, 6)];
    colorV.backgroundColor = color;
    [view addSubview:colorV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 0, view.width, 20) text:title font:PFRegularFont(13) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [view addSubview:label];
    
    UILabel *cnyLabel = [[UILabel alloc] initWithFrame:kRectMake(0, label.bottom + 8, view.width, 10) text:cny font:PFRegularFont(10) textColor:k666666Color textAlignment:0 adjustsFont:YES];
    [view addSubview:cnyLabel];
    
    UILabel *volLabel = [[UILabel alloc] initWithFrame:kRectMake(0, cnyLabel.bottom + 5, view.width, 10) text:vol font:PFRegularFont(10) textColor:k666666Color textAlignment:0 adjustsFont:YES];
    [view addSubview:volLabel];
    
    return view;
}


@end
