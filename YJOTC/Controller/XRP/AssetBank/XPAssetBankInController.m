
//
//  XPAssetBankInController.m
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankInController.h"
#import "TPWalletSendKeyboardView.h"
#import "XPAssetBankSuccessController.h"

@interface XPAssetBankInController ()<UITextFieldDelegate,TPWalletSendKeyboardViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dingCunLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuji;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhanRuTitle;

@property (weak, nonatomic) IBOutlet UILabel *aviLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UITextField *volumeTF;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionbutton;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong)NSDictionary *dataDic;


@end

@implementation XPAssetBankInController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupUI];
    [self loadData];
}
-(void)setupUI
{
    self.title = kLocat(@"z_AssetManage");
    _dingCunLabel.textColor = k222222Color;
    _dingCunLabel.font = PFRegularFont(14);
    
    _nameLabel.textColor = k222222Color;
    _nameLabel.font = PFRegularFont(14);
    
    _yuji.textColor = k222222Color;
    _yuji.font = PFRegularFont(16);
    
    _receiveLabel.textColor = k222222Color;
    _receiveLabel.font = PFRegularFont(14);
    
    _zhanRuTitle.textColor = k666666Color;
    _zhanRuTitle.font = PFRegularFont(14);
    
    _aviLabel.textColor = k222222Color;
    _aviLabel.font = PFRegularFont(14);
    
    _currencyLabel.textColor = k222222Color;
    _currencyLabel.font = PFRegularFont(18);
    
    _tipsLabel.textColor = kColorFromStr(@"#DB1414");
    _tipsLabel.font = PFRegularFont(12);
    
    _time.textColor = k666666Color;
    _time.font = PFRegularFont(12);
    
    _timeLabel.textColor = k666666Color;
    _timeLabel.font = PFRegularFont(12);
    
    [_actionbutton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _actionbutton.titleLabel.font = PFRegularFont(16);
    kViewBorderRadius(_actionbutton, 8, 0, kRedColor);
    [_actionbutton addShadow];
    _actionbutton.backgroundColor = kColorFromStr(@"#6189C5");
    [_actionbutton setTitle:kLocat(@"z_zhuanru") forState:UIControlStateNormal];
    
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    _volumeTF.textColor = k222222Color;
    _volumeTF.font = PFRegularFont(16);
    _volumeTF.placeholder = kLocat(@"z_enterzhaunzvol");
    kTextFieldPlaceHoldColor(_volumeTF, k999999Color);
    _volumeTF.delegate = self;
    
    
    _dingCunLabel.text = [NSString stringWithFormat:@"%@: 500XRP",kLocat(@"z_dinhcunyue")];
    _nameLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"z_nick"),kUserInfo.nickName];
    
    _yuji.text = [NSString stringWithFormat:@"%@: ",kLocat(@"z_predictreceive")];
    _zhanRuTitle.text = kLocat(@"z_zhuanruvol");
    _aviLabel.text = [NSString stringWithFormat:@"(%@: %@)",kLocat(@"z_currentyue"),@"0.00"];
    _tipsLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"z_minvol"),_model.min_num,_model.currency_mark];
    
    
    _time.text = kLocat(@"z_thisendtime");
    
    _currencyLabel.text = _model.currency_mark;
   NSTimeInterval timeInteral = _model.add_time.longLongValue + _model.months.integerValue *30*24 *3600;
    _timeLabel.text = [NSString stringWithFormat:@"%@%@",[Utilities returnTimeWithSecond:timeInteral formatter:@"yyyy-MM-dd 23:59:59"],kLocat(@"z_ago")];
    
}
-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"currency_id"] = _model.currency_id;
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kHideHud;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/getInfoByCuurencyId"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            //  "deposit_balance":10025.5,
            //"num":"0.703620"
            _dataDic = [responseObj ksObjectForKey:kData];
            _nameLabel.text = [NSString stringWithFormat:@"%@: %@",kLocat(@"z_nick"),kUserInfo.nickName];
            
            _aviLabel.text = [NSString stringWithFormat:@"(%@: %@)",kLocat(@"z_currentyue"),_dataDic[@"num"]];
            _dingCunLabel.text = [NSString stringWithFormat:@"%@: %@%@",kLocat(@"z_dinhcunyue"),_dataDic[@"deposit_balance"],_model.currency_mark];
        }
    }];
}




- (IBAction)shiftInAction:(id)sender {
    [self hideKeyBoard];
    

    
    if (_volumeTF.text.length == 0) {
        [self showTips:kLocat(@"z_enterzhaunzvol")];
        return;
    }
    if (_volumeTF.text.doubleValue == 0) {
        [self showTips:kLocat(@"z_zhuanruvolshouldbigthan0")];
        return;
    }
    if (_volumeTF.text.doubleValue > [_dataDic[@"num"] doubleValue] ) {
        [self showTips:kLocat(@"z_aviisnotenough")];
        return;
    }
    
    if (_volumeTF.text.doubleValue < _model.min_num.doubleValue) {
        [self showTips:[NSString stringWithFormat:@"%@%@",kLocat(@"z_theminvolis"),_model.min_num]];
        return;
    }
    
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
    
    if (keyboardView.payTF.text.length == 0) {
        [kKeyWindow showWarning:kLocat(@"k_popview_list_counter_pwd_placehoder")];
        return;
    }
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"num"] = _volumeTF.text;
    param[@"id"] = _model.xid;
    param[@"paypwd"] = keyboardView.payTF.text;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Money/addMoneyInterest"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            kLOG(@"操作成功");
            [keyboardView.superview removeFromSuperview];

            XPAssetBankSuccessController *vc = [XPAssetBankSuccessController new];
            vc.resultDic = [responseObj ksObjectForKey:kData];
            vc.model = _model;
            kNavPush(vc);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidBuyAnAssetBankKey" object:nil];
            
            
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}






-(void)txtFieldDidChange:(NSNotification *)noti
{
    if (noti.object == _volumeTF) {
        
        if (_volumeTF.text.doubleValue > 0) {
            
            [self calculateTheEarnings];

        }else{
            _receiveLabel.text = @"--";
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_volumeTF == textField) {
        
        if (_volumeTF.text.doubleValue >= [_dataDic[@"num"] doubleValue] ) {
            _volumeTF.text = ConvertToString(_dataDic[@"num"]);
            [self calculateTheEarnings];
        }
    }
}
/**  計算收益  */
-(void)calculateTheEarnings
{
    double result = _volumeTF.text.doubleValue + _volumeTF.text.doubleValue*_model.rate.doubleValue/100/365*_model.months.intValue*30;
    _receiveLabel.text = [NSString stringWithFormat:@"%.6f%@",result,_model.currency_mark];
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
@end
