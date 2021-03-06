//
//  HBForgetPasswordTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBForgetPasswordTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "HBLoginRequest.h"
#import "UIButton+LSSmsVerification.h"
#import "HBResetPasswordTableViewController.h"
#import "BARegularExpression.h"
#import "NSObject+SVProgressHUD.h"

@interface HBForgetPasswordTableViewController ()<NTESVerifyCodeManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtl;
@property (weak, nonatomic) IBOutlet UILabel *forgetDes;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property (nonatomic, copy) NSString *token;
@property (weak, nonatomic) IBOutlet UIButton *getValCode;
@property (weak, nonatomic) IBOutlet UIButton *finBtn;
@property(nonatomic,copy)NSString *verifyStr;

@end

@implementation HBForgetPasswordTableViewController



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
    if (self.phoneTextField.text.length == 0) {
        [self showTips:kLocat(@"LEnterPhoneNumber")];
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
        NSString *userName = self.phoneTextField.text;
        if (self.phoneTextField.text.length == 0) {
            [self showInfoWithMessage:kLocat(@"LEnterPhoneNumberOrEmail")];
            return;
        }
        
        void(^success)(YWNetworkResultModel *model) = ^(YWNetworkResultModel *model) {
            kHideHud;
            if ([model succeeded]) {
                [self showSuccessWithMessage:model.message];
                [self.getValCode startTimeWithDuration:60];
            } else {
                [self showInfoWithMessage:model.message];
            }
        };
        
        void(^failure)(NSError *error) = ^(NSError *error) {
            kHideHud;
            [self showInfoWithMessage:error.localizedDescription];
        };
        
        kShowHud;
        BOOL isEmail = [BARegularExpression ba_isEmailQualified:userName];
        if (isEmail) {
            [HBLoginRequest sendFindpwdEmail:userName validate:validate success:success failure:failure];
        } else {
            [HBLoginRequest sendFindpwdSMSWithPhone:userName validate:validate success:success failure:failure];
        }
        
    }else{
        _verifyStr = @"";
        [self showInfoWithMessage:kLocat(@"OTC_buylist_codeerror")];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVerifyConfigure];
    [self.phoneTextField _changeClearButton];
    [self.codeTextField _changeClearButton];
    [self.cancelBtl setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    self.forgetDes.text = kLocat(@"HBForgetPasswordTableViewController_forgetDes");
    self.phoneTextField.placeholder = kLocat(@"R_EMailOrPhone");
    self.codeTextField.placeholder = kLocat(@"HBForgetPasswordTableViewController_valcode_placehoder");
    [self.getValCode setTitle:kLocat(@"HBForgetPasswordTableViewController_valcode_get") forState:UIControlStateNormal];
    [self.finBtn setTitle:kLocat(@"HBForgetPasswordTableViewController_findPwd") forState:UIControlStateNormal];
    
    kViewBorderRadius(_finBtn, 8, 0, kRedColor);
    _finBtn.backgroundColor = kColorFromStr(@"#6189C5");
    _finBtn.titleLabel.font = PFRegularFont(16);
    [_finBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    kTextFieldPlaceHoldColor(_phoneTextField, k999999Color);
    kTextFieldPlaceHoldColor(_codeTextField, k999999Color);
    _phoneTextField.textColor = k666666Color;
    _phoneTextField.font = PFRegularFont(16);
    _codeTextField.textColor = k666666Color;
    _codeTextField.font = PFRegularFont(16);
    
    _forgetDes.textColor = k666666Color;
    _forgetDes.font = PFRegularFont(24);
    
    [_cancelBtl setTitleColor:k666666Color forState:UIControlStateNormal];
    _cancelBtl.titleLabel.font = PFRegularFont(16);
    
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToResetPasswordVC"]) {
         HBResetPasswordTableViewController *vc = segue.destinationViewController;
        vc.token = self.token;
        vc.phone = self.phoneTextField.text;
    }
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendSMSAction:(UIButton *)sender {
    if (self.phoneTextField.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterPhoneNumberOrEmail")];
        return;
    }
    
    [self  showVerifyInfo];
}

- (IBAction)findPasswordTextField:(id)sender {
    NSString *phone = self.phoneTextField.text;
    if (self.phoneTextField.text.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterPhoneNumberOrEmail")];
        return;
    }
    NSString *code = self.codeTextField.text;
    if (code.length == 0) {
        [self showInfoWithMessage:kLocat(@"LEnterVerificationCode")];
        return;
    }
    
    kShowHud;
    [HBLoginRequest findpassWithPhone:phone code:code success:^(YWNetworkResultModel *model) {
        kHideHud;
        if ([model succeeded]) {
            self.token = [model.result valueForKey:@"token"];
            [self performSegueWithIdentifier:@"goToResetPasswordVC" sender:nil];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}


@end
