//
//  XPHuazhuanViewController.m
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPHuazhuanViewController.h"
#import "XPZhuanZhangConfirmView.h"
#import "TPWalletSendKeyboardView.h"
#import "XPZhuanZhangSuccessController.h"

@interface XPHuazhuanViewController ()<TPWalletSendKeyboardViewDelegate,UITextFieldDelegate,NTESVerifyCodeManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tagetLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *aviLabel;

@property (weak, nonatomic) IBOutlet UITextField *volumeTF;

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)NSDictionary *infoDic;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,copy)NSString *phoneCode;
@property(nonatomic,copy)NSString *verifyStr;


@end

@implementation XPHuazhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)loadData
{
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/transfer_xrp/index"] andParam:nil completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _infoDic = [responseObj ksObjectForKey:kData];

            [self setupUI];
        }
    }];
}
-(void)setupUI
{
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    _volumeTF.placeholder = kLocat(@"hz_plzEnterVol");
    _tagetLabel.text = kLocat(@"hz_targetaccount");
//    _volumeLabel.text = kLocat(@"hz_hauzhuanvol");
    
//    _volumeLabel.text = [NSString stringWithFormat:@"%@(%@:%@XRP)",kLocat(@"hz_hauzhuanvol"),kLocat(@"Z_avi"),_infoDic[@"xrpz_num"]];
    _volumeLabel.text = kLocat(@"hz_hauzhuanvol");
    self.title = kLocat(@"hz_XRPhuazhuantitle");
    
    kTextFieldPlaceHoldColor(_volumeTF, k999999Color);
//    _volumeTF.placeholder = @"0";
//    _accountTF.placeholder = @"0";
    
    _tagetLabel.textColor = k222222Color;
    _tagetLabel.font = PFRegularFont(12);
    
    _volumeLabel.textColor = k222222Color;
    _volumeLabel.font = PFRegularFont(12);
    
    _aviLabel.textColor = k666666Color;
    _aviLabel.font = PFRegularFont(12);
    
    _tipsLabel.textColor = kColorFromStr(@"#068998");
    _tipsLabel.font = PFRegularFont(12);
    
    _accountTF.textColor = k222222Color;
    _accountTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_accountTF, k999999Color);
    
    _volumeTF.textColor = k222222Color;
    _volumeTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_volumeTF, k999999Color);
 
    [_actionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _actionButton.titleLabel.font = PFRegularFont(16);
    kViewBorderRadius(_actionButton, 8, 0, kRedColor);
    [_actionButton addShadow];
    _actionButton.backgroundColor = kColorFromStr(@"#6189C5");
    
    [_actionButton setTitle:kLocat(@"R_Submit") forState:UIControlStateNormal];
    
    _accountTF.userInteractionEnabled = NO;
    _accountTF.text = kLocat(@"hz_myxrpaccount");
    _volumeTF.keyboardType = UIKeyboardTypeDecimalPad;
    _tipsLabel.textColor = kColorFromStr(@"#068998");
    _tipsLabel.font = PFRegularFont(12);
    _tipsLabel.text = _infoDic[@"content"];
    _aviLabel.text = [NSString stringWithFormat:@"%@: %@XRP",kLocat(@"Z_avi"),_infoDic[@"xrpz_num"]];
    _volumeTF.delegate = self;
    
    _realLabel.textColor = k666666Color;
    _realLabel.font = PFRegularFont(12);
    _realLabel.text = [NSString stringWithFormat:@"%@: 0 XRP",kLocat(@"s0219_kouchu")];

    
    
}

- (IBAction)submitAction:(id)sender {
//    if (_accountTF.text.length == 0) {
//        [self showTips:kLocat(@"Z_enteraccount")];
//        return;
//    }
    if (_volumeTF.text.length == 0) {
        [self showTips:kLocat(@"hz_plzEnterVol")];
        return;
    }
    if (_volumeTF.text.doubleValue == 0) {
        [self showTips:kLocat(@"hz_volcantbe0")];
        return;
    }
//    double avi = MIN([_infoDic[@"xrp_num"] doubleValue], [_infoDic[@"xrpz_num"] doubleValue]);
    double avi = [_infoDic[@"xrpz_num"] doubleValue];
    double fee = _volumeTF.text.doubleValue * [_infoDic[@"transfer_fee"] doubleValue]/100;

    if (_volumeTF.text.doubleValue + fee > avi) {
        [self showTips:kLocat(@"Z_aviisnotenough")];
        return;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    XPZhuanZhangConfirmView *confirmView = [[[NSBundle mainBundle] loadNibNamed:@"XPZhuanZhangConfirmView" owner:self options:nil] lastObject];
    confirmView.frame = kRectMake(0, kScreenH - 400, kScreenW, 400);
    [bgView addSubview:confirmView];
    confirmView.account.text = kLocat(@"hz_toaccount");
    confirmView.paywayLabel.text = kLocat(@"Z_myasset");
    confirmView.title.text = kLocat(@"hz_confirmhz");
    confirmView.accountLabel.text = kLocat(@"C_community_search_mywallet");
    confirmView.volumeLabel.text = [NSString stringWithFormat:@"%@ %@",_volumeTF.text,@"XRP"];
    confirmView.callBackBlock = ^(UIButton *sureButton) {
        [self confirmAction:sureButton];
    };
    
    confirmView.mingxiLabel.hidden = NO;
    confirmView.mingxiLabel.text = kLocat(@"OTC_order_realcost");
    confirmView.mywalletLabelContent.hidden = NO;
    
//    double fee = _volumeTF.text.doubleValue * [_infoDic[@"transfer_fee"] doubleValue]/100;
    
    NSString *real = [NSString floatOne:ConvertToString(@(fee)) calculationType:CalculationTypeForAdd floatTwo:_volumeTF.text];
    
    confirmView.mywalletLabelContent.text = [NSString stringWithFormat:@"%@XRP",[real rouningDownByScale:6]];
    
    
}

-(void)confirmAction:(UIButton *)button
{
    
    [button.superview.superview removeFromSuperview];
    
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
    _sendButton = keyBoardView.codeButton;
//    [keyBoardView.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];

    keyBoardView.showPayView = YES;
}
-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    
    if (toSubmit == NO) {
        if (keyboardView.codeTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"HBForgetPasswordTableViewController_valcode_placehoder")];
            return;
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"validate"] = _verifyStr;
        param[@"phone_code"] = keyboardView.codeTF.text;
        param[@"code"] = keyboardView.codeTF.text;
        param[@"type"] = @"transfer";
        [kKeyWindow showHUD];
        
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/sms/auto_check"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            [kKeyWindow hideHUD];
            if (success) {
                _phoneCode = keyboardView.codeTF.text;
                
                keyboardView.codeButton.hidden = YES;
                keyboardView.codeTF.hidden = YES;
                keyboardView.payTF.hidden = NO;
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];

        
    }else{
        if (keyboardView.payTF.text.length == 0) {
            [kKeyWindow showWarning:kLocat(@"k_popview_list_counter_pwd_placehoder")];
            return;
        }
        [self huaZhuanAction:keyboardView];
    }
}

-(void)huaZhuanAction:(TPWalletSendKeyboardView *)keyboardView
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"pwd"] = keyboardView.payTF.text;
    param[@"num"] =_volumeTF.text;
    param[@"phone_code"] = _phoneCode;

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/transfer_xrp/payment"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kLOG(@"操作成功");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshXPXRPAssetViewControllerKey" object:nil];
            
            [keyboardView.superview removeFromSuperview];
            XPZhuanZhangSuccessController *vc = [XPZhuanZhangSuccessController new];
            vc.vol = _volumeTF.text;
            vc.isHuaZhuan = YES;
            kNavPush(vc);
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
 
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
                        if (range.location - ran.location <= 3) {
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

-(void)txtFieldDidChange:(NSNotification *)noti
{
    if (noti.object == _volumeTF) {
        

        float max = [_infoDic[@"xrpz_num"] floatValue];

        if (_volumeTF.text.doubleValue > max) {
            _volumeTF.text = ConvertToString(@(max));
        }
        
        double fee = _volumeTF.text.doubleValue * [_infoDic[@"transfer_fee"] doubleValue]/100;
        
        
        if (_volumeTF.text.length == 0) {
            _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),@"0"];
        }else{
            _realLabel.text = [ConvertToString(@(fee)) rouningDownByScale:6];
            
            _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),_realLabel.text];
        }
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        [self sendCodeAction:nil];
        
    }else{
        _verifyStr = @"";
        [self showTips:kLocat(@"OTC_buylist_codeerror")];
    }
}

-(void)sendCodeAction:(UIButton *)button
{
    [self hideKeyBoard];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _verifyStr;
    param[@"type"] = @"transfer";
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
- (NTESVerifyCodeManager *)manager {
    if (!_manager) {
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
