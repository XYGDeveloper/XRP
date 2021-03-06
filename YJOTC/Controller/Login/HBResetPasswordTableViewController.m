//
//  HBResetPasswordTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBResetPasswordTableViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "HBLoginRequest.h"
#import "NSObject+SVProgressHUD.h"

@interface HBResetPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UIButton *canBtn;
@property (weak, nonatomic) IBOutlet UILabel *resetPwd;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation HBResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.passwordTextField _changeClearButton];
    [self.password2TextField _changeClearButton];

    [self.canBtn setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    
    self.resetPwd.text = kLocat(@"HBResetPasswordTableViewController_resetDes");
    
    self.passwordTextField.placeholder = kLocat(@"HBResetPasswordTableViewController_ori_placehoder");
    self.password2TextField.placeholder = kLocat(@"HBResetPasswordTableViewController_new_placehoder");
    [self.commitBtn setTitle:kLocat(@"HBResetPasswordTableViewController_commit") forState:UIControlStateNormal];
    
    [self.passwordTextField becomeFirstResponder];
    
    
    kViewBorderRadius(_commitBtn, 8, 0, kRedColor);
    _commitBtn.backgroundColor = kColorFromStr(@"#6189C5");
    _commitBtn.titleLabel.font = PFRegularFont(16);
    [_commitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    kTextFieldPlaceHoldColor(self.passwordTextField, k999999Color);
    kTextFieldPlaceHoldColor(self.password2TextField, k999999Color);
    self.passwordTextField.textColor = k666666Color;
    self.passwordTextField.font = PFRegularFont(16);
    self.password2TextField.textColor = k666666Color;
    self.password2TextField.font = PFRegularFont(16);
    
    _resetPwd.textColor = k666666Color;
    _resetPwd.font = PFRegularFont(24);
    
    [_canBtn setTitleColor:k666666Color forState:UIControlStateNormal];
    _canBtn.titleLabel.font = PFRegularFont(16);
    
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender {
    NSString *pwd = self.passwordTextField.text;
    NSString *repwd = self.password2TextField.text;
    if (pwd == 0 || repwd == 0) {
        [self showTips:kLocat(@"LEnterPWD")];
        return;
    }
    if (![pwd isEqualToString:repwd]) {
        [self showTips:kLocat(@"LLoginPWDNotSame")];
        return;
    }
    
    kShowHud;
    [HBLoginRequest resetpassWithPhone:self.phone token:self.token pwd:pwd repwd:repwd success:^(YWNetworkResultModel *model) {
        kHideHud;
    
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self showInfoWithMessage:model.message];
        }
        
    } failure:^(NSError *error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}


@end
