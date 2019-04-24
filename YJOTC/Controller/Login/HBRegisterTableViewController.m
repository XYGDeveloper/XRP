//
//  HBRegisterTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBRegisterTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "ICNNationalityModel+Request.h"
#import "HBLoginRequest.h"
#import "UIButton+LSSmsVerification.h"
#import "HBSelectCodeOfCountryView.h"
#import "HMSegmentedControl.h"
#import "NSObject+SVProgressHUD.h"

@interface HBRegisterTableViewController () <HBSelectCodeOfCountryViewDelegate,NTESVerifyCodeManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *countryOfCodeButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) NSArray<ICNNationalityModel *> *codesOfCountry;

@property (weak, nonatomic) IBOutlet UILabel *codeOfCountryLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *tradePassword2TextField;
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;

@property (nonatomic, strong) UITableView *nationalityTableview;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,copy)NSString *verifyStr;

@property (weak, nonatomic) IBOutlet UILabel *registerDes;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UILabel *readDes;
@property (weak, nonatomic) IBOutlet UIButton *valcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeDes;
@property (weak, nonatomic) IBOutlet UITextField *defaultCounBtn;
@property (weak, nonatomic) IBOutlet UILabel *encouragingLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger selectedSegmentedIndex;

@property(nonatomic,strong)ICNNationalityModel *selectedCountryModel;

@property(nonatomic,assign)BOOL isEmail;

@property (weak, nonatomic) IBOutlet UIButton *langButton;

@end

@implementation HBRegisterTableViewController

+ (instancetype)fromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"HBRegisterTableViewController"];
}

-(void)initVerifyConfigure
{
    // sdk调用
    self.manager = [NTESVerifyCodeManager sharedInstance];
    self.manager.delegate = self;
    
    // 设置透明度
    self.manager.alpha = 0;
    
    _manager.lang = [Utilities getLangguageForNTESVerifyCode];

    // 设置frame
    self.manager.frame = CGRectNull;
    
    // captchaId从云安全申请，比如@"a05f036b70ab447b87cc788af9a60974"
    NSString *captchaId = kVerifyKey;
    [self.manager configureVerifyCode:captchaId timeout:7];
}

-(void)showVerifyInfo
{
    if (self.phoneTextField.text.length == 0) {
        NSString *key = self.isEmail ? @"LEnterEamil" : @"LEnterPhoneNumber";
        [self showTips:kLocat(key)];
        return;
    }
    
    [self.phoneTextField resignFirstResponder];
    
    [self.manager openVerifyCodeView:nil];
    
}

- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message
{
    // App添加自己的处理逻辑
    if (result == YES) {
        _verifyStr = validate;
        kShowHud;
        BOOL isEmail = self.selectedSegmentedIndex == 1;
        
        NSString *code;
        if (_selectedCountryModel) {
            code = _selectedCountryModel.countrycode;
        }else{
            code = @"86";
        }
        
        [HBLoginRequest getRegisterVerifyCodeWithUserName:self.phoneTextField.text
                                                  isEmail:isEmail
                                             codeOfContry:code
                                                 validate:validate
                                                  success:^(YWNetworkResultModel * _Nonnull model)
        {
            kHideHud;
            if ([model succeeded]) {
//                [self.sendSMSButton startTimeWithDuration:60];
                [self.sendSMSButton ba_countDownWithTimeInterval:60 countDownFormat:nil];
            }
            [self showInfoWithMessage:model.message];
        } failure:^(NSError * _Nonnull error) {
            kHideHud;
            [self.sendSMSButton startTimeWithDuration:1];

            [self showInfoWithMessage:error.localizedDescription];
        }];
    }else{
        _verifyStr = @"";
        [self showInfoWithMessage:kLocat(@"OTC_buylist_codeerror")];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.checkboxButton.selected = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self setStatusBarColor:[UIColor clearColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVerifyConfigure];
    [self.textFields enumerateObjectsUsingBlock:^(UITextField  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj _changeClearButton];
    }];
    self.countryOfCodeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
//    [ICNNationalityModel requestCountryListWithSuccess:^(NSArray<ICNNationalityModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull model) {
//        self.codesOfCountry = array;
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//泰文
        lang = @"zh-tw";
    }
    param[@"language"] = lang;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/api/Account/countrylist"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        if (success) {
             
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in [responseObj ksObjectForKey:kData]) {
                [arr addObject:[ICNNationalityModel modelWithJSON:dic]];
            }
            self.codesOfCountry = arr;
        }
    }];
    
    
    
    [self _setupSegemntedControl];
    
    self.registerDes.text = kLocat(@"HBRegisterTableViewController_registerdes");
    self.readDes.text = kLocat(@"HBRegisterTableViewController_read");
    [self.agreeBtn setTitle:kLocat(@"HBRegisterTableViewController_agree") forState:UIControlStateNormal];
    [self.loginBtn setTitle:kLocat(@"HBLoginTableViewController_password_login") forState:UIControlStateNormal];
    [self.registerBtn setTitle:kLocat(@"HBLoginTableViewController_password_regis") forState:UIControlStateNormal];
    [self.sendSMSButton setTitle:kLocat(@"LGetVerificationCode") forState:UIControlStateNormal];
    self.phoneTextField.placeholder = kLocat(@"HBForgetPasswordTableViewController_forgetPhone_placehoder");
    self.codeTextField.placeholder = kLocat(@"HBRegisterTableViewController_valcode");
    self.passwordTextField.placeholder = kLocat(@"HBRegisterTableViewController_1loginpwd");
    self.password2TextField.placeholder = kLocat(@"HBRegisterTableViewController_2loginpwd");
    self.tradePasswordTextField.placeholder = kLocat(@"HBRegisterTableViewController_1tradepwd");
    self.tradePassword2TextField.placeholder = kLocat(@"HBRegisterTableViewController_2tradepwd");
    self.inviteTextField.placeholder = kLocat(@"HBRegisterTableViewController_invitecode");
    [self.countryOfCodeButton setTitle:kLocat(@"HBRegisterTableViewController_defaultCountry") forState:UIControlStateNormal];
    self.codeDes.text = kLocat(@"HBRegisterTableViewController_defaultdes");
    [self.cancelBtn setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    self.encouragingLabel.text = kLocat(@"HBRegisterTableViewController_encouraging");
    self.encouragingLabel.hidden = YES;
    self.inviteTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    [_cancelBtn setTitleColor:k666666Color forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = PFRegularFont(16);
    
    _registerDes.textColor = k666666Color;
    [_loginBtn setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    
    kViewBorderRadius(_registerBtn, 8, 0, kRedColor);
    _registerBtn.backgroundColor = kColorFromStr(@"#6189C5");
    _registerBtn.titleLabel.font = PFRegularFont(16);
    [_registerBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    _readDes.textColor = k666666Color;
    [_agreeBtn setTitleColor:kColorFromStr(@"6189C5") forState:UIControlStateNormal];
    
    kTextFieldPlaceHoldColor(self.phoneTextField, k999999Color);
    kTextFieldPlaceHoldColor(self.codeTextField, k999999Color);
    kTextFieldPlaceHoldColor(self.passwordTextField, k999999Color);
    kTextFieldPlaceHoldColor(self.password2TextField, k999999Color);
    kTextFieldPlaceHoldColor(self.tradePasswordTextField, k999999Color);
    kTextFieldPlaceHoldColor(self.tradePassword2TextField, k999999Color);
    kTextFieldPlaceHoldColor(self.inviteTextField, k999999Color);

    [self.checkboxButton setImage:kImageFromStr(@"weigou_icon") forState:UIControlStateNormal];
    [self.checkboxButton setImage:kImageFromStr(@"gou_icon") forState:UIControlStateSelected];

    self.checkboxButton.selected = YES;
    _passwordTextField.delegate = self;
    _password2TextField.delegate = self;
    _tradePasswordTextField.delegate = self;
    _tradePassword2TextField.delegate = self;
    
    _langButton.titleLabel.font = PFRegularFont(14);
    NSString *currenLan = [LocalizableLanguageManager userLanguage];
    if ([currenLan containsString:@"en"]) {
        [_langButton setTitle:@"繁体中文" forState:UIControlStateNormal];
    }else{
        [_langButton setTitle:@"English" forState:UIControlStateNormal];
    }
    [_langButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [kUserDefaults setInteger:2 forKey:@"kToLoginOrRegisterKey"];

        if ([currenLan containsString:@"en"]) {
            [kUserDefaults setBool:YES forKey:@"isTradition"];
            [LocalizableLanguageManager setUserlanguage:CHINESETradition];
        }else{
            [kUserDefaults setBool:NO forKey:@"isTradition"];
            [LocalizableLanguageManager setUserlanguage:ENGLISH];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Private

- (void)_setupSegemntedControl {
    self.selectedSegmentedIndex = 0;
    self.segmentedControl.sectionTitles = @[kLocat(@"Phone"), kLocat(@"eMail")];
    self.segmentedControl.backgroundColor = kWhiteColor;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = kColorFromStr(@"#6189C5");
    NSDictionary *attributesNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:18],NSFontAttributeName, k666666Color, NSForegroundColorAttributeName,nil];
    NSDictionary *attributesSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Semibold" size:18],NSFontAttributeName, kColorFromStr(@"#6189C5"), NSForegroundColorAttributeName,nil];
    self.segmentedControl.titleTextAttributes = attributesNormal;
    self.segmentedControl.selectedTitleTextAttributes = attributesSelected;
    
    __weak typeof(self) weakSelf = self;
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        weakSelf.selectedSegmentedIndex = index;
        weakSelf.isEmail = index;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        if (self.selectedSegmentedIndex == 1) {
            return 0.;
        } else {
            return 44.;
        }
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

#pragma mark - HBSelectCodeOfCountryViewDelegate

- (void)selectCodeOfCountryView:(HBSelectCodeOfCountryView *)view didSelectModel:(ICNNationalityModel *)model {
    [self.countryOfCodeButton setTitle:[NSString stringWithFormat:@"%@ ", model.name] forState:UIControlStateNormal];
    _selectedCountryModel = model;
    self.codeOfCountryLabel.text = [NSString stringWithFormat:@"+%@",model.countrycode];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tradePassword2TextField || textField == _tradePasswordTextField) {
        if (textField.text.length > 5 && ![string isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }
    
    if (textField == _passwordTextField || textField == _password2TextField) {
        if (textField.text.length > 19 && ![string isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}



#pragma mark - Actions

- (IBAction)selectCodeOfCountryAction:(id)sender {
    HBSelectCodeOfCountryView *view = [HBSelectCodeOfCountryView viewLoadNib];
    view.codesOfCountry = self.codesOfCountry;
    view.delegate = self;
    [view showInWindow];
}

- (IBAction)sendSMSAction:(UIButton *)sender {
    
    if (self.phoneTextField.text.length == 0) {
        NSString *key = self.isEmail ? @"LEnterEamil" : @"LEnterPhoneNumber";
        [self showInfoWithMessage:kLocat(key)];
        return;
    }
    
    [self showVerifyInfo];
    
}

- (IBAction)cancelAction:(id)sender {
    
    if (self.navigationController.viewControllers.count == 1) {
        [kUserInfo clearUserInfo];
        kKeyWindow.rootViewController = [YJTabBarController new];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)loginAction:(id)sender {
    
    BOOL containLoginVC = NO;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HBLoginTableViewController class]]) {
            containLoginVC = YES;
        }
    }
    
    if (containLoginVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UINavigationController *vc1 = [HBLoginTableViewController fromStoryboard];
        kNavPush(vc1.viewControllers.firstObject);
    }
}

- (IBAction)agreeTheProtocolAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)registerAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    BOOL isEmail = self.selectedSegmentedIndex == 1;
    if (self.phoneTextField.text.length == 0) {
        NSString *key = self.isEmail ? @"LEnterEamil" : @"LEnterPhoneNumber";
        [self showInfoWithMessage:kLocat(key)];
        return;
    }

    if (self.codeTextField.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterVerificationCode")];
        return;
    }

    if (self.passwordTextField.text.length == 0 || self.password2TextField.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterPWD")];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.password2TextField.text]) {
        [self showInfoWithMessage:kLocat(@"LLoginPWDNotSame")];
        return;
    }
//    if (self.passwordTextField.text.length < 6) {
//        [self showInfoWithMessage:kLocat(@"LPWDLengthLessThan6")];
//        return;
//    }

    if (self.tradePasswordTextField.text.length == 0||self.tradePassword2TextField.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterTransactionPWD")];
        return;
    }
    if (self.tradePasswordTextField.text.length < 6 || self.tradePassword2TextField.text.length < 6) {
        [self showInfoWithMessage:kLocat(@"LPWDLengthLessThan6")];
        return;
    }
    if (![self.tradePasswordTextField.text isEqualToString:self.tradePasswordTextField.text]) {
        [self showInfoWithMessage:kLocat(@"LPayPWDNotSame")];
        return;
    }


    if ([self.passwordTextField.text isEqualToString:self.tradePasswordTextField.text]) {
        [self showInfoWithMessage:kLocat(@"k_PayLoginPWDSame")];
        return;
    }
    
    if (!self.checkboxButton.selected) {
        [self showTips:kLocat(@"R_AgreeUserRegister")];
        return;
    }
    
    if (_verifyStr.length < 2) {
        [self showInfoWithMessage:kLocat(@"LGetVerifyCodeFirst")];
        return;
    }
    
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *userNameKey = isEmail ? @"email" : @"phone";
    NSString *codeKey = isEmail ? @"email_code" : @"phone_code";
    param[userNameKey] = _phoneTextField.text;
    param[codeKey] = _codeTextField.text;
    param[@"pwd"] = _passwordTextField.text;
    param[@"repwd"] = _password2TextField.text;
    param[@"pwdtrade"] = _tradePasswordTextField.text;
    param[@"repwdtrade"] = _tradePassword2TextField.text;
    param[@"countrycode"] = _selectedCountryModel.countrycode;//TODO
    if (_selectedCountryModel) {
        param[@"countrycode"] = _selectedCountryModel.countrycode;//TODO
    }else{
        param[@"countrycode"] = @"86";//TODO
    }
    
    param[@"platform"] = @"ios";
    param[@"pid"] = _inviteTextField.text;
    NSString *currentLanguage = [LocalizableLanguageManager userLanguage];
    NSString *lang = nil;
    if ([currentLanguage containsString:@"en"]) {//英文
        lang = @"en-us";
    }else if ([currentLanguage containsString:@"Hant"]){//繁体
        lang = @"zh-tw";
    }else{//简体
        lang = @"zh-tw";
    }
    param[@"language"] = lang;
 
    kShowHud;
    sender.enabled = NO;
    [HBLoginRequest registerWithParameters:param isEmail:isEmail success:^(YWNetworkResultModel * _Nonnull model) {
        kHideHud;
        sender.enabled = YES;
    
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginAction:nil];
            });
        } else {
            [self showInfoWithMessage:model.message];
        }
        
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        sender.enabled = YES;
        [self showErrorWithMessage:error.localizedDescription];
    }];
    
}

- (IBAction)registerAgreement:(id)sender {
    
    UIViewController *vc = [BaseWebViewController webViewControllerWithURIString:@"/mobile/News/detail/position_id/154" title:nil];
    kNavPush(vc);
    
}


#pragma mark - Setters & Getters

- (BOOL)isIsEmail {
    return self.segmentedControl.selectedSegmentIndex == 1;
}

- (void)setCodesOfCountry:(NSArray<ICNNationalityModel *> *)codesOfCountry {
    _codesOfCountry = codesOfCountry;
}

- (void)setSelectedSegmentedIndex:(NSInteger)selectedSegmentedIndex {
    
    if (_selectedSegmentedIndex != selectedSegmentedIndex) {
        [self.sendSMSButton ba_cancelTimer];
    }
    
    _selectedSegmentedIndex = selectedSegmentedIndex;
    self.codeOfCountryLabel.hidden = (selectedSegmentedIndex == 1);
    NSString *userNamePlaceholder = (selectedSegmentedIndex == 0) ?  kLocat(@"HBForgetPasswordTableViewController_forgetPhone_placehoder") : kLocat(@"HBForgetPasswordTableViewController_forgetEmail_placehoder");
    self.phoneTextField.placeholder = userNamePlaceholder;
    self.phoneTextField.keyboardType = (selectedSegmentedIndex == 0) ? UIKeyboardTypePhonePad : UIKeyboardTypeEmailAddress;
    
    _phoneTextField.text = nil;
    _codeTextField.text = nil;
    [self.tableView reloadData];
}

@end
