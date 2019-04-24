
//
//  TPWalletSendController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendController.h"
#import "TPWalletVolumeCell.h"
#import "TPWalletSendMidCell.h"
#import "TPWalletAddreddListController.h"
#import "TPWalletSendRemarkCell.h"
#import "TPWalletSendKeyboardView.h"


@interface TPWalletSendController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TPWalletSendKeyboardViewDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITextField *volumeTF;
@property(nonatomic,strong)UITextField *addressTF;
@property(nonatomic,strong)UITextField *tagTF;
@property(nonatomic,strong)UIButton *saveButton;
@property(nonatomic,strong)IQTextView *remarkTV;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *realLabel;
@property(nonatomic,strong)UIButton *bottomButton;

@property(nonatomic,strong)NSDictionary *currencyInfo;
@property(nonatomic,strong)UILabel *cnyLabel;


@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,assign)NSInteger second;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIButton *sendButton;
/**  最大可提币数量  */
@property(nonatomic,assign)double maxVolume;

@property(nonatomic,strong)UITextField *xrpTagTF;





@property(nonatomic,assign)BOOL isfirst;

@property(nonatomic,assign)BOOL isXRP;
@property(nonatomic,assign)BOOL isEOS;



@end

@implementation TPWalletSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_model.currency_mark containsString:@"XRP"]) {
        _isXRP = YES;
    }else if ([_model.currency_mark containsString:@"EOS"]) {
        _isEOS = YES;
    }
    
    _second = 60;
    [self setupUI];
    [self loadCurrencyInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    [self manager];
    [self createCurrencyAddress];
}
/**  创建钱包  */
-(void)createCurrencyAddress
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _model.currency_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/createWalletAddress"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
-(void)setupUI
{
    self.navigationItem.title = kLocat(@"W_Send");
    
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

    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletVolumeCell" bundle:nil] forCellReuseIdentifier:@"TPWalletVolumeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletSendMidCell" bundle:nil] forCellReuseIdentifier:@"TPWalletSendMidCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPCommonListCell" bundle:nil] forCellReuseIdentifier:@"TPCommonListCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPWalletSendRemarkCell" bundle:nil] forCellReuseIdentifier:@"TPWalletSendRemarkCell"];

    
    UIView *footerView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 84 + 45)];
    footerView.backgroundColor = kWhiteColor;
    _tableView.tableFooterView = footerView;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:kRectMake(12, 70, kScreenW - 24, 45) title:kLocat(@"W_Send") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footerView addSubview:sendButton];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#6189C5")] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kColorFromStr(@"#93A3B6")] forState:UIControlStateDisabled];
    [sendButton setTitleColor:kColorFromStr(@"#C0CFE0") forState:UIControlStateDisabled];
    [sendButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sendButton.enabled = NO;

    _bottomButton = sendButton;
    kViewBorderRadius(sendButton,8, 0, kRedColor);
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextView *tv = [[UITextView alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24, 55)];
    tv.textColor = kColorFromStr(@"#E1545A");
    tv.font = PFRegularFont(12);
    if (_isXRP) {
        tv.text = kLocat(@"M_XRPSendtips");
    }else if (_isEOS) {
        tv.text = kLocat(@"M_XRPSendtips_EOS");
    }else{
        tv.text = [kLocat(@"W_SendTipsComfirm") stringByReplacingOccurrencesOfString:@"USDT" withString:_model.currency_mark];
    }
//    tv.text = [NSString stringWithFormat:@"*請確認您正在發送到壹個%@地址，發送到其他類型的地址將會造成資產永久丟失",_model.currency_name];
    [footerView addSubview:tv];
    
    tv.backgroundColor = kClearColor;
    tv.editable = NO;

    [self addRightBarButtonWithFirstImage:kImageFromStr(@"poc_icon_funk") action:@selector(rightItemAction)];
    
}
-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];

    // 设置透明度
    self.manager.alpha = 0;
    
    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
    
}
-(void)showVerifyInfo
{
    [self hideKeyBoard];
    if (self.manager == nil) {
        [self initVerifyConfigure];
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
        
        if (_isfirst) {
            [self bgView];
            [self sendCodeAction:nil];
            _isfirst = NO;
        }else{
            [self sendCodeAction:nil];
            _isfirst = NO;
        }
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}
-(void)loadCurrencyInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _model.currency_id;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/getCurrencyUser"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _currencyInfo = [responseObj ksObjectForKey:kData];
            /**
             cny = "23489967.74";
             "currency_all_tibi" = "1.0000";
             "currency_mark" = BTC;
             "currency_min_tibi" = "0.0001";
             "currency_name" = "\U6bd4\U7279\U5e01";
             num = "1000.000000";
             "tcoin_fee" = 9;
             */
            
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;

    if (indexPath.section == 0) {
        static NSString *rid = @"TPWalletVolumeCell";
        TPWalletVolumeCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.tf.keyboardType = UIKeyboardTypeDecimalPad;
        cell.tf.delegate = self;
        cell.nameLabel.text = _model.currency_mark;
        if (_currencyInfo) {
 
            if ([_currencyInfo[@"day_limit"] doubleValue] < 0) {//不限制
                cell.avaLabel.text = [NSString stringWithFormat:@"%@(%@%@)",kLocat(@"W_currentAvi"),_currencyInfo[@"num"],_model.currency_mark];
                
            }else{//限制
                cell.avaLabel.text = [NSString stringWithFormat:@"%@(%@%@)",kLocat(@"W_currentAvi"),_currencyInfo[@"num"],_model.currency_mark];

                
            }

//            cell.maxVolumeLabel.text = [NSString stringWithFormat:@"%@%@",kLocat(@"W_Highest"),_currencyInfo[@"currency_all_tibi"]];
            
           cell.maxVolumeLabel.text = [NSString stringWithFormat:@"(%@ %@ %@)",kLocat(@"W_HighestSendVol"),_currencyInfo[@"currency_all_tibi"],_model.currency_mark];
            
            cell.tf.placeholder = [NSString stringWithFormat:@"%@%@",kLocat(@"W_Lowest"),_currencyInfo[@"currency_min_tibi"]];
            cell.avaLabel.hidden = NO;
            cell.cnyLabel.text = [NSString stringWithFormat:@"≈%@0.00",_currencyInfo[@"new_price_unit"]];

        }else{
            cell.avaLabel.hidden = YES;
        }
        
        
        _volumeTF = cell.tf;
        _cnyLabel = cell.cnyLabel;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *rid = @"TPWalletSendMidCell";
        TPWalletSendMidCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.addTF.keyboardType = UIKeyboardTypeASCIICapable;        
        [cell.addressButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            TPWalletAddreddListController *vc = [TPWalletAddreddListController new];
            vc.callBackBlock = ^(NSDictionary *dic) {
                weakSelf.addressTF.text = dic[@"qianbao_url"];
                weakSelf.tagTF.text = dic[@"names"];
                if (weakSelf.isXRP || weakSelf.isEOS) {
                    weakSelf.xrpTagTF.text = ConvertToString(dic[@"tag"]);
                }
                
                [weakSelf checkSubmitButtonStatus];
                
            };
            if ([weakSelf.model.currency_mark containsString:@"XRP"]) {
                vc.isXrp = YES;
            }
            if ([weakSelf.model.currency_mark containsString:@"EOS"]) {
                vc.isEOS = YES;
            }
            
            vc.currencyID = weakSelf.model.currency_id;
            kNavPushSafe(vc);
        }];
        
        
        if (_isXRP) {
            cell.isXRP = YES;
            _xrpTagTF = cell.xrpTF;
        }
        if (_isEOS) {
            cell.isEOS = YES;
            _xrpTagTF = cell.xrpTF;
        }
        
//        if ([_model.currency_mark containsString:@"XRP"] ) {
//            cell.isXRP = YES;
//            _xrpTagTF = cell.xrpTF;
//        }
        
        if (_addressStr) {
            cell.addTF.text = _addressStr;
        }
        _addressTF = cell.addTF;
        _tagTF = cell.tagTF;
        _saveButton = cell.saveButton;
        [_saveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                weakSelf.tagTF.placeholder = kLocat(@"s0127_namerequired");
            }else{
                weakSelf.tagTF.placeholder = kLocat(@"s0115_nameoptioinal");
            }
        }];
        
        return cell;
    }else if(indexPath.section == 2){
        
        static NSString *rid = @"TPCommonListCell";
        TPCommonListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.itemLabel.text = kLocat(@"OTC_order_realcost");
        cell.infoLabel.text = @"0.000000";
        _realLabel = cell.infoLabel;
        return cell;
    }else{
        static NSString *rid = @"TPWalletSendRemarkCell";
        TPWalletSendRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        _remarkTV = cell.remarkTV;
        
        return cell;
    }
}
#pragma mark - 发送按钮点击事件
-(void)sendAction
{
    [self hideKeyBoard];
    
//    double left = [_currencyInfo[@"currency_all_tibi"] doubleValue];

//    if (left > 0) {
//        if (_volumeTF.text.doubleValue > left) {
//            [self showTips:[NSString stringWithFormat:@"%@%@",kLocat(@"W_todaycantransferVol"),_currencyInfo[@"currency_all_tibi"]]];
//            return;
//        }
//    }
    if (_saveButton.selected == YES && _tagTF.text.length == 0) {
        [self showTips:kLocat(@"W_plzenteraddresstag")];
        return;
    }
    
    
//    if (_isXRP && _xrpTagTF.text.length == 0) {
//        [self showTips:@"請輸入地址標識"];
//        return;
//    }
    
    //提币第一步，验证信息
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"address"] = _addressTF.text;
    param[@"currency_id"] = _model.currency_id;
    param[@"money"] = _volumeTF.text;
    if (_remarkTV.text.length > 0) {
        param[@"remark"] = _remarkTV.text;
    }
    
    if (_isXRP || _isEOS) {
        param[@"tag"] = _xrpTagTF.text;
    }
    
    
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/validateTakeCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _isfirst = YES;
            [self showVerifyInfo];
            
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            NSInteger code = [[responseObj ksObjectForKey:kCode]integerValue];
            if (code == 10100) {
//                [self gotoLoginVC];
            }
        }
    }];
}



#pragma mark - 转出提币

-(void)rightItemAction
{
    __weak typeof(self)weakSelf = self;
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        weakSelf.addressTF.text = scannedStr;
        [weakSelf checkSubmitButtonStatus];
    };
    
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
    
}

-(void)checkSubmitButtonStatus
{
//    if (_realLabel.text.doubleValue > 0 && _addressTF.text.length > 0 && _tagTF.text.length > 0) {
    
        if (_realLabel.text.doubleValue > 0 && _addressTF.text.length > 0 ) {

        if (_isXRP || _isEOS) {
            if (_xrpTagTF && _xrpTagTF.text.length > 0 ) {
//                if ([_currencyInfo[@"num"]doubleValue] >= _realLabel.text.doubleValue) {
                    _bottomButton.enabled = YES;
//                }else{
//                    _bottomButton.enabled = NO;
//                }
            }else{
                _bottomButton.enabled = NO;
            }
        }else{
//            if ([_currencyInfo[@"num"]doubleValue] >= _realLabel.text.doubleValue) {
                _bottomButton.enabled = YES;
//            }else{
//                _bottomButton.enabled = NO;
//            }
        }
    }else{
        _bottomButton.enabled = NO;
    }
}

#pragma mark - 点击键盘上的确定按钮
-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    if (toSubmit == NO) {//短信验证
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"validate"] = _verifyStr;
        param[@"phone_code"] = keyboardView.codeTF.text;
        param[@"type"] = @"tcoin";
        [kKeyWindow showHUD];
        
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/validateSmsCode"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            [kKeyWindow hideHUD];
            if (success) {
                keyboardView.codeButton.hidden = YES;
                keyboardView.codeTF.hidden = YES;
                keyboardView.payTF.hidden = NO;
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];

    }else{//提交
        if (keyboardView.payTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"LEnterTransactionPWD")];
            return;
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"currency_id"] = _model.currency_id;
        param[@"address"] = _addressTF.text;
        param[@"money"] = _volumeTF.text;
        if (_remarkTV.text.length > 0) {
            param[@"remark"] = _remarkTV.text;
        }
        
        
        if (_isXRP || _isEOS) {
            param[@"tag"] = _xrpTagTF.text;
        }
        param[@"names"] = _tagTF.text;
  
        if (_saveButton.selected) {
            param[@"checkbox"] = @"2";
        }
        
//        param[@"validate"] = _verifyStr;
        param[@"paypwd"] = keyboardView.payTF.text;
//        param[@"phone_code"] = keyboardView.codeTF.text;
        __weak typeof(self)weakSelf = self;

        [kKeyWindow showHUD];
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/submitTakeCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            [kKeyWindow hideHUD];
            if (success) {
                [weakSelf.bgView removeFromSuperview];
                weakSelf.bgView = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidSendCurrencySuccessKey" object:nil];
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 145;
    }else if (indexPath.section == 1){
        
        if (_isXRP || _isEOS) {
            return 160 + 46;
        }
        
        return 160;
    }else if(indexPath.section == 2){
        return 45;
    }else{
        return 160;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0.01;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark - 输入框通知
-(void)textFieldTextDidChange:(NSNotification *)noti
{
    if (noti.object == _volumeTF) {

//        double left = [_currencyInfo[@"day_limit"] doubleValue];

//        if (_volumeTF.text.doubleValue <= [_currencyInfo[@"min_limit"] doubleValue]) {
//            _volumeTF.text = ConvertToString(_currencyInfo[@"min_limit"]);
//        }else if (_volumeTF.text.doubleValue >= [_currencyInfo[@"max_limit"] doubleValue]){
//            _volumeTF.text = ConvertToString(_currencyInfo[@"max_limit"]);
//        }
//
//        if (_volumeTF.text.floatValue > [_currencyInfo[@"user_num"] doubleValue]) {
//            _volumeTF.text = ConvertToString(_currencyInfo[@"user_num"]);
//        }
        
        double real = 0;
//        if ([_currencyInfo[@"type"]intValue] == 0) {//百分比
        
            real = (1 + [_currencyInfo[@"tcoin_fee"] doubleValue]/100)*_volumeTF.text.doubleValue;
//            real = (1 - [_currencyInfo[@"tcoin_fee"] doubleValue]/100)*_volumeTF.text.doubleValue;
        _realLabel.text = [NSString stringWithFormat:@"%@",@(real)];
        _realLabel.text = [_realLabel.text rouningDownByScale:6];
//        }else{//固定
//            real = _volumeTF.text.doubleValue + [_currencyInfo[@"tcoin_fee"] doubleValue];
//
//            if (real > 0) {
//                _realLabel.text = [NSString stringWithFormat:@"%.6f",real];
//            }else{
//                _realLabel.text = @"0.000000";
//            }
//        }

        
        float cny = _volumeTF.text.doubleValue * [_currencyInfo[@"cny"] doubleValue];
        _cnyLabel.text = [NSString stringWithFormat:@"≈%@%.2f",_currencyInfo[@"new_price_unit"],cny];

        [self checkSubmitButtonStatus];
        
    }else if (noti.object == _addressTF || noti.object == _tagTF){
        [self checkSubmitButtonStatus];
    }
    [self checkSubmitButtonStatus];

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_volumeTF == textField) {
        
        if (_volumeTF.text.length > 0) {
            
            if (_volumeTF.text.doubleValue < [_currencyInfo[@"currency_min_tibi"] doubleValue]) {
//                _volumeTF.text = ConvertToString(_currencyInfo[@"currency_min_tibi"]);
                [self showTips:[NSString stringWithFormat:@"%@%@",kLocat(@"s0118_OTCSendMIN"),_currencyInfo[@"currency_min_tibi"]]];
                
            }
//            else if (_volumeTF.text.doubleValue >= [_currencyInfo[@"currency_all_tibi"] doubleValue]){
//                _volumeTF.text = ConvertToString(_currencyInfo[@"currency_all_tibi"]);
//            }
            
//            if (_volumeTF.text.floatValue > [_currencyInfo[@"user_num"] doubleValue]) {
//                _volumeTF.text = ConvertToString(_currencyInfo[@"user_num"]);
//            }
        }else{
            _volumeTF.text = nil;
        }
    
 
        
        
        double real = 0;
//        if ([_currencyInfo[@"type"]intValue] == 0) {//百分比
//            real =  (1 - [_currencyInfo[@"tcoin_fee"] doubleValue]/100)*_volumeTF.text.doubleValue;
            real =  (1 + [_currencyInfo[@"tcoin_fee"] doubleValue]/100)*_volumeTF.text.doubleValue;
        

            _realLabel.text = [NSString stringWithFormat:@"%@",@(real)];
        _realLabel.text = [_realLabel.text rouningDownByScale:6];
        
        
//        }else{//固定
//            real = _volumeTF.text.doubleValue + [_currencyInfo[@"tcoin_fee"] doubleValue];
//
//            if (real > 0) {
//                _realLabel.text = [NSString stringWithFormat:@"%.6f",real];
//            }else{
//                _realLabel.text = @"0.000000";
//            }
//        }
        
        float cny = _volumeTF.text.doubleValue * [_currencyInfo[@"cny"] doubleValue];
        _cnyLabel.text = [NSString stringWithFormat:@"≈%@%.2f",_currencyInfo[@"new_price_unit"],cny];
        
        [self checkSubmitButtonStatus];

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
                if (textField == _volumeTF) {
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
                    if (isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            kLOG(@"最多两位小数");
                            return NO;
                        }
                    }else{
                        return YES;
                    }
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

-(UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:kScreenBounds];
        [kKeyWindow addSubview:_bgView];
        _bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 40 - 12, kStatusBarHeight, 40, 40) title:nil titleColor:kColorFromStr(@"#4C9EE4") font:PFRegularFont(14) titleAlignment:1];
        [_bgView addSubview:cancelButton];
        [cancelButton setImage:kImageFromStr(@"jies_icon_yinc") forState:UIControlStateNormal];

        __weak typeof(self)weakSelf = self;
        [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
            [weakSelf.bgView removeFromSuperview];
            weakSelf.bgView = nil;
        }];
        
        
        
        CGFloat h = 45 + 60*4 *kScreenHeightRatio;
        TPWalletSendKeyboardView *keyBoardView = [[TPWalletSendKeyboardView alloc] initWithFrame:kRectMake(0, kScreenH - h, kScreenW, h)];
        keyBoardView.delegate = self;
        [_bgView addSubview:keyBoardView];
        [keyBoardView.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
        _sendButton = keyBoardView.codeButton;
    }
    return _bgView;
}
-(void)sendCodeAction:(UIButton *)button
{
    [self hideKeyBoard];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _verifyStr;
    param[@"type"] = @"tcoin";
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Sms/auto_send"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            [kKeyWindow showWarning:kLocat(@"LCodeSendSuccess")];
            [self.sendButton startTimeWithDuration:60];

        }else{
            [self.sendButton startTimeWithDuration:1];

        }
        [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        
    }];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

-(NTESVerifyCodeManager *)manager
{
    if (_manager == nil) {
        // sdk调用
        _manager = [NTESVerifyCodeManager sharedInstance];
        _manager.delegate = self;
        _manager.lang = [Utilities getLangguageForNTESVerifyCode];

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

@end
