//
//  XPCashierViewController.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCashierViewController.h"
#import "XPCashTableViewCell.h"
#import "XPCashModel.h"
#import "XPPayMethodTableViewCell.h"
#import "XPZhuanZhangConfirmView.h"
#import "TPWalletSendKeyboardView.h"
#import "XPJHViewController.h"
#import "XPCommunityDetailViewController.h"
#import "ConfirmInputView.h"
@interface XPCashierViewController ()<TPWalletSendKeyboardViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPCashModel *model;
@property (nonatomic,strong)XPPayMethodTableViewCell *header;
@property (nonatomic,strong)NSString *paymethod;
@property (nonatomic,strong)ConfirmInputView *confirmView;
@property (nonatomic,strong)XPZhuanZhangConfirmView *confirmViewz;
@property (nonatomic,strong)XPZhuanZhangConfirmView *confirmViewj;
@end

@implementation XPCashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = kLocat(@"C_community_cash_title");
    [self.tableview registerNib:[UINib nibWithNibName:@"XPCashTableViewCell" bundle:nil] forCellReuseIdentifier:@"s1"];
     [self.tableview registerNib:[UINib nibWithNibName:@"XPCashTableViewCell" bundle:nil] forCellReuseIdentifier:@"s2"];
     [self.tableview registerNib:[UINib nibWithNibName:@"XPCashTableViewCell" bundle:nil] forCellReuseIdentifier:@"s3"];
     [self.tableview registerNib:[UINib nibWithNibName:@"XPCashTableViewCell" bundle:nil] forCellReuseIdentifier:@"s4"];
    
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPPayMethodTableViewCell" owner:self options:nil] lastObject];
    self.tableview.tableFooterView = self.header;
    [self.header.payButton addTarget:self action:@selector(toPay:) forControlEvents:UIControlEventTouchUpInside];
    [self.header.rbzButton addTarget:self action:@selector(toPay1:) forControlEvents:UIControlEventTouchUpInside];
    [self.header.rbjButton addTarget:self action:@selector(toPay2:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(toChange) name:@"returnj" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)toChange{
    [self.confirmViewz.superview removeFromSuperview];
    [self.confirmViewj.superview removeFromSuperview];
}

- (void)toPay:(UIButton *)sender{
    self.paymethod = @"1";
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    XPZhuanZhangConfirmView *confirmView = [[[NSBundle mainBundle] loadNibNamed:@"XPZhuanZhangConfirmView" owner:self options:nil] lastObject];
    confirmView.frame = kRectMake(0, kScreenH - 500, kScreenW, 500);
    [bgView addSubview:confirmView];
    confirmView.title.text = kLocat(@"C_community_alert_title");
    confirmView.volumeLabel.text = [NSString stringWithFormat:@"%@ XRP",self.model.info.pay_number];
    confirmView.mingxiLabel.hidden = YES;
    confirmView.mywalletLabelContent.hidden = YES;
    confirmView.rbContentLabel.hidden = YES;
    confirmView.desLabel.hidden = YES;
    confirmView.scaleButton.hidden = YES;
    confirmView.accountLabel.text = [NSString stringWithFormat:@"%@%@",self.model.info.votes,kLocat(@"C_community_search_votes")];
    if (self.member_id) {
        confirmView.account.text = kLocat(@"C_community_cash_taocan");
    }else{
        confirmView.account.text = kLocat(@"C_community_alert_jhuotaocan");
    }
    confirmView.payway.text = kLocat(@"C_community_alert_paymode");
    confirmView.paywayLabel.text  = kLocat(@"C_community_search_mywallet");
    confirmView.callBackBlock = ^(UIButton *sureButton) {
        [self confirmAction:sureButton];
    };
}

//w+z
- (void)toPay1:(UIButton *)sender{
    self.confirmView.kkTextfield.text  = @"";
    self.paymethod = @"2";
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    self.confirmViewz = [[[NSBundle mainBundle] loadNibNamed:@"XPZhuanZhangConfirmView" owner:self options:nil] lastObject];
    self.confirmViewz.frame = kRectMake(0, kScreenH - 500, kScreenW, 500);
    [bgView addSubview:self.confirmViewz];
    self.confirmViewz.title.text = kLocat(@"C_community_alert_title");
    self.confirmViewz.volumeLabel.text = [NSString stringWithFormat:@"%@ XRP",self.model.info.pay_number];
    self.confirmViewz.mingxiLabel.text = kLocat(@"C_community_search_cash_pay_mingxi");
    double min;
    if (self.model.pay_choose.xrpz.user_xrpz_num < self.model.pay_choose.xrpz.max_xrpz_num) {
        min = self.model.pay_choose.xrpz.user_xrpz_num;
    }else{
        min = self.model.pay_choose.xrpz.max_xrpz_num;
    }

    self.confirmViewz.mywalletLabelContent.text = [NSString stringWithFormat:@"%@ -%.6fXRP",kLocat(@"C_community_search_cash_pay_mingxi_wallet"),[self.model.info.pay_number floatValue] -min];
    self.confirmViewz.scaleButton.hidden = NO;
    self.confirmViewz.rbContentLabel.text = [NSString stringWithFormat:@"%@ -%.6fXRP",kLocat(@"C_community_search_cash_pay_mingxi_rbz"),min];
    self.confirmViewz.desLabel.text = [NSString stringWithFormat:@"%@%@%%%@",kLocat(@"C_community_search_cash_pay_descontent_pre"),self.model.pay_choose.xrpz.wallet_min_percent,kLocat(@"C_community_search_cash_pay_descontent_next")];
    [self.confirmViewz.scaleButton setTitle:kLocat(@"C_community_search_cash_pay_mingxi_scale") forState:UIControlStateNormal];
    self.confirmViewz.accountLabel.text = [NSString stringWithFormat:@"%@%@",self.model.info.votes,kLocat(@"C_community_search_votes")];
    if (self.member_id) {
        self.confirmViewz.account.text = kLocat(@"C_community_cash_taocan");
    }else{
        self.confirmViewz.account.text = kLocat(@"C_community_alert_jhuotaocan");
    }
    self.confirmViewz.payway.text = kLocat(@"C_community_alert_paymode");
    self.confirmViewz.paywayLabel.text  = kLocat(@"C_community_search_cash_pay_mingxi_zuhe");
    __weak typeof(self) wself = self;
    self.confirmViewz.callBackBlock = ^(UIButton *sureButton) {
        __strong typeof(wself) sself = wself;
        [sself confirmAction:sureButton];
        
    };
    self.confirmViewz.scaleBlocks = ^(UIButton *scaleButton) {
        __strong typeof(wself) sself = wself;
        [sself modifyScale:scaleButton];
    };
    
}

- (void)modifyScale:(UIButton *)sender{
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    self.confirmView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmInputView" owner:self options:nil] lastObject];
    self.confirmView.frame = kRectMake(0, kScreenH - 500, kScreenW, 500);
    self.confirmView.countLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_search_cash_pay_wailttopay"),self.model.info.pay_number];
    self.confirmView.kkLabel.text = kLocat(@"C_community_search_cash_pay_wwalletPay");
    if ([self.paymethod isEqualToString:@"2"]) {
    self.confirmView.desLabel.text = [NSString stringWithFormat:@"%@%@%%%@",kLocat(@"C_community_search_cash_pay_descontent_pre"),self.model.pay_choose.xrpz.wallet_min_percent,kLocat(@"C_community_search_cash_pay_descontent_next")];
        self.confirmView.rbKKLabel.text = kLocat(@"C_community_search_cash_pay_mingxi_rbz");
    }else{
    self.confirmView.desLabel.text = [NSString stringWithFormat:@"%@%@%%%@",kLocat(@"C_community_search_cash_pay_descontent_pre"),self.model.pay_choose.xrpj.wallet_min_percent,kLocat(@"C_community_search_cash_pay_descontent_next")];
        self.confirmView.rbKKLabel.text = kLocat(@"C_community_search_cash_pay_mingxi_rbj");
    }
    __weak typeof(self) wself = self;
    if ([self.paymethod isEqualToString:@"2"]) {
        double min;
        if (self.model.pay_choose.xrpz.user_xrpz_num < self.model.pay_choose.xrpz.max_xrpz_num) {
            min = self.model.pay_choose.xrpz.user_xrpz_num;
        }else{
            min = self.model.pay_choose.xrpz.max_xrpz_num;
        }
        self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",min];
        self.confirmView.kkTextfield.text = [NSString stringWithFormat:@"%.6f",[self.model.info.pay_number floatValue] - min];
    }else{
        double min;
        if (self.model.pay_choose.xrpj.user_xrpj_num  < self.model.pay_choose.xrpj.max_xrpj_num) {
            min =self.model.pay_choose.xrpj.user_xrpj_num;
        }else{
            min = self.model.pay_choose.xrpj.max_xrpj_num;
        }
        self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",min];
          self.confirmView.kkTextfield.text = [NSString stringWithFormat:@"%f",[self.model.info.pay_number floatValue] - min];
    }
    [self.confirmView.kkTextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.confirmView.callBackBlock = ^(UIButton *sureButton) {
        __strong typeof(wself) sself = wself;
        if ([sself.paymethod isEqualToString:@"2"]) {
            sself.confirmViewz.rbContentLabel.text = [NSString stringWithFormat:@"%@ -%fXRP",kLocat(@"C_community_search_cash_pay_mingxi_rbz"),[self.model.info.pay_number doubleValue] -[self.confirmView.kkTextfield.text doubleValue]];
            sself.confirmViewz.mywalletLabelContent.text= [NSString stringWithFormat:@"%@ -%@XRP",kLocat(@"C_community_search_cash_pay_mingxi_wallet"),sself.confirmView.kkTextfield.text];
            if (sself.confirmView.kkTextfield.text == nil || [sself.confirmView.kkTextfield.text intValue] <= 0  ||  [sself.confirmView.kkTextfield.text floatValue] > [self.model.info.pay_number floatValue] || [sself.confirmView.kkTextfield.text floatValue] <=[self.model.info.pay_number floatValue]*[self.model.pay_choose.xrpz.wallet_min_percent doubleValue]*0.01) {
                [kKeyWindow showWarning:kLocat(@"C_community_search_cash_pay_mingxi_input_warn")];
                return;
            }
        }else if ([sself.paymethod isEqualToString:@"3"]){
            sself.confirmViewj.rbContentLabel.text = [NSString stringWithFormat:@"%@ -%fXRP",kLocat(@"C_community_search_cash_pay_mingxi_rbz"),[self.model.info.pay_number doubleValue] -[sself.confirmView.kkTextfield.text doubleValue]];
            sself.confirmViewj.mywalletLabelContent.text = [NSString stringWithFormat:@"%@ -%@XRP",kLocat(@"C_community_search_cash_pay_mingxi_wallet"),sself.confirmView.kkTextfield.text];
            if (sself.confirmView.kkTextfield.text == nil || [sself.confirmView.kkTextfield.text intValue] <= 0  || [sself.confirmView.kkTextfield.text floatValue] > [sself.model.info.pay_number floatValue] || [sself.confirmView.kkTextfield.text floatValue] <= [sself.model.info.pay_number floatValue]*[sself.model.pay_choose.xrpj.wallet_min_percent doubleValue]*0.01) {
                [kKeyWindow showWarning:kLocat(@"C_community_search_cash_pay_mingxi_input_warn")];
                return;
            }
        }
        [sureButton.superview.superview removeFromSuperview];
    };
    [bgView addSubview:self.confirmView];
}


- (void)textFieldChanged:(UITextField*)textField{
    
    if ([self.paymethod isEqualToString:@"2"]) {
        if ([textField.text intValue] > self.model.pay_choose.xrpz.max_xrpz_num) {
            self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [textField.text doubleValue]];
        }else{
            [kKeyWindow showWarning:[NSString stringWithFormat:@"%@%.6f-%.6f%@",kLocat(@"C_community_search_cash_pay_mingxi_input_left"),[self.model.info.pay_number floatValue]*[self.model.pay_choose.xrpz.wallet_min_percent doubleValue]*0.01,[self.model.info.pay_number floatValue],kLocat(@"C_community_search_cash_pay_mingxi_input_right")]];
            self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [textField.text doubleValue]];
            return;
        }
    }else{
        if ([textField.text floatValue] > self.model.pay_choose.xrpj.max_xrpj_num) {
            self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [textField.text doubleValue]];
        }else{
            [kKeyWindow showWarning:[NSString stringWithFormat:@"%@%.6f-%.6f%@",kLocat(@"C_community_search_cash_pay_mingxi_input_left"),[self.model.info.pay_number floatValue]*[self.model.pay_choose.xrpj.wallet_min_percent doubleValue]*0.01,[self.model.info.pay_number floatValue],kLocat(@"C_community_search_cash_pay_mingxi_input_right")]];
            self.confirmView.rbkkContentLabel.text = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [textField.text doubleValue]];
            return;
        }
    }
   
}
- (void)toPay2:(UIButton *)sender{
    self.confirmView.kkTextfield.text  = @"";
    self.paymethod = @"3";
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    self.confirmViewj = [[[NSBundle mainBundle] loadNibNamed:@"XPZhuanZhangConfirmView" owner:self options:nil] lastObject];
    self.confirmViewj.frame = kRectMake(0, kScreenH - 500, kScreenW, 500);
    [bgView addSubview:self.confirmViewj];
    self.confirmViewj.title.text = kLocat(@"C_community_alert_title");
    self.confirmViewj.volumeLabel.text = [NSString stringWithFormat:@"%@ XRP",self.model.info.pay_number];
    self.confirmViewj.mingxiLabel.text = kLocat(@"C_community_search_cash_pay_mingxi");
    self.confirmViewj.scaleButton.hidden = NO;
    double min;
    if (self.model.pay_choose.xrpj.user_xrpj_num < self.model.pay_choose.xrpj.max_xrpj_num) {
        min = self.model.pay_choose.xrpj.user_xrpj_num ;
    }else{
        min = self.model.pay_choose.xrpj.max_xrpj_num ;
    }
    
    self.confirmViewj.mywalletLabelContent.text = [NSString stringWithFormat:@"%@ -%fXRP",kLocat(@"C_community_search_cash_pay_mingxi_wallet"),[self.model.info.pay_number doubleValue]- min];
    self.confirmViewj.rbContentLabel.text = [NSString stringWithFormat:@"%@ -%fXRP",kLocat(@"C_community_search_cash_pay_mingxi_rbj"),min];
    self.confirmViewj.desLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocat(@"C_community_search_cash_pay_descontent_pre"),self.model.pay_choose.xrpj.wallet_min_percent,kLocat(@"C_community_search_cash_pay_descontent_next")];
    [self.confirmViewj.scaleButton setTitle:kLocat(@"C_community_search_cash_pay_mingxi_scale") forState:UIControlStateNormal];
    self.confirmViewj.accountLabel.text = [NSString stringWithFormat:@"%@%@",self.model.info.votes,kLocat(@"C_community_search_votes")];
    if (self.member_id) {
        self.confirmViewj.account.text = kLocat(@"C_community_cash_taocan");
    }else{
        self.confirmViewj.account.text = kLocat(@"C_community_alert_jhuotaocan");
    }
    self.confirmViewj.payway.text = kLocat(@"C_community_alert_paymode");
    self.confirmViewj.paywayLabel.text  = [NSString stringWithFormat:@"%@+%@",kLocat(@"C_community_search_cash_pay_mingxi_wallet_01"),kLocat(@"C_community_search_cash_pay_mingxi_rbj_01")];
    __weak typeof(self) wself = self;
    self.confirmViewj.callBackBlock = ^(UIButton *sureButton) {
        __strong typeof(wself) sself = wself;
        [sself confirmAction:sureButton];
    };
    self.confirmViewj.scaleBlocks = ^(UIButton *scaleButton) {
        __strong typeof(wself) sself = wself;
        [sself modifyScale:scaleButton];
    };
    
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
    keyBoardView.showPayView = YES;
}

-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit
{
    [self tradeAction:keyboardView];
}

-(void)tradeAction:(TPWalletSendKeyboardView *)keyboardView
{
    if (!self.member_id) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"step_votes"] = @(_votes);
        if (!self.parent_id) {
            param[@"parentID"] = self.member_id;
        }else{
            param[@"parentID"] = self.parent_id;
        }
        if ([self.paymethod isEqualToString:@"1"]) {
            param[@"xrpz_num"] = @"0";
            param[@"xrpj_num"] = @"0";
            param[@"xrp_num"] = self.model.info.pay_number;
        }else if ([self.paymethod isEqualToString:@"2"]){
            NSLog(@"-----------%@",self.confirmView.kkTextfield.text);
            if (!self.confirmView.kkTextfield.text ||self.confirmView.kkTextfield.text.length <= 0 ) {
                double min;
                if (self.model.pay_choose.xrpz.user_xrpz_num < self.model.pay_choose.xrpz.max_xrpz_num ) {
                    min = self.model.pay_choose.xrpz.user_xrpz_num;
                }else{
                    min = self.model.pay_choose.xrpz.max_xrpz_num;
                }
                param[@"xrpz_num"] = [NSString stringWithFormat:@"%f",min];
                param[@"xrpj_num"] = @"0";
                param[@"xrp_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] -min];
            }else{
                param[@"xrpz_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [self.confirmView.kkTextfield.text doubleValue]];
                param[@"xrpj_num"] = @"0";
                param[@"xrp_num"] = self.confirmView.kkTextfield.text;
            }
        }else{
            NSLog(@"-----------%@",self.confirmView.kkTextfield.text);
            if (!self.confirmView.kkTextfield.text ||self.confirmView.kkTextfield.text.length <= 0 ) {
                double min;
                if (self.model.pay_choose.xrpj.user_xrpj_num< self.model.pay_choose.xrpj.max_xrpj_num ) {
                    min = self.model.pay_choose.xrpj.user_xrpj_num;
                }else{
                    min = self.model.pay_choose.xrpj.max_xrpj_num;
                }
                param[@"xrpz_num"] = @"0";
                param[@"xrpj_num"] = [NSString stringWithFormat:@"%f",min];
                param[@"xrp_num"]  = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] -min];
            }else{
                param[@"xrpj_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [self.confirmView.kkTextfield.text doubleValue]];
                param[@"xrpz_num"] = @"0";
                param[@"xrp_num"] = self.confirmView.kkTextfield.text;
            }
        }
        param[@"pwd"] = [keyboardView.payTF.text md5String];
        if (self.member_id) {
            param[@"member_id"] = _member_id;
        }
        NSLog(@"%@",param);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/user_buy"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [keyboardView.superview removeFromSuperview];
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BOOL toBossMainPage = NO;
                    UIViewController *vc = nil;
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[XPCommunityDetailViewController class]]) {
                            toBossMainPage = YES;
                            vc = controller;
                        }
                    }
                    if (toBossMainPage) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"member_id"] = self.member_id;
        if (!self.parent_id) {
            param[@"parentID"] = self.member_id;
        }else{
            param[@"parentID"] = self.parent_id;
        }
        param[@"xrp_num"] = self.model.info.pay_number;
        param[@"step_votes"] = @(_votes);
        if ([self.paymethod isEqualToString:@"1"]) {
            param[@"xrpz_num"] = @"0";
            param[@"xrpj_num"] = @"0";
        }else if ([self.paymethod isEqualToString:@"2"]){
            if (!self.confirmView.kkTextfield.text ||self.confirmView.kkTextfield.text.length <= 0) {
                double min;
                if (self.model.pay_choose.xrpz.user_xrpz_num  < self.model.pay_choose.xrpz.max_xrpz_num ) {
                    min = self.model.pay_choose.xrpz.user_xrpz_num ;
                }else{
                    min = self.model.pay_choose.xrpz.max_xrpz_num ;
                }
                param[@"xrpz_num"] =[NSString stringWithFormat:@"%f",min];
                
                param[@"xrpj_num"] = @"0";
                param[@"xrp_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] -min];
            }else{
                param[@"xrpz_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [self.confirmView.kkTextfield.text doubleValue]];
                param[@"xrpj_num"] = @"0";
                param[@"xrp_num"] = self.confirmView.kkTextfield.text;
            }
        }else{
            
            if (!self.confirmView.kkTextfield.text ||self.confirmView.kkTextfield.text.length <= 0) {
                double min;
                if (self.model.pay_choose.xrpj.user_xrpj_num  < self.model.pay_choose.xrpj.max_xrpj_num ) {
                    min = self.model.pay_choose.xrpj.user_xrpj_num;
                }else{
                    min = self.model.pay_choose.xrpj.max_xrpj_num;
                }
                param[@"xrpz_num"] = @"0";
                param[@"xrpj_num"] = [NSString stringWithFormat:@"%f",min];
                
                param[@"xrp_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] -min];
            }else{
                param[@"xrpj_num"] = [NSString stringWithFormat:@"%f",[self.model.info.pay_number doubleValue] - [self.confirmView.kkTextfield.text doubleValue]];
                param[@"xrpz_num"] = @"0";
                param[@"xrp_num"] = self.confirmView.kkTextfield.text;
            }
        }
        param[@"pwd"] = [keyboardView.payTF.text md5String];
        NSLog(@"%@",param);
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/activation_user"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [keyboardView.superview removeFromSuperview];
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    BOOL toBossMainPage = NO;
                    UIViewController *vc = nil;
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[XPCommunityDetailViewController class]]) {
                            toBossMainPage = YES;
                            vc = controller;
                        }
                    }
                    if (toBossMainPage) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
              
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }

}


- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"step_votes"] = @(_votes);
    if (_member_id) {
        param[@"member_id"] = self.member_id;
    }
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/step_info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        if (success) {
            self.model = [XPCashModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            [self.header.payButton setTitle:[NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_search_qbzf"),self.model.info.pay_number] forState:UIControlStateNormal];
            if ([self.model.pay_choose.wallet.status isEqualToString:@"0"]) {
                self.header.payButton.hidden = YES;
            }
            if ([self.model.pay_choose.xrpj.status isEqualToString:@"0"]) {
                self.header.rbjButton.hidden = YES;
            }
            if ([self.model.pay_choose.xrpz.status isEqualToString:@"0"]) {
                self.header.rbzButton.hidden = YES;
            }
            [self.tableview reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        XPCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftImg.text = kLocat(@"C_community_cash_taocan");
        cell.rightImg.text = [NSString stringWithFormat:@"%@%@",self.model.info.votes,kLocat(@"C_community_search_votes")];
        return cell;
    }else{
        if (indexPath.row == 0) {
            XPCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftImg.text = kLocat(@"C_community_cash_rongji");
            cell.rightImg.text = self.model.info.number;
            cell.flagImg.image = [UIImage imageNamed:@"community_detail_icon"];
            return cell;
        }else if (indexPath.row == 1){
            XPCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftImg.text = kLocat(@"C_community_cash_current");
            cell.rightImg.text = [NSString stringWithFormat:@"%@%@",self.model.info.cur_votes,kLocat(@"C_community_search_votes")];
            return cell;
        }else{
            XPCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"s4"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftImg.text = kLocat(@"C_community_cash_pay");
            cell.flagImg.image = [UIImage imageNamed:@"community_detail_icon"];
            cell.rightImg.text = self.model.info.pay_number;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
        content.backgroundColor = kColorFromStr(@"F4F4F4");
        return content;
    }else{
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
        content.backgroundColor = kColorFromStr(@"F4F4F4");
        return content;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 20;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.1;
    }else{
        return 0.1;
    }
}






@end
