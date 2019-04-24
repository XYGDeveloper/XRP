//
//  TPWalletAddressAddController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAddressAddController.h"
#import "KSScanningViewController.h"


@interface TPWalletAddressAddController ()
@property(nonatomic,strong)UITextField *addTF;
@property(nonatomic,strong)UITextField *tagTF;

@property(nonatomic,strong)UITextField *xrpTF;


@end

@implementation TPWalletAddressAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}
-(void)setupUI
{
    CGFloat w ;
    
    if (_dateDic) {
        self.title = kLocat(@"W_editaddress");
        w = kScreenW/2;

    }else{
        w = 0;
        self.title = kLocat(@"W_addaddress");
    }
    
    self.view.backgroundColor = kTableColor;
    
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, kNavigationBarHeight + 10, kScreenW, 45)];
    [self.view addSubview:topView];
    topView.backgroundColor = kWhiteColor;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 60, 20) text:kLocat(@"W_walletaddress") font:PFRegularFont(14) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [topView addSubview:label1];
    [label1 alignVertical];
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 12 - 22, 0, 22, 22)];
    [topView addSubview:scanButton];
    [scanButton setImage:kImageFromStr(@"bao_icon_sys") forState:UIControlStateNormal];
    [scanButton alignVertical];
    
    UITextField *addTF = [[UITextField alloc] initWithFrame:kRectMake(80, 0, kScreenW - 80 - 44, 45)];
    addTF.textColor = kLightGrayColor;
    addTF.font = PFRegularFont(14);
    [topView addSubview:addTF];
    [addTF alignVertical];
    
    UIView *topView1 = [[UIView alloc] initWithFrame:kRectMake(0, topView.bottom + 5, kScreenW, 45)];
    [self.view addSubview:topView1];
    topView1.backgroundColor = kWhiteColor;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 60, 20) text:kLocat(@"W_addresstag") font:PFRegularFont(14) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [topView1 addSubview:label2];
    [label2 alignVertical];
    
    UITextField *tagTF = [[UITextField alloc] initWithFrame:kRectMake(80, 0, kScreenW - 10, 45)];
    tagTF.textColor = kLightGrayColor;
    tagTF.font = PFRegularFont(14);
    [topView1 addSubview:tagTF];
    [tagTF alignVertical];
    
    addTF.placeholder = kLocat(@"W_enterorpasteaddress");
    tagTF.placeholder = kLocat(@"s0115_nameoptioinal");
    kTextFieldPlaceHoldColor(tagTF, kColorFromStr(@"#999999"));
    kTextFieldPlaceHoldColor(addTF, kColorFromStr(@"#999999"));
    
    
    UIView *topView2 = [[UIView alloc] initWithFrame:kRectMake(0, topView1.bottom + 5, kScreenW, 45)];
    [self.view addSubview:topView2];
    topView2.backgroundColor = kWhiteColor;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:kRectMake(12, 0, 60, 20) text:kLocat(@"M_XRPtag") font:PFRegularFont(14) textColor:kLightGrayColor textAlignment:0 adjustsFont:YES];
    [topView2 addSubview:label3];
    [label3 alignVertical];
    
    UITextField *xrpTF = [[UITextField alloc] initWithFrame:kRectMake(80, 0, kScreenW - 10, 45)];
    xrpTF.textColor = kLightGrayColor;
    xrpTF.font = PFRegularFont(14);
    [topView2 addSubview:xrpTF];
    [xrpTF alignVertical];
    xrpTF.keyboardType = UIKeyboardTypeNumberPad;
    _xrpTF = xrpTF;
    
    addTF.placeholder = kLocat(@"W_enterorpasteaddress");
    tagTF.placeholder = kLocat(@"W_addresstag");
    kTextFieldPlaceHoldColor(tagTF, kColorFromStr(@"#999999"));
    kTextFieldPlaceHoldColor(addTF, kColorFromStr(@"#999999"));
    
    xrpTF.placeholder = kLocat(@"M_XRPtag");
    kTextFieldPlaceHoldColor(xrpTF, kColorFromStr(@"#999999"));
    if (_dateDic) {
        _xrpTF.text = ConvertToString(_dateDic[@"tag"]);
    }
    topView2.hidden = YES;
    if (_isXrp || _isEOS ) {
        topView2.hidden = NO;
    }
    if (_isEOS) {
        label3.text = @"memo";
        xrpTF.placeholder = @"memo";
    }
    
    
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:kRectMake(0, kScreenH - 45, w, 45) title:kLocat(@"Dis_Delete") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:deleteButton];
    deleteButton.backgroundColor = kColorFromStr(@"#E4A646");
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *cancelButton = [[UIButton alloc ]initWithFrame:kRectMake(deleteButton.right, deleteButton.y, 0, 45) title:kLocat(@"Cancel") titleColor:kColorFromStr(@"#8A94A8") font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#434A5D");
    [cancelButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *savelButton = [[UIButton alloc ]initWithFrame:kRectMake(cancelButton.right, deleteButton.y, kScreenW - w, 45) title:kLocat(@"W_Save") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [self.view addSubview:savelButton];
    savelButton.backgroundColor = kColorFromStr(@"#6189C5");
    
    [savelButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];

    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];

    _tagTF = tagTF;
    _addTF = addTF;
    
    if (_dateDic) {
        _addTF.text = _dateDic[@"qianbao_url"];
        if (isNull(_dateDic[@"names"])) {
            _tagTF.text = @"";
        }else{
            _tagTF.text = _dateDic[@"names"];
        }
    }
}
-(void)scanAction
{
    __weak typeof(self)weakSelf = self;
    KSScanningViewController *vc = [[KSScanningViewController alloc] init];
    vc.callBackBlock = ^(NSString *scannedStr) {
        weakSelf.addTF.text = scannedStr;
    };
    [self presentViewController:[[YJBaseNavController alloc]initWithRootViewController:vc]  animated:YES completion:nil];
}
-(void)deleteAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kLocat(@"W_suertodeletethisaddress") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:kLocat(@"W_suertodeletethisaddress")];
    [hogan addAttribute:NSFontAttributeName value:PFRegularFont(12) range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:kColorFromStr(@"#E84D4D") range:NSMakeRange(0, [[hogan string] length])];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:kLocat(@"W_confirmdelete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"key"] = kUserInfo.token;
        param[@"token_id"] = @(kUserInfo.uid);
        param[@"currency_id"] = _currencyID;
        param[@"id"] = _dateDic[@"id"];

        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/deleteAddress"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            if (success) {
                [self showTips:[responseObj ksObjectForKey:kMessage]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    kNavPop;
                });
            }else{
                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [desAction setValue:kColorFromStr(@"#11B1ED") forKey:@"_titleTextColor"];
    [cancelAction setValue:kColorFromStr(@"#11B1ED") forKey:@"_titleTextColor"];

    [alertController addAction:desAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)saveAction
{
    if (_addTF.text.length == 0) {
        [self showTips:kLocat(@"W_plzenterwalletaddress")];
        return;
    }
    if (_tagTF.text.length == 0) {
        [self showTips:kLocat(@"W_plzenteraddresstag")];
        return;
    }
    
    if (_isXrp) {
        if (_xrpTF.text.length == 0) {
            [self showTips:kLocat(@"M_enterxrptag")];
            return;
        }
    }else if (_isEOS){
        if (_xrpTF.text.length == 0) {
            [self showTips:kLocat(@"M_enterxrptag_EOS")];
            return;
        }
    }

    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = _currencyID;
    
    NSString *url;
    if (_dateDic) {
        url = @"/Wallet/updateAddress";
        param[@"id"] = _dateDic[@"id"];
    }else{
        url = @"/Wallet/addAddress";
    }
    if (_isXrp || _isEOS) {
        param[@"tag"] = _xrpTF.text;
    }
    
    param[@"names"] = _tagTF.text;
    param[@"address"] = _addTF.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:url] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                kNavPop;
            });
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}



@end
