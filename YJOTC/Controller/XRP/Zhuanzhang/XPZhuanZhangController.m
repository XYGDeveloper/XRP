//
//  XPZhuanZhangController.m
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPZhuanZhangController.h"
#import "XPZhuanZhangConfirmView.h"
#import "TPWalletSendKeyboardView.h"
#import "XPZhuanZhangSuccessController.h"

CGFloat kPickViewHeight = (198+45);



@interface XPZhuanZhangController ()<TPWalletSendKeyboardViewDelegate,NTESVerifyCodeManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UILabel *receiveAccountLabel;
@property (weak, nonatomic) IBOutlet UITextField *receiveAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *receiveIDTF;
@property (weak, nonatomic) IBOutlet UILabel *receiveIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UITextField *currencyTF;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UITextField *volumeTF;
@property (weak, nonatomic) IBOutlet UILabel *aviLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMAigin;

@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,copy)NSString *phoneCode;
@property(nonatomic,copy)NSString *verifyStr;


@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *coverView;

@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,strong)NSArray *currencyArr;

@property (weak, nonatomic) IBOutlet UIButton *currencyButton;

@property(nonatomic,assign)BOOL isXrp;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;

@property(nonatomic,copy)NSString *currentFee;




@end

@implementation XPZhuanZhangController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currencyArr = @[kLocat(@"s0221_myzengsong"),kLocat(@"hz_mywallet"),kLocat(@"hz_mywallet1"),kLocat(@"hz_mywallet2")];
    [self setupUI];
    [self loadCurrencyInfo];
    [self manager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


-(void)setupUI
{
    self.title = kLocat(@"Z_memberechange");
    
    self.view.backgroundColor = kTableColor;
    
    _receiveAccountLabel.textColor = k222222Color;
    _receiveAccountLabel.font = PFRegularFont(12);
    
    _receiveIDLabel.textColor = k222222Color;
    _receiveIDLabel.font = PFRegularFont(12);

    _currencyLabel.textColor = k222222Color;
    _currencyLabel.font = PFRegularFont(12);
    
    _volumeLabel.textColor = k222222Color;
    _volumeLabel.font = PFRegularFont(12);
    
    _aviLabel.textColor = k666666Color;
    _aviLabel.font = PFRegularFont(12);
    
    _receiveAccountTF.textColor = k222222Color;
    _receiveAccountTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_receiveAccountTF, k999999Color);
    
    _receiveIDTF.textColor = k222222Color;
    _receiveIDTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_receiveIDTF, k999999Color);
    _receiveIDTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _currencyTF.textColor = k222222Color;
    _currencyTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_currencyTF, k999999Color);
    
    _volumeTF.textColor = k222222Color;
    _volumeTF.font = PFRegularFont(16);
    kTextFieldPlaceHoldColor(_volumeTF, k999999Color);
    
    [_actionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _actionButton.titleLabel.font = PFRegularFont(16);
    kViewBorderRadius(_actionButton, 8, 0, kRedColor);
    [_actionButton addShadow];
    _actionButton.backgroundColor = kColorFromStr(@"#6189C5");

    [_actionButton setTitle:kLocat(@"R_Submit") forState:UIControlStateNormal];
    if (kScreenW < 321) {
        _bottomMAigin.constant = 10;
    }
    
    kViewBorderRadius(_topView, 8, 0, kRedColor);
    [_topView addShadow];
    kViewBorderRadius(_midView, 8, 0, kRedColor);
    [_midView addShadow];

    _topView.backgroundColor = kWhiteColor;
    _midView.backgroundColor = kWhiteColor;
    
    _currencyTF.userInteractionEnabled = NO;
    _currencyTF.text = @"XRP";
    
    
    _volumeLabel.text = kLocat(@"W_SendVol");
    
    _receiveAccountLabel.text = kLocat(@"Z_receiveAccount");
    _receiveAccountTF.placeholder = kLocat(@"Z_enteraccount");
    _receiveIDLabel.text = kLocat(@"Z_receiveid");
    _receiveIDTF.placeholder = kLocat(@"Z_enterid");
    
    _currencyLabel.text = kLocat(@"Z_zzcurrency");
    _currencyTF.placeholder = kLocat(@"Z_enterid");
    
    _volumeLabel.text = kLocat(@"Z_sendvol");
    _volumeTF.placeholder = kLocat(@"Z_entervol");
    _aviLabel.text = @"";
    _volumeTF.delegate = self;
    _volumeTF.keyboardType = UIKeyboardTypeDecimalPad;
    [_currencyButton setTitleColor:k666666Color forState:UIControlStateNormal];
    _currencyButton.titleLabel.font = PFRegularFont(12);
    _currencyButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [_currencyButton addTarget:self action:@selector(showPickViewWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [_currencyButton setTitle:[NSString stringWithFormat:@"%@ ",_currencyArr[_selectedIndex]] forState:UIControlStateNormal];

    _feeLabel.textColor = kColorFromStr(@"#E1545A");
    _feeLabel.font = PFRegularFont(10);
//    _feeLabel.text = @"*當前手續費費率：1%";
    _realLabel.textColor = k666666Color;
    _realLabel.font = PFRegularFont(12);
    _realLabel.text = [NSString stringWithFormat:@"%@: 0 XRP",kLocat(@"s0219_kouchu")];
    
}
- (IBAction)submitAction:(id)sender {

    
    if (_receiveAccountTF.text.length == 0) {
        [self showTips:kLocat(@"Z_enteraccount")];
        return;
    }
    if (_receiveIDTF.text.length == 0) {
        [self showTips:kLocat(@"Z_enterid")];
        return;
    }

    
    if (_volumeTF.text.length == 0) {
        [self showTips:kLocat(@"Z_entervol")];
        return;
    }
    if (_volumeTF.text.doubleValue == 0) {
        [self showTips:kLocat(@"Z_sendvolis0")];
        return;
    }
    
    
    if (_selectedIndex == 0) {
        if (_volumeTF.text.doubleValue + _currentFee.doubleValue > [_infoDic[@"num2"] doubleValue]) {
            [self showTips:kLocat(@"Z_aviisnotenough")];
            return;
        }
    }else if (_selectedIndex == 1){
        if (_volumeTF.text.doubleValue + _currentFee.doubleValue > [_infoDic[@"num1"] doubleValue]) {
            [self showTips:kLocat(@"Z_aviisnotenough")];
            return;
        }
    }else  if (_selectedIndex == 2){
        if (_volumeTF.text.doubleValue + _currentFee.doubleValue > [_infoDic[@"num4"] doubleValue]) {
            [self showTips:kLocat(@"Z_aviisnotenough")];
            return;
        }
    }else  if (_selectedIndex == 3){
        if (_volumeTF.text.doubleValue + _currentFee.doubleValue > [_infoDic[@"num6"] doubleValue]) {
            [self showTips:kLocat(@"Z_aviisnotenough")];
            return;
        }
    }
    else{
        if (_volumeTF.text.doubleValue + _currentFee.doubleValue > [_infoDic[@"num3"] doubleValue]) {
            [self showTips:kLocat(@"Z_aviisnotenough")];
            return;
        }
    }
    
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
    [kKeyWindow addSubview:bgView];
    
    XPZhuanZhangConfirmView *confirmView = [[[NSBundle mainBundle] loadNibNamed:@"XPZhuanZhangConfirmView" owner:self options:nil] lastObject];
    confirmView.frame = kRectMake(0, kScreenH - 400, kScreenW, 400);
    [bgView addSubview:confirmView];
//    [confirmView.closeButton addTarget:self action:@selector(hideConfirmView:) forControlEvents:UIControlEventTouchUpInside];
//    [confirmView.actionButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmView.accountLabel.text = _receiveAccountTF.text;
    
    confirmView.volumeLabel.text = [NSString stringWithFormat:@"%@ %@",_volumeTF.text,@"XRP"];
    confirmView.paywayLabel.text = _currencyArr[_selectedIndex];
    
    
    confirmView.callBackBlock = ^(UIButton *sureButton) {
        [self confirmAction:sureButton];
    };
    
    confirmView.mingxiLabel.hidden = NO;
    confirmView.mingxiLabel.text = kLocat(@"OTC_order_realcost");
    confirmView.mywalletLabelContent.hidden = NO;
    
    NSString *real = [NSString floatOne:_currentFee calculationType:CalculationTypeForAdd floatTwo:_volumeTF.text];
    
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
    [keyBoardView.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];

//    keyBoardView.showPayView = YES;
}
#pragma mark - 键盘回调
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
        param[@"type"] = @"transfer";
        param[@"code"] = keyboardView.codeTF.text;
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
        [self tradeAction:keyboardView];
    }
}

-(void)tradeAction:(TPWalletSendKeyboardView *)keyboardView
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"to_member_id"] = _receiveIDTF.text;
    param[@"account"] = _receiveAccountTF.text;
    param[@"phone_code"] = _phoneCode;
    
//    param[@"currency_id"] = _infoDic[@"currency_id"];
    
    if (_selectedIndex == 0) {
        param[@"type"] = @"2";

    }else if (_selectedIndex == 1){
        param[@"type"] = @"1";

    }else if (_selectedIndex == 2){
        param[@"type"] = @"4";
    }else if (_selectedIndex == 3){
        param[@"type"] = @"6";
    }
    else{
        param[@"type"] = @"3";

    }
    
    param[@"num"] = _volumeTF.text;
    param[@"pwd"] = keyboardView.payTF.text;
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/accountOperation"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [keyboardView.superview removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshXPXRPAssetViewControllerKey" object:nil];

            XPZhuanZhangSuccessController *vc = [XPZhuanZhangSuccessController new];
            vc.vol = _volumeTF.text;
            kNavPush(vc);
        }else{
            
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];

}


-(void)loadCurrencyInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Trade/accountQuery"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            
            _infoDic = [responseObj ksObjectForKey:kData];
            kLOG(@"%@",_infoDic);
            /**
             num1 我的钱包可用余额
              num2 xrp+可用余额
             
             */
            _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num2"],@"XRP"];
            _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"xrp_fee"]];

            if ([_infoDic[@"num3"] doubleValue] > 0) {
                _currencyArr = @[kLocat(@"s0221_myzengsong"),kLocat(@"hz_mywallet"),_infoDic[@"num4_name"],_infoDic[@"num6_name"],kLocat(@"A_boss_rbj")];
            }
            
            if (_isXRPG) {
                _selectedIndex = 3;
                [_currencyButton setTitle:_currencyArr[_selectedIndex] forState:UIControlStateNormal];
                _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num3"],@"XRP"];
                _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"xrpj_fee"]];
            }
            
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

//性别..
-(void)showPickViewWithTag:(NSInteger )tag
{
    [self hideKeyBoard];

    _selectedIndex = 0;
    self.coverView.hidden = NO;
    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, kPickViewHeight)];
    [self.coverView addSubview:bgView];
    bgView.tag = 100;
    
    UIView *titleView = [[UIView alloc]initWithFrame:kRectMake(0, 0 , kScreenW, 45)];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, titleView.height)];
    [titleView addSubview:cancelButton];
    [cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColorFromStr(@"#066B98") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = PFRegularFont(16);
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton addTarget:self action:@selector(hidePickView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIButton *confirmlButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, titleView.height)];
    [titleView addSubview:confirmlButton];
    confirmlButton.right = kScreenW - kMargin;
    [confirmlButton setTitle:kLocat(@"Confirm") forState:UIControlStateNormal];
    [confirmlButton setTitleColor:kColorFromStr(@"066B98") forState:UIControlStateNormal];
    confirmlButton.titleLabel.font = PFRegularFont(16);
    confirmlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmlButton.tag = tag;
    [confirmlButton addTarget:self action:@selector(confirmChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    [cancelButton alignVertical];
//    [confirmlButton alignVertical];
    
    if (_pickerView) {
        [_pickerView removeAllSubviews];
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
    _pickerView = [[UIPickerView alloc]initWithFrame:kRectMake(0, 45, kScreenW, kPickViewHeight - 45)];
    _pickerView.tag = tag;
    _pickerView.backgroundColor = kWhiteColor;
    [bgView addSubview:_pickerView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    //        _addressTF.text = self.bankArray.firstObject.bankname;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.frame = kRectMake(0, kScreenH - kPickViewHeight, kScreenW, kPickViewHeight);
    }];
    
}
-(void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, kPickViewHeight);
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
            view.frame = kRectMake(0, kScreenH, kScreenW, kPickViewHeight);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
    
    [_currencyButton setTitle:[NSString stringWithFormat:@"%@ ",_currencyArr[_selectedIndex]] forState:UIControlStateNormal];
    _volumeTF.text = nil;
    if (_selectedIndex == 0) {
        _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num2"],@"XRP"];
        _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"xrp_fee"]];
        _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),@"0"];
        _currencyTF.text = @"XRP";
    }else if (_selectedIndex == 1){
        _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num1"],@"XRP"];
        _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"wallet_fee"]];
        _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),@"0"];
        _currencyTF.text = @"XRP";
    }else if (_selectedIndex == 2){
        _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num4"],@"GAC"];
        _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"gac_lock_fee"]];
        _currencyTF.text = @"GAC";
        _realLabel.text = [NSString stringWithFormat:@"%@: %@ GAC",kLocat(@"s0219_kouchu"),@"0"];
    }else if (_selectedIndex == 3){
        _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num6"],@"GAC"];
        _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"gac_internal_buy_fee"]];
        _currencyTF.text = @"GAC";
        _realLabel.text = [NSString stringWithFormat:@"%@: %@ GAC",kLocat(@"s0219_kouchu"),@"0"];
    }
    else{
        _currencyTF.text = @"XRP";
        _aviLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"Z_avi"),_infoDic[@"num3"],@"XRP"];
        _feeLabel.text = [NSString stringWithFormat:@"%@：%@%%",kLocat(@"s0219_currenthuzhuanfee"),_infoDic[@"xrpj_fee"]];
        _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),@"0"];
    }
}


#pragma mark - 选择器
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _currencyArr.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = kColorFromStr(@"#E4E4E4");
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = kColorFromStr(@"#E4E4E4");

    UIView *cellView = view;
    if (cellView == nil) {
        cellView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 34)];
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, 0, kScreenW, 34) text:@"BTC" font:PFRegularFont(16) textColor:k323232Color textAlignment:1 adjustsFont:YES];
        [cellView addSubview:label];
        label.tag = 123;
    }
    for (UILabel *label in cellView.subviews) {
        if (label.tag == 123) {
            label.text = _currencyArr[row];
        }
    }
    return cellView;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedIndex = row;
}


-(void)txtFieldDidChange:(NSNotification *)noti
{
    if (noti.object == _volumeTF) {
        
        float max;
        
        double fee;
        
        if (_selectedIndex == 0) {
            max = [_infoDic[@"num2"] floatValue];
        }else if (_selectedIndex == 1){
            max = [_infoDic[@"num1"] floatValue];
        }else if (_selectedIndex == 2){
            max = [_infoDic[@"num4"] floatValue];
        }else if (_selectedIndex == 3){
            max = [_infoDic[@"num6"] floatValue];
        }
        else{
            max = [_infoDic[@"num3"] floatValue];
        }
        
        if (_volumeTF.text.doubleValue > max) {
            _volumeTF.text = ConvertToString(@(max));
        }

        if (_selectedIndex == 0) {
            fee = _volumeTF.text.doubleValue * [_infoDic[@"xrp_fee"] doubleValue]/100;
        }else if (_selectedIndex == 1){
            fee = _volumeTF.text.doubleValue * [_infoDic[@"wallet_fee"] doubleValue]/100;
        }else if (_selectedIndex == 2){
            fee = _volumeTF.text.doubleValue * [_infoDic[@"gac_lock_fee"] doubleValue]/100;
        }else if (_selectedIndex == 3){
            fee = _volumeTF.text.doubleValue * [_infoDic[@"gac_internal_buy_fee"] doubleValue]/100;
        }
        else{
            fee = _volumeTF.text.doubleValue * [_infoDic[@"xrpj_fee"] doubleValue]/100;

        }
  
        if (_volumeTF.text.length == 0) {
            _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),@"0"];
            _currentFee = @"0";
        }else{
            _currentFee = [ConvertToString(@(fee)) rouningDownByScale:6];
            _realLabel.text = [ConvertToString(@(fee)) rouningDownByScale:6];
            
            _realLabel.text = [NSString stringWithFormat:@"%@: %@ XRP",kLocat(@"s0219_kouchu"),_realLabel.text];
        }
    }
    
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


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
