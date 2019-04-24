//
//  HBLoginTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBLoginTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "HBLoginRequest.h"
#import "NSObject+SVProgressHUD.h"
#import "HBRegisterTableViewController.h"
#import "TPWalletSendKeyboardView.h"

@interface HBLoginTableViewController ()<NTESVerifyCodeManagerDelegate,TPWalletSendKeyboardViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *canbtn;
//取消
@property (weak, nonatomic) IBOutlet UILabel *LoginDes;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UILabel *regisDes;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *langButton;

@property(nonatomic,copy)NSString *msgCode;

@property(nonatomic,copy)NSString *validate;

@property(nonatomic,copy)NSString *codeValidate;


@property(nonatomic,strong)UIButton *sendButton;

@property(nonatomic,assign)BOOL isForCode;

@property(nonatomic,strong)TPWalletSendKeyboardView *keyboardView;

@property(nonatomic,assign)BOOL isPhone;



@end

@implementation HBLoginTableViewController

+ (instancetype)fromStoryboard {
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.phoneTextField _changeClearButton];
    [self.passwordTextField _changeClearButton];
    self.phoneTextField.placeholder = kLocat(@"R_EMailOrPhone");
    self.passwordTextField.placeholder = kLocat(@"HBLoginTableViewController_password_placehoder");
    [self.phoneTextField setValue:kColorFromStr(@"#37415C") forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:kColorFromStr(@"#37415C") forKeyPath:@"_placeholderLabel.textColor"];
    [self.canbtn setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    self.LoginDes.text = kLocat(@"HBLoginTableViewController_des");
 
    [self.loginBtn setTitle:kLocat(@"HBLoginTableViewController_password_login") forState:UIControlStateNormal];
     [self.forgetBtn setTitle:kLocat(@"HBLoginTableViewController_password_forgetpwd") forState:UIControlStateNormal];
    self.regisDes.text = kLocat(@"HBLoginTableViewController_password_regisDes");
    [self.regisBtn setTitle:kLocat(@"HBLoginTableViewController_password_regis") forState:UIControlStateNormal];
    

    if ([kUserDefaults objectForKey:@"kUserLoginAccountKey"]) {
        self.phoneTextField.text = [kUserDefaults objectForKey:@"kUserLoginAccountKey"];
    }
    if ([_phoneTextField.text isEqualToString:@"13590245424"]) {
        _passwordTextField.text = @"a1111111";
    }
    

    
    _LoginDes.textColor = k666666Color;
    _LoginDes.font = PFRegularFont(16);
    
    kViewBorderRadius(_loginBtn, 8, 0, kRedColor);
    _loginBtn.backgroundColor = kColorFromStr(@"#6189C5");
    _loginBtn.titleLabel.font = PFRegularFont(16);
    [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    [_forgetBtn setTitleColor:kColorFromStr(@"6189C5") forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = PFRegularFont(14);
    
    _regisDes.textColor = k666666Color;
    _regisDes.font = PFRegularFont(16);
    
    _regisBtn.titleLabel.font = PFRegularFont(16);
    [_regisBtn setTitleColor:kColorFromStr(@"6189C5") forState:UIControlStateNormal];
    
    kTextFieldPlaceHoldColor(_phoneTextField, k999999Color);
    kTextFieldPlaceHoldColor(_passwordTextField, k999999Color);
    _phoneTextField.textColor = k666666Color;
    _phoneTextField.font = PFRegularFont(16);
    _passwordTextField.textColor = k666666Color;
    _passwordTextField.font = PFRegularFont(16);

//    self.canbtn.hidden = NO;
    
    _langButton.titleLabel.font = PFRegularFont(14);
    NSString *currenLan = [LocalizableLanguageManager userLanguage];
    if ([currenLan containsString:@"en"]) {
        [_langButton setTitle:@"繁体中文" forState:UIControlStateNormal];
    }else{
        [_langButton setTitle:@"English" forState:UIControlStateNormal];
    }
    [_langButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [kUserDefaults setInteger:1 forKey:@"kToLoginOrRegisterKey"];

        if ([currenLan containsString:@"en"]) {
            
            [kUserDefaults setInteger:1 forKey:@"kToLoginOrRegisterKey"];
            
            [kUserDefaults setBool:YES forKey:@"isTradition"];
            [LocalizableLanguageManager setUserlanguage:CHINESETradition];
        }else{
            [kUserDefaults setBool:NO forKey:@"isTradition"];
            [LocalizableLanguageManager setUserlanguage:ENGLISH];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self configurateVerifyManager];
}
-(void)configurateVerifyManager
{
    // sdk调用
    _manager = [NTESVerifyCodeManager sharedInstance];
    _manager.delegate = self;
    
    // 设置透明度
    _manager.alpha = 0;
    // 设置frame
    _manager.frame = CGRectNull;
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [_manager configureVerifyCode:captchaId timeout:7];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Private


-(void)showVerifyInfo
{
    if (self.phoneTextField.text.length == 0 ) {
        [self.phoneTextField becomeFirstResponder];
        [self showInfoWithMessage:kLocat(@"LEnterPhoneNumberOrEmail")];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self.passwordTextField becomeFirstResponder];
        [self showInfoWithMessage:kLocat(@"LEnterPWD")];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self.manager openVerifyCodeView:nil];
    
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{

    if (result == YES) {
        
        if (_isForCode) {
            _codeValidate = validate;
            [self sendCodeAction:nil];
        }else{
            _validate = validate;
            [self checkIfNeedMSGCodeWith:validate];
        }
    }else{
        [self showInfoWithMessage:kLocat(@"OTC_buylist_codeerror")];
    }
}

- (void)_loginWithValidate:(NSString *)validate {
    NSString *phone = self.phoneTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (phone.length == 0 || password.length == 0) {
        return;
    }
    
    [self.view endEditing:YES];
    kShowHud;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"platform"] = @"ios";
    param[@"username"] = phone;
    param[@"password"] = password;
    param[@"validate"] = validate;
    if (_msgCode.length > 1) {
        param[@"phone_code"] = _msgCode;
    }

    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/login"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            if (_keyboardView) {
                [_keyboardView.superview removeFromSuperview];
            }
 
            NSLog(@"%@",responseObj);
            [self showSuccessWithMessage:kLocat(@"LLoginSuccess")];
            [kUserDefaults setObject:phone forKey:@"kUserLoginAccountKey"];
            
            
            //保存数据
            YJUserInfo *userInfo = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kData]];
            [kUserDefaults setInteger:userInfo.uid forKey:kUserIDKey];
            userInfo.userName = [responseObj ksObjectForKey:kData][@"user_name"];
            [userInfo saveUserInfo];
            
            //发通知
            //保存当前登录时间
            [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
            
            kLOG(@"===%@",[kUserDefaults objectForKey:@"kLastLoginTimeKey"]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kKeyWindow.rootViewController = [YJTabBarController new];
            });
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}


#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self.view endEditing:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [kUserInfo clearUserInfo];
    kKeyWindow.rootViewController = [YJTabBarController new];
}

- (IBAction)loginAction:(id)sender {
    [self showVerifyInfo];
}
- (IBAction)registerAction:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController pushViewController:[HBRegisterTableViewController fromStoryboard] animated:YES];
    }
    
}


-(void)checkIfNeedMSGCodeWith:(NSString *)validate
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"username"] = _phoneTextField.text;
    param[@"password"] = _passwordTextField.text;
    param[@"uuid"] = [Utilities randomUUID];
    param[@"validate"] = validate;
    param[@"platform"] = @"ios";
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Account/is_login_code"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"%@",responseObj);
            [self showSuccessWithMessage:kLocat(@"LLoginSuccess")];
            [kUserDefaults setObject:_phoneTextField.text forKey:@"kUserLoginAccountKey"];
            
            //保存数据
            YJUserInfo *userInfo = [YJUserInfo modelWithJSON:[responseObj ksObjectForKey:kData]];
            [kUserDefaults setInteger:userInfo.uid forKey:kUserIDKey];
            userInfo.userName = [responseObj ksObjectForKey:kData][@"user_name"];
            [userInfo saveUserInfo];
            
            //发通知
            //保存当前登录时间
            [kUserDefaults setObject:[NSDate date] forKey:@"kLastLoginTimeKey"];
            
            kLOG(@"===%@",[kUserDefaults objectForKey:@"kLastLoginTimeKey"]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessKey object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kKeyWindow.rootViewController = [YJTabBarController new];
            });
        }else{
            NSInteger code = [[responseObj ksObjectForKey:kCode] integerValue];
            
            if (code == 11000) {
                NSInteger statsu = [[responseObj ksObjectForKey:kData][@"type"] integerValue];
                if (statsu == 1) {//1是手机,2是邮箱
                    _isPhone = YES;
                }
                
                [self showCodeView];
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }
    }];
    
}
-(void)showCodeView
{
    __weak typeof(self)weakSelf = self;

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
    [keyBoardView.codeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        weakSelf.isForCode = YES;
        [weakSelf showVerifyInfo];
    }];
    
    
    _sendButton = keyBoardView.codeButton;
    [keyBoardView.codeButton ba_countDownWithTimeInterval:60 countDownFormat:nil];

}

-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    if (toSubmit == NO) {
        
        _msgCode = keyboardView.codeTF.text;
        
        if (_msgCode.length == 0) {
            [kKeyWindow showWarning:kLocat(@"LEnterVerificationCode")];
            return;
        }
        _keyboardView = keyboardView;
       
        [self _loginWithValidate:_validate];
    }
}

-(void)sendCodeAction:(UIButton *)button
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _codeValidate;
    param[@"type"] = @"login";
    NSString *url ;
    if (_isPhone) {
        param[@"phone"] = _phoneTextField.text;
        url = @"/Sms/code";
    }else{
        param[@"email"] = _phoneTextField.text;
        url = @"/Email/code";
    }
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
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
        [_manager configureVerifyCode:captchaId timeout:10];
    }
    return _manager;
}

@end
