//
//  YTBuyAndSellDetailTableViewController.m
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YTBuyAndSellDetailTableViewController.h"
#import "YTTradeRequest.h"
#import "YTData_listModel.h"
#import "YTTradeIndexModel.h"
#import "YTSellTrendingContaineeViewController.h"
#import "NSString+RemoveZero.h"
#import "HBCurrentEntrustContaineeTableViewController.h"
#import "HBCurrentEntrustViewController.h"
#import "YTTradeUserOrderModel+Request.h"
#import "ZJPayPopupView.h"
#import "NSString+Operation.h"
#import "StepSlider.h"
#import "YTMyassetDetailModel.h"
#import "NSObject+SVProgressHUD.h"
#import "UITextField+HB.h"
#import "YTMyassetDetailModel+Request.h"
#import "YTTradeIndexModel+Request.h"
#import "YTTradeUserOrderModel+Request.h"
#import "TPWalletSendKeyboardView.h"

@interface YTBuyAndSellDetailTableViewController () <ZJPayPopupViewDelegate, UITextFieldDelegate,TPWalletSendKeyboardViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *calculateContainerViews;
@property (weak, nonatomic) IBOutlet UIButton *buyOrSellButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UIView *circleView;


@property (weak, nonatomic) IBOutlet UIButton *limitButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *fristCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (nonatomic, assign) BOOL isChangeOfNumberByStepSlider;



@property (nonatomic, strong) YTSellTrendingContaineeViewController *sellTrendingContaineeVC;
@property (nonatomic, strong) YTSellTrendingContaineeViewController *buyTrendingContaineeVC;
@property (nonatomic, strong) HBCurrentEntrustContaineeTableViewController *entrustContaineeVC;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;

/**
 买入 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

/**
 卖出 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

/**
 ≈ 多少 CNY
 */
@property (weak, nonatomic) IBOutlet UILabel *myCurrentPriceLabel;

/**
 可用
 */
@property (weak, nonatomic) IBOutlet UITextField *availableLabel;


/**
 当前币种 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

/**
 当前币种价格换算成 CNY 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *currentUsdPriceLabel;


/**
 数量滑动条
 */
@property (weak, nonatomic) IBOutlet StepSlider *stepSlider;

@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;

/**
 交易额值
 */
@property (weak, nonatomic) IBOutlet UILabel *tradeNumLabel;

/**
 ”交易额“ label
 */
@property (weak, nonatomic) IBOutlet UILabel *tradeNumNameLabel;

@property (nonatomic, strong) ZJPayPopupView *payPopupView;


/**
 "当前委托" label
 */
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

/**
 全部 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *allButton;

/**
 盘口
 */
@property (weak, nonatomic) IBOutlet UILabel *pkLabel;

/**
 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


/**
 数量 币种名称
 */
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *myPriceContainerViews;

@property (weak, nonatomic) IBOutlet UILabel *maxNumberLabel;


@property (nonatomic, copy) NSString *maxNumber;

@property (nonatomic, strong) NSArray<NSString *> *typesOfPrice;
@property (nonatomic, copy) NSString *selectedTypeOfPrice;

@property (nonatomic, strong) YTTradeIndexModel *tradeIndexs;
@property (nonatomic, strong) YTMyassetDetailModel *assetModel;
@property (nonatomic, strong) YTMyassetDetailModel *tradeAssetModel;

@property (nonatomic, strong) dispatch_group_t requestGroup;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isFetchInProgress;


@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *number;




@end

@implementation YTBuyAndSellDetailTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestGroup = dispatch_group_create();
    [self _setupUI];
    [self _addObservers];
    [self _addNotifications];
}

- (void)dealloc {
    [self.priceTextField removeObserver:self forKeyPath:@"text"];
    [self.numberTextField removeObserver:self forKeyPath:@"text"];
    [self.availableLabel removeObserver:self forKeyPath:@"text"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCurrentEntrustVC"]) {
        HBCurrentEntrustViewController *vc = segue.destinationViewController;
        vc.model = self.model;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showCurrentEntrustVC"]) {
        if ([Utilities isExpired]) {
            [self gotoLoginVC];
            return NO;
        }
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self _requestAllData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(_requestTradeIndexModels) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Trade" bundle:nil] instantiateViewControllerWithIdentifier:@"YTBuyAndSellDetailTableViewController"];
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return [self.entrustContaineeVC getHeight];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - ZJPayPopupViewDelegate

- (void)didPasswordInputFinished:(NSString *)password {
    [self.payPopupView hidePayPopView];
    if (password.length == 0) {
        NSString *msg = kLocat(@"k_YTBuyAndSellDetailTableViewController_TransactionCannotBeEmpty");
        [self.view showWarning:msg];
        return;
    }
    kShowHud;
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    [YTTradeRequest operateTradeWithCurrencyID:self.model.currency_id ?: @"52" isTypeOfBuy:self.isTypeOfBuy price:price number:number password:password success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        [self.view showWarning:obj.message];
        if ([obj succeeded]) {
            [self.tableView.mj_header beginRefreshing];
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self.view showWarning:error.localizedDescription];
    }];
}

#pragma mark - Private

- (void)_addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRefreshNotification:) name:@"kUserDidSelectedNewCurrencyKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldDidChangeWithNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)_addObservers {
    [self.priceTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.numberTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.availableLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_requestAllData {
    
    if (self.isFetchInProgress) {
        [self.tableView.mj_header endRefreshing];
        return;
    }

    
    if (!self.model) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    self.isFetchInProgress = YES;
    dispatch_group_enter(self.requestGroup);
    [self _requestTradeIndexModelsWithIsNeedGroup:YES];
    dispatch_group_enter(self.requestGroup);
    [self _requestMyCurrencyNumber];
    dispatch_group_enter(self.requestGroup);
    [self _requestMyTradeCurrencyNumber];
    dispatch_group_enter(self.requestGroup);
    [self _requestUserOrders];
    
    dispatch_group_notify(self.requestGroup, dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        self.isFetchInProgress = NO;
    });
}

- (void)_requestUserOrders {
    [YTTradeUserOrderModel requestTradeUserOrdersWithCurrencyModel:self.model isTypeOfBuy:nil rows:10 page:0 isHistory:NO success:^(NSArray<YTTradeUserOrderModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull obj) {
        self.orders = array;
        self.entrustContaineeVC.orders = array;
        [self.tableView reloadData];
        dispatch_group_leave(self.requestGroup);
    } failure:^(NSError * _Nonnull error) {
        dispatch_group_leave(self.requestGroup);
    }];
}

- (void)_requestTradeIndexModels {
    [self _requestTradeIndexModelsWithIsNeedGroup:NO];
}

- (void)_requestTradeIndexModelsWithIsNeedGroup:(BOOL)isNeedGroup {
    [YTTradeIndexModel requestTradeIndexsWithCurrencyID:self.model.currency_id success:^(YTTradeIndexModel *_Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        if (isNeedGroup) {
            dispatch_group_leave(self.requestGroup);
        }
        
        self.tradeIndexs = model;
    } failure:^(NSError * _Nonnull error) {
        if (isNeedGroup) {
            dispatch_group_leave(self.requestGroup);
        }
    }];
}


- (void)_requestMyCurrencyNumber {
    [YTMyassetDetailModel requestMyAssetDetailWithCurrencyID:self.model.currency_id success:^(YTMyassetDetailModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.assetModel = model;
        dispatch_group_leave(self.requestGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(self.requestGroup);
        [self showInfoWithMessage:error.localizedDescription];
    }];
    
}

- (void)_requestMyTradeCurrencyNumber {
    [YTMyassetDetailModel requestMyAssetDetailWithCurrencyID:self.model.trade_currency_id success:^(YTMyassetDetailModel * _Nonnull model, YWNetworkResultModel * _Nonnull obj) {
        self.tradeAssetModel = model;
        dispatch_group_leave(self.requestGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(self.requestGroup);
    }];
}

- (void)_setupUI {
    self.title = self.model.comcurrencyName;
    self.enablePanGesture = NO;
    self.limitButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_requestAllData)];
    
    self.numberTextField.delegate = self;
    
    //设置颜色
    self.tableView.backgroundColor = kThemeColor;
    self.fristCell.backgroundColor = kTableColor;
    self.secondCell.backgroundColor = kTableColor;
    self.numberTextField.placeholder = kLocat(@"Number");
    [self.calculateContainerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.;
        obj.layer.borderColor = k999999Color.CGColor;
    }];
    
    [self.containerViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor whiteColor];
    }];
    
    [self.stepSlider addTarget:self action:@selector(_stepSliderProgressChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_setTextOfPriceTextFieldToTextOfCurrentPriceLabel)];
    [self.currentPriceLabel addGestureRecognizer:tapGR];
    
    //国际化
    self.typesOfPrice = @[kLocat(@"limit_price"), kLocat(@"market_price"), ];
    [self.buyButton setTitle:kLocat(@"buy_2") forState:UIControlStateNormal];
    [self.sellButton setTitle:kLocat(@"sell_2") forState:UIControlStateNormal];
    [self.limitButton setTitle:kLocat(@"limit_price") forState:UIControlStateNormal];
    self.currentLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_header_label");
    [self.allButton setTitle:[NSString stringWithFormat:@"  %@", kLocat(@"k_MyassetDetailViewController_tableview_all")] forState:UIControlStateNormal];
    self.pkLabel.text = kLocat(@"k_MyassetDetailViewController_tableview_pankou");
    self.priceLabel.text = kLocat(@"Price");
    self.priceTextField.placeholder = kLocat(@"Price");
    self.numberLabel.text = kLocat(@"Number");
    self.tradeNumNameLabel.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_jye");

}

- (void)_updateUI {
    self.buyButton.selected = self.isTypeOfBuy;
    self.sellButton.selected = !self.isTypeOfBuy;
    self.availableLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocat(@"k_MyassetViewController_tableview_list_cell_middle_avali"), self.availableNumber ?: @"0", self.currencyMark ?: @""];
    
    self.currentPriceLabel.text = self.model.price;
    self.currentPriceLabel.textColor = [self.model statusColor];
    //    self.priceTextField.text = self.model.price;
    self.currentUsdPriceLabel.text = [self.model.price_usd toUsdFormat:self.model.nw_price_unit];
    self.currencyNameLabel.text = self.model.currency_mark ?: @"";
    
    UIColor *currentColor = self.isTypeOfBuy ? kGreenColor : kOrangeColor;
    NSString *buttonTitle = self.isTypeOfBuy ? kLocat(@"buy_2") : kLocat(@"sell_2");
    buttonTitle = [NSString stringWithFormat:@"%@ %@", buttonTitle, self.model.currency_mark ?: @""];
    self.buyOrSellButton.backgroundColor = currentColor;
    [self.buyOrSellButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.stepSlider.sliderCircleColor = currentColor;
    self.stepSlider.tintColor = currentColor;
    self.numberTextField.textColor = currentColor;

}

- (void)_switchTypeOfPrice {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.typesOfPrice enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *aciton = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedTypeOfPrice = obj;
        }];
        [alertController addAction:aciton];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Actions

-(void)receiveRefreshNotification:(NSNotification *)noti {
    self.model  = noti.object;
}


- (void)_stepSliderProgressChangedAction:(StepSlider *)stepSlider {
    CGFloat progress = stepSlider.progress;
    NSString *number = [self.maxNumber resultByMultiplyingByNumber:[NSString stringWithFormat:@"%@", @(progress)]];
    self.isChangeOfNumberByStepSlider = YES;
    if ([number doubleValue] > [self.maxNumber doubleValue]) {
        return;
    }
    self.numberTextField.text = number;
}

- (void)_setTextOfPriceTextFieldToTextOfCurrentPriceLabel {
    [self.priceTextField _animateWithText:self.model.price];
}

- (void)tapButtonWithIsBuy:(BOOL)isbuy {
    if (isbuy) {
        [self tapBuyButtonAction:self.buyButton];
    } else {
        [self tapSellButtonAction:self.sellButton];
    }
}

- (IBAction)tapBuyButtonAction:(UIButton *)sender {
    self.isTypeOfBuy = YES;
}

- (IBAction)tapSellButtonAction:(UIButton *)sender {
    self.isTypeOfBuy = NO;
}

- (IBAction)loginAction:(id)sender {
    [self gotoLoginVC];
}

- (IBAction)plusPriceAction:(id)sender {
    NSString *factor = [self.model.price getAddFactor];
    [self _add:factor textField:self.priceTextField];
}

- (IBAction)minusPriceAction:(id)sender {
    NSString *factor = [self.model.price getMinusFactor];
    [self _add:factor textField:self.priceTextField];
}

- (void)_add:(NSString *)number textField:(UITextField *)textField {
    
    NSString *number1 = number ?: @"0";
    NSString *number2 = textField.text;
    if (textField.text.length == 0) {
        number2 = @"0";
    }
    NSDecimalNumber *textNumber = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *add = [NSDecimalNumber decimalNumberWithString:number1];
    textNumber = [textNumber decimalNumberByAdding:add];
    if (textNumber.doubleValue < 0) {
        return;
    }
    NSMutableString *result = [NSString stringWithFormat:@"%@", textNumber].mutableCopy;
    NSInteger realCount = [result getCountOfDecimal];
    
    NSInteger neededCount = [self.model.price getCountOfDecimal];
    if (realCount == 0 && neededCount!= 0) {
        [result appendString:@"."];
    }
    for (int i= 0; i < neededCount - realCount; i++) {
        [result appendString:@"0"];
    }
    
    textField.text = result.copy;
}


- (IBAction)opreateAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    if ([Utilities isExpired]) {
        [self gotoLoginVC];
        return;
    }
    
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    _price = price;
    _number = number;
    if (price.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_buyPriceCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_sellPriceCannotBeEmpty");
        [self showInfoWithMessage:msg];
        return;
    }
    
    if (number.length == 0) {
        NSString *msg = self.isTypeOfBuy ? kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfBuyingCannotBeEmpty") : kLocat(@"k_YTBuyAndSellDetailTableViewController_TheNumberOfSellingCannotBeEmpty");
        [self showInfoWithMessage:msg];
        return;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    [kKeyWindow addSubview:bgView];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 40 - 12, kStatusBarHeight, 40, 40) title:nil titleColor:kColorFromStr(@"#4C9EE4") font:PFRegularFont(14) titleAlignment:1];
    [bgView addSubview:cancelButton];
    [cancelButton setImage:kImageFromStr(@"jies_icon_yinc") forState:UIControlStateNormal];
    
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview removeFromSuperview];
    }];
    
    
    CGFloat h = 45 + 60*4 *kScreenHeightRatio;
    TPWalletSendKeyboardView *keyBoardView = [[TPWalletSendKeyboardView alloc] initWithFrame:kRectMake(0, kScreenH - h, kScreenW, h)];
    keyBoardView.delegate = self;
    [bgView addSubview:keyBoardView];
    keyBoardView.showPayView = YES;
}

#pragma mark - 密碼键盘回调
-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    if (toSubmit == YES) {
        if (keyboardView.payTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"k_popview_list_counter_pwd_placehoder")];
            return;
        }
        [self submitWeituoWith:keyboardView];
    }
}
-(void)submitWeituoWith:(TPWalletSendKeyboardView *)keyboardView
{
    kShowHud;
    [YTTradeRequest operateTradeWithCurrencyID:self.model.currency_id ?: @"" isTypeOfBuy:self.isTypeOfBuy price:_price number:_number password:keyboardView.payTF.text success:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        
        [kKeyWindow showWarning:obj.message];
        if ([obj succeeded]) {
            [keyboardView.superview removeFromSuperview];
            self.numberTextField.text = nil;
            [self.tableView.mj_header beginRefreshing];
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [kKeyWindow showWarning:error.localizedDescription];
    }];
}


- (IBAction)tapTypeOfPriceAction:(id)sender {
    
    //    [self _switchTypeOfPrice];
}

#pragma mark - Setters & Getters

- (NSString *)currencyMark {
    return self.isTypeOfBuy ? self.model.trade_currency_mark : self.model.currency_mark;
}

- (NSString *)availableNumber {
    return self.isTypeOfBuy ? self.tradeAssetModel.currency_user.num : self.assetModel.currency_user.num;
}

- (YTSellTrendingContaineeViewController *)sellTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[0];
    vc.isTypeOfBuy = NO;
    __weak typeof(self) weakSelf = self;
    vc.didSelectCellBlock = ^(NSString *price) {
        [weakSelf.priceTextField _animateWithText:price];
    };
    return vc;
}

- (YTSellTrendingContaineeViewController *)buyTrendingContaineeVC {
    YTSellTrendingContaineeViewController *vc = self.childViewControllers[1];
    vc.isTypeOfBuy = YES;
    __weak typeof(self) weakSelf = self;
    vc.didSelectCellBlock = ^(NSString *price) {
        [weakSelf.priceTextField _animateWithText:price];
    };
    return vc;
}

- (HBCurrentEntrustContaineeTableViewController *)entrustContaineeVC {
    if (self.childViewControllers.count < 3) {
        return nil;
    }
    if (!_entrustContaineeVC) {
        _entrustContaineeVC = self.childViewControllers[2];
    }
    return _entrustContaineeVC;
}

- (void)setModel:(ListModel *)model {
    if (_model != model) {
        self.priceTextField.text = nil;
    }
    _model = model;
    
    [self _updateUI];
}

- (void)setAssetModel:(YTMyassetDetailModel *)assetModel {
    _assetModel = assetModel;
    
    [self _updateUI];
}

- (void)setTradeAssetModel:(YTMyassetDetailModel *)tradeAssetModel {
    _tradeAssetModel = tradeAssetModel;
    
    [self _updateUI];
}


- (void)setTradeIndexs:(YTTradeIndexModel *)tradeIndexs {
    _tradeIndexs = tradeIndexs;
    self.sellTrendingContaineeVC.models = _tradeIndexs.sell_list;
    self.buyTrendingContaineeVC.models = _tradeIndexs.buy_list;
    
    if (self.priceTextField.text.length == 0) {
        if (self.priceTextField.isFirstResponder) {
            return;
        }
        [self _updatePriceTextField];
    }
}

- (void)_updatePriceTextField {
    NSString *price = !self.isTypeOfBuy ? _tradeIndexs.buy_list.firstObject.price : _tradeIndexs.sell_list.lastObject.price;
    self.priceTextField.text = price;
}

- (void)setIsTypeOfBuy:(BOOL)isTypeOfBuy {
    _isTypeOfBuy = isTypeOfBuy;
    self.numberTextField.text = nil;
    self.tradeNumLabel.text = @"--";
    [self _updateUI];
    [self _updatePriceTextField];
}

- (void)setSelectedTypeOfPrice:(NSString *)selectedTypeOfPrice {
    _selectedTypeOfPrice = selectedTypeOfPrice;
    
    [self.limitButton setTitle:selectedTypeOfPrice forState:UIControlStateNormal];
    BOOL needHide = [selectedTypeOfPrice isEqualToString:self.typesOfPrice.lastObject];
    [self.myPriceContainerViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = needHide;
    }];
}

- (void)setMaxNumber:(NSString *)maxNumber {
    _maxNumber = maxNumber;
    [self _updateMaxNumberLabel];
}

- (void)_updateMaxNumberLabel {
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@ %@", self.maxNumber ?: @"0", self.model.currency_mark ?: @""];
}


#pragma mark - UITextFieldDelegate

- (void)_textFieldDidChangeWithNotification:(NSNotification *)notification {
    [self _textFieldDidChange:notification.object];
}

- (void)_textFieldDidChange:(UITextField *)textField {
    if ([textField isEqual:self.priceTextField]) {
        [self _updateMyCurrentPriceLabel];
        [self _calculateMaxNumberOfMyBalance];
    }
    
    if ([textField isEqual:self.priceTextField] || [textField isEqual:self.numberTextField]) {
        [self _calculateTotalPriceOfTrade];
    }
    
    if ([textField isEqual:self.numberTextField]) {
        if (self.isChangeOfNumberByStepSlider) {
            self.isChangeOfNumberByStepSlider = NO;
            return;
        }
        [self _calculateProgressOfStepSlider];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.numberTextField]) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = 6;//小数点后需要限制的个数
        for (int i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
    }
    
    return YES;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UITextField class]]) {
        [self _textFieldDidChange:object];
    }
    
    if ([object isEqual:self.availableLabel]) {
        [self _calculateMaxNumberOfMyBalance];
    }
}

#pragma mark - Calculate


/**
 计算 滑动条进度值
 */
- (void)_calculateProgressOfStepSlider {
    NSString *number = self.numberTextField.text;
    if (number.length == 0) {
        return;
    }
    
    if ([number doubleValue] > [self.maxNumber doubleValue]) {
        [self showInfoWithMessage:kLocat(@"Insufficient balance")];
        return;
    }
    
    CGFloat progress = [[number resultByDividingByNumber:self.maxNumber] floatValue];
    [self.stepSlider setProgress:progress animated:YES];
}


/**
 计算 最大可买数量
 */
- (void)_calculateMaxNumberOfMyBalance {
    NSString *price = self.priceTextField.text;
    
    if (price.length > 0) {
//        NSString *factorString = [self.model getFeeFactorStringByIsBuy:self.isTypeOfBuy];
        NSString *maxNumber = nil;
        if (self.isTypeOfBuy) {
//            NSString *priceOfHasFee = [price resultByMultiplyingByNumber:factorString];
            maxNumber = [self.availableNumber resultByDividingByNumber:price];
        } else {
            maxNumber = self.availableNumber;
        }
        maxNumber = [maxNumber rouningDownByScale:6];//截取小数点后6位，使用 rouning Down 方式如：0.0001116 -> 0.000111
        self.maxNumber = maxNumber;
    }
}


/**
 计算 交易额
 */
- (void)_calculateTotalPriceOfTrade {
    NSString *price = self.priceTextField.text;
    NSString *number = self.numberTextField.text;
    
    if (price.length > 0 && number.length > 0) {
        NSString *tradeNum = [price resultByMultiplyingByNumber:number];
        self.tradeNumLabel.text = [NSString stringWithFormat:@"%@ %@", tradeNum, self.model.trade_currency_mark];
    }
}


/**
 计算 当前选择的币种价格 ≈ 多少 CNY
 */
- (void)_updateMyCurrentPriceLabel {
    NSString *text = self.priceTextField.text;
    text = [text resultByDividingByNumber:self.model.price];
    NSString *price = [text resultByMultiplyingByNumber:self.model.price_usd];
    self.myCurrentPriceLabel.text = [price toUsdFormat:self.model.nw_price_unit];
}


@end
