//
//  TPWalletExchangeController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletExchangeController.h"
#import "TPWalletExchangeRateCell.h"
#import "TPWalletExchangeInputCell.h"
#import "TPWalletExchangeChooseCell.h"
#import "TPWalletExchangeRecordController.h"
#import "NSString+ZYMoney.h"

CGFloat PickViewHeight = (198+45);


@interface TPWalletExchangeController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)UIButton *confirmButton;

@property(nonatomic,strong)NSArray *fromArray;
@property(nonatomic,strong)NSArray *toArray;

@property(nonatomic,strong)NSMutableDictionary *fromPriceDic;
@property(nonatomic,strong)NSMutableDictionary *toPriceDic;


@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger fromIndex;
@property(nonatomic,assign)NSInteger toIndex;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;



@property(nonatomic,strong)UITextField *fromName;
@property(nonatomic,strong)UITextField *fromVolume;
@property(nonatomic,strong)UITextField *toName;
@property(nonatomic,strong)UITextField *toVolume;



@end

@implementation TPWalletExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fromPriceDic = [NSMutableDictionary new];
    _toPriceDic = [NSMutableDictionary new];
    _selectedIndex = 100;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self manager];

    [self loadTradeList];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI
{
    self.navigationItem.title = @"換幣";
    
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletExchangeRateCell" bundle:nil] forCellReuseIdentifier:@"TPWalletExchangeRateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletExchangeInputCell" bundle:nil] forCellReuseIdentifier:@"TPWalletExchangeInputCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletExchangeChooseCell" bundle:nil] forCellReuseIdentifier:@"TPWalletExchangeChooseCell"];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 16 + 45)];
    footerView.backgroundColor = k111419Color;
    _tableView.tableFooterView = footerView;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:kRectMake(12, 16, kScreenW - 24, 45) title:@"確定" titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footerView addSubview:sendButton];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#11b1ed")] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#434A5D")] forState:UIControlStateDisabled];
    [sendButton setTitleColor:kColorFromStr(@"#8E95A7") forState:UIControlStateDisabled];
    [sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sendButton.enabled = NO;
    kViewBorderRadius(sendButton, sendButton.height/2.0, 0, kRedColor);
    [sendButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
    sendButton.hidden = YES;
    _confirmButton = sendButton;
    
    
    [self setupNavi];
}

-(void)setupNavi
{
    UIButton *rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    [rightbBarButton setTitle:@"換幣記錄" forState:(UIControlStateNormal)];
    [rightbBarButton setTitleColor:kColorFromStr(@"#4C9EE4") forState:(UIControlStateNormal)];
    rightbBarButton.titleLabel.font = PFRegularFont(14);
    __weak typeof(self)weakSelf = self;
    [rightbBarButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
       //换币记录
        kNavPushSafe([TPWalletExchangeRecordController new]);

    }];
    
    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbBarButton];
}

-(void)loadTradeList
{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Exchange/line"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {

        if (success) {
            _fromArray = [responseObj ksObjectForKey:kData][@"from"];
            _toArray = [responseObj ksObjectForKey:kData][@"to"];
            /**
             "fee":"0",
             "currency_id":"30",
             "currency_name":"BCB",
             "currency_logo":"https://xinlianqianbao-sh.oss-cn-shanghai.aliyuncs.com/currency_logo/2018-07-31/14ec4fd1bb8d2e20.png"
             */
            [self loadCurrencyPriceWith:_fromArray[0][@"currency_id"] to:_toArray[0][@"currency_id"]];
            _confirmButton.hidden = NO;
        }else{
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            if (code == 10100) {
                [self gotoLoginVC];
            }
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
            
            
            
            _fromPriceDic[from] = ConvertToString([responseObj ksObjectForKey:kData][@"from"][@"cny"]);
            _toPriceDic[to] = ConvertToString([responseObj ksObjectForKey:kData][@"to"][@"cny"]);
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fromArray == nil) {
        return 0;
    }
    if (section == 1) {
        return 1;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            static NSString *rid = @"TPWalletExchangeChooseCell";
            TPWalletExchangeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.title.text = @"出賬幣種";
            cell.tf.userInteractionEnabled = NO;
            _fromName = cell.tf;
//            if (_selectedIndex > 40) {
//                cell.tf.text = _fromArray[0][@""];
//            }else{
//
//            }
            cell.tf.text = _fromArray[_fromIndex][@"currency_name"];
            
            return cell;
            
        }else{
            static NSString *rid = @"TPWalletExchangeInputCell";
            TPWalletExchangeInputCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.avaLabel.hidden = NO;
            cell.title.text = @"發送數量";
            cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
            cell.avaLabel.text = [NSString stringWithFormat:@"可用（%@%@）",_fromArray[_fromIndex][@"num"],_fromArray[_fromIndex][@"currency_name"]];
            
            cell.tf.delegate = self;
            _fromVolume = cell.tf;
            return cell;
        }
        
    }else if (indexPath.section == 1){
        static NSString *rid = @"TPWalletExchangeRateCell";
        TPWalletExchangeRateCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.leftNameLabel.text = [NSString stringWithFormat:@"%@/CNY",_fromArray[_fromIndex][@"currency_name"]];
        cell.rightNameLabel.text = [NSString stringWithFormat:@"%@/CNY",_toArray[_toIndex][@"currency_name"]];
//        cell.leftPriceLabel.text = [NSString stringChangeMoneyWithStr:model.cny_total numberStyle:NSNumberFormatterDecimalStyle];
        cell.leftPriceLabel.text = _fromPriceDic[_fromArray[_fromIndex][@"currency_id"]];
        cell.rightPriceLabel.text = _toPriceDic[_toArray[_toIndex][@"currency_id"]];
        CGFloat res = cell.leftPriceLabel.text.doubleValue / cell.rightPriceLabel.text.doubleValue;
        
        cell.exchangeInfoLabel.text = [NSString stringWithFormat:@"預計兌換：1%@=%.2f%@",_fromArray[_fromIndex][@"currency_name"],res,_toArray[_toIndex][@"currency_name"]];
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            
            static NSString *rid = @"TPWalletExchangeChooseCell";
            TPWalletExchangeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.title.text = @"入賬幣種";
            cell.tf.userInteractionEnabled = NO;
            _toName = cell.tf;
            cell.tf.text = _toArray[_toIndex][@"currency_name"];

            return cell;
        }else{
            static NSString *rid = @"TPWalletExchangeInputCell";
            TPWalletExchangeInputCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            cell.title.text = @"接收數量";
            cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
            _toVolume = cell.tf;
            cell.tf.delegate = self;

            cell.avaLabel.hidden = YES;
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

/**  提交  */
-(void)confirmAction
{
    [self hideKeyBoard];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"from_id"] = _fromArray[_fromIndex][@"currency_id"];
    param[@"to_id"] = _toArray[_toIndex][@"currency_id"];
    param[@"from_num"] = _fromVolume.text;
    param[@"validate"] = _verifyStr;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Exchange/add"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidSendCurrencySuccessKey" object:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                TPWalletExchangeRecordController *vc = [TPWalletExchangeRecordController new];
                vc.killLastVC = YES;
                kNavPush(vc);
            });
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showPickViewWithTag:indexPath.section];
            _selectedIndex = 0;
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 87;
        }else{
            return 138;
        }
    }else if (indexPath.section == 1){
        return 150;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 87;
        }else{
            return 120;
        }
    }
    return 0.01;
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
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


//性别..
-(void)showPickViewWithTag:(NSInteger )tag
{
    self.coverView.hidden = NO;
    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, PickViewHeight)];
    [self.coverView addSubview:bgView];
    bgView.tag = 100;
    
    UIView *titleView = [[UIView alloc]initWithFrame:kRectMake(0, 0 , kScreenW, 45)];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 40, titleView.height)];
    [titleView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColorFromStr(@"#666666") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = PFRegularFont(16);
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton addTarget:self action:@selector(hidePickView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *confirmlButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, titleView.height)];
    [titleView addSubview:confirmlButton];
    confirmlButton.right = kScreenW - kMargin;
    [confirmlButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmlButton setTitleColor:kColorFromStr(@"#4C9EE4") forState:UIControlStateNormal];
    confirmlButton.titleLabel.font = PFRegularFont(16);
    confirmlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmlButton.tag = tag;
    [confirmlButton addTarget:self action:@selector(confirmChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_pickerView) {
        [_pickerView removeAllSubviews];
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
    _pickerView = [[UIPickerView alloc]initWithFrame:kRectMake(0, 45, kScreenW, PickViewHeight - 45)];
    _pickerView.tag = tag;
    _pickerView.backgroundColor = kWhiteColor;
    [bgView addSubview:_pickerView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    //        _addressTF.text = self.bankArray.firstObject.bankname;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.frame = kRectMake(0, kScreenH - PickViewHeight, kScreenW, PickViewHeight);
    }];
    
    
}
-(void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, PickViewHeight);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}
-(void)confirmChooseAction:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, PickViewHeight);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];

    if (button.tag == 0) {
        _fromName.text = _fromArray[_selectedIndex][@"currency_name"];
        _fromIndex = _selectedIndex;
    }else{
        _toName.text = _toArray[_selectedIndex][@"currency_name"];
        _toIndex = _selectedIndex;
    }
    [self loadCurrencyPriceWith:_fromArray[_fromIndex][@"currency_id"] to:_toArray[_toIndex][@"currency_id"]];
}
#pragma mark - 选择器
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        return self.fromArray.count;
    }else{
        return self.toArray.count;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}
#pragma mark - 输入框通知
-(void)textFieldTextDidChange:(NSNotification *)noti
{
    if (noti.object == _fromVolume ) {
        if (_fromVolume.text.doubleValue > [_fromArray[_fromIndex][@"num"]doubleValue]) {
            _fromVolume.text = [NSString stringWithFormat:@"%@",_fromArray[_fromIndex][@"num"]];
        }
        /**  手续费  */
        double fee = [_toArray[_toIndex][@"fee"] doubleValue]/100;
        /**  汇率  */
        double rate = [_fromPriceDic[_fromArray[_fromIndex][@"currency_id"]] doubleValue] / [_toPriceDic[_toArray[_toIndex][@"currency_id"]] doubleValue];
        /**  结果  */
        double res = _fromVolume.text.doubleValue * (1-fee) * rate;
        
        _toVolume.text = [NSString stringWithFormat:@"%.6f",res];
        
        [self handleconfirmButtonStatus];
    }else if (noti.object == _toVolume){
        /**  手续费  */
        double fee = [_toArray[_toIndex][@"fee"] doubleValue]/100;
        /**  汇率  */
        double rate = [_fromPriceDic[_fromArray[_fromIndex][@"currency_id"]] doubleValue] / [_toPriceDic[_toArray[_toIndex][@"currency_id"]] doubleValue];
        /**  结果  */
        double res = _toVolume.text.doubleValue / (rate * (1 - fee));
        /**  最大兑换数量  */
        double max = [_fromArray[_fromIndex][@"num"] doubleValue] * (1-fee) * rate;
        if (res > max) {//接受数量大于可用数量
            _fromVolume.text = [NSString stringWithFormat:@"%@",_fromArray[_fromIndex][@"num"]];
            res = _fromVolume.text.doubleValue * (1-fee) * rate;
            _toVolume.text = [NSString stringWithFormat:@"%.6f",res];
        }else{
            _fromVolume.text = [NSString stringWithFormat:@"%.6f",res];
            
        }
  
        [self handleconfirmButtonStatus];
    }
}
-(void)handleconfirmButtonStatus
{
    if (_fromVolume.text.floatValue > 0 && _toVolume.text.floatValue) {
        _confirmButton.enabled = YES;
    }else{
        _confirmButton.enabled = NO;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = kColorFromStr(@"#E4E4E4");
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = kColorFromStr(@"#E4E4E4");
    
    if (pickerView.tag == 0) {
        UIView *cellView = view;
        if (cellView == nil) {
            cellView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 34)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW/2, 34) text:@"BTC" font:PFRegularFont(16) textColor:k323232Color textAlignment:1 adjustsFont:YES];
            [cellView addSubview:label];
            UILabel *volumeLabel = [[UILabel alloc] initWithFrame:kRectMake(kScreenW/2, 0, kScreenW/2, 34) text:@"BTC" font:PFRegularFont(12) textColor:k323232Color textAlignment:1 adjustsFont:YES];
            
            [cellView addSubview:volumeLabel];
            label.tag = 100;
            volumeLabel.tag = 101;
        }
        for (UILabel *label in cellView.subviews) {
            
            if (label.tag == 100) {
//                label.text = [NSString stringWithFormat:@"%zd",row];
                label.text = self.fromArray[row][@"currency_name"];

            }else{
//                label.text = [NSString stringWithFormat:@"=====%zd",row];
                label.text = [NSString stringWithFormat:@"可用數量：%@",self.fromArray[row][@"num"]];

            }
        }
        return cellView;
    }else{
        UIView *cellView = view;
        if (cellView == nil) {
            cellView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 34)];
            UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 34) text:@"BTC" font:PFRegularFont(16) textColor:k323232Color textAlignment:1 adjustsFont:YES];
            [cellView addSubview:label];
            label.tag = 123;
        }
        for (UILabel *label in cellView.subviews) {
            if (label.tag == 123) {
                label.text = self.toArray[row][@"currency_name"];
            }
        }
        return cellView;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedIndex = row;
}



-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:kScreenBounds];
        [kKeyWindow addSubview:_coverView];
        _coverView.userInteractionEnabled = YES;
        _coverView.hidden = YES;
        _coverView.backgroundColor= [kBlackColor colorWithAlphaComponent:0.36];
    }
    return _coverView;
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
                if (textField == _fromVolume || textField == _toVolume) {
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 6) {
                            return YES;
                        }else{
                            kLOG(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NTESVerifyCodeManager *)manager
{
    if (_manager == nil) {
        // sdk调用
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        
        // 设置透明度
        _manager.alpha = 0;
        
        // 设置frame
        _manager.frame = CGRectNull;
        
        // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaId = kVerifyKey;
        [_manager configureVerifyCode:captchaId timeout:7];
    }
    return _manager;
}

-(void)showVerifyInfo
{
    [self hideKeyBoard];
    
    if (self.manager == nil) {
        [self manager];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.manager openVerifyCodeView:nil];
        });
    }else{
        
        [self.manager openVerifyCodeView:nil];
    }
    
}
#pragma mark - 图形验证码
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        [self confirmAction];
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}


@end
