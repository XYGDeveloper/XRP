//
//  TPOTCPostDetailController.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostDetailController.h"
#import "TPOTCPostDetailListCell.h"
#import "TPOTCPostDetailSellCell.h"
#import "TPOTCPostDetailPayCell.h"
#import "TPOTCPayWayModel.h"
#import "TPOTCPayWayListController.h"
#import "TPOTCPostStatusController.h"
#import "NSObject+SVProgressHUD.h"
#import "NSString+Operation.h"
#import "TPWalletSendKeyboardView.h"

@interface TPOTCPostDetailController ()<UITableViewDelegate,UITableViewDataSource,TPWalletSendKeyboardViewDelegate,NTESVerifyCodeManagerDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UIButton *confirmButton;

@property(nonatomic,strong)NSMutableArray<TPOTCPayWayModel *> *payWayArray;

@property(nonatomic,strong)NSString *realVolume;

@property(nonatomic,strong)NTESVerifyCodeManager *manager;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,copy)NSString *phoneCode;
@property(nonatomic,copy)NSString *verifyStr;

@property(nonatomic,strong)NSMutableArray *typesArray;
@property(nonatomic,strong)TPWalletSendKeyboardView *keyboardView;
@property(nonatomic,assign)BOOL isfirst;

@property(nonatomic,strong)UIView *bgView;



@end

@implementation TPOTCPostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isfirst = YES;
    [self setupUI];
    _payWayArray = [NSMutableArray array];
    _typesArray = [NSMutableArray new];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self loadPayWayInfo];
    [self initVerifyConfigure];
    [self setStatusBarColor:kNaviColor];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setStatusBarColor:kClearColor];

}

-(void)setupUI
{
//    self.view.backgroundColor = kColorFromStr(@"#171F34");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kStatusBarHeight, kScreenW, kScreenH-kStatusBarHeight - 45) style:UITableViewStyleGrouped];
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
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostDetailListCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostDetailListCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostPaywayCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostPaywayCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TPOTCPostDetailSellCell" bundle:nil] forCellReuseIdentifier:@"TPOTCPostDetailSellCell"];

    
    
    _tableView.tableHeaderView = [self setHeaderView];
    _tableView.tableFooterView = [self setupFootView];
    
    [self setupBottomView];
}

-(UIView *)setHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 105)];
    headView.backgroundColor = kTableColor;
    
    UIImageView *icon  = [[UIImageView alloc] initWithFrame:kRectMake(12, 23, 40, 40)];
    [headView addSubview:icon];
//    icon.image = kImageFromStr(@"");
    [icon setImageWithURL:[NSURL URLWithString:ConvertToString(_currencyInfo[@"currency_logo"])] placeholder:nil];
    
    NSString *titleStr;
    if (_type == TPOTCPostDetailControllerBuy) {
        titleStr = kLocat(@"OTC_post_postbuyad");
    }else{
        titleStr = kLocat(@"OTC_post_postsellad");
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(icon.right + 10, 2, 200, 18) text:titleStr font:PFRegularFont(18) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [headView addSubview:title];
    title.centerY = icon.centerY;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(12, icon.bottom + 18, 300, 15) text:kLocat(@"OTC_post_confirmthemesg") font:PFRegularFont(14) textColor:kColorFromStr(@"#EA6E44") textAlignment:0 adjustsFont:YES];
    [headView addSubview:tipsLabel];
    
    return headView;
}
-(UIView *)setupFootView
{
    __weak typeof(self)weakSelf = self;

    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 60)];
    view.backgroundColor = kTableColor;

    UIButton *button = [[UIButton alloc]initWithFrame:kRectMake(0, 0, 300, 14)];
    [view addSubview:button];
    [button alignVertical];
    button.centerX = kScreenW/2+5;
    NSString *str = [NSString stringWithFormat:@"%@%@",kLocat(@"OTC_post_haverad"),kLocat(@"OTC_post_userpro")];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:kLocat(@"OTC_post_userpro")];
    
    [attr addAttribute:NSForegroundColorAttributeName
                 value:k666666Color
                 range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSFontAttributeName
                 value:PFRegularFont(12)
                 range:NSMakeRange(0, str.length)];
    
    
    [attr addAttribute:NSForegroundColorAttributeName
                          value:kColorFromStr(@"#066B98")
                          range:range];
    [button setAttributedTitle:attr forState:UIControlStateNormal];
    
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
    //协议
        BaseWebViewController *vc = [[BaseWebViewController alloc] initWithWebViewFrame:kRectMake(0, kStatusBarHeight, kScreenW, kScreenH - kStatusBarHeight) title:nil];
        vc.urlStr = [NSString stringWithFormat:@"%@%@",kBasePath,@"/mobile/News/detail/position_id/154"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [button sizeToFit];
    [button alignVertical];
    button.centerX = kScreenW/2+5;
    
    
    
    UIButton *statusButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, 26, 26)];
    [view addSubview:statusButton];
    statusButton.centerY = button.centerY;
    statusButton.right = button.x;

    [statusButton setImage:kImageFromStr(@"fbcs_icon_nox") forState:UIControlStateNormal];
    [statusButton setImage:kImageFromStr(@"fbcs_icon_prex") forState:UIControlStateSelected];
    statusButton.selected = YES;
    _confirmButton = statusButton;

    [statusButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        weakSelf.confirmButton.selected = !weakSelf.confirmButton.selected;

    }];
    return view;
}

-(void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, _tableView.bottom, kScreenW, 45)];
    [self.view addSubview:bottomView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:kRectMake(0, 0, bottomView.width/2, bottomView.height) title:kLocat(@"OTC_post_postad") titleColor:kWhiteColor font:PFRegularFont(15) titleAlignment:0];
    [bottomView addSubview:leftButton];

    UIButton *rightButton = [[UIButton alloc] initWithFrame:kRectMake(leftButton.right, 0, bottomView.width/2, bottomView.height) title:kLocat(@"OTC_post_back") titleColor:kColorFromStr(@"#9BC1ED") font:PFRegularFont(15) titleAlignment:0];
    [bottomView addSubview:rightButton];
    
    leftButton.backgroundColor = kColorFromStr(@"#6189C5");
    rightButton.backgroundColor = kColorFromStr(@"#8A94A8");
    
    [leftButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadPayWayInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Bank/active"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            [_typesArray removeAllObjects];
            NSDictionary *dic = [responseObj ksObjectForKey:kData];
            [self.payWayArray removeAllObjects];
            
            if ([dic[@"alipay"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"alipay"]];
                model.isSelected = YES;
                model.type = @"alipay";
                [self.payWayArray addObject:model];
                [_typesArray addObject:@"alipay"];
            }
            if ([dic[@"wechat"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"wechat"]];
                model.isSelected = YES;
                model.type = @"wechat";

                [self.payWayArray addObject:model];
                [_typesArray addObject:@"wechat"];

            }
            if ([dic[@"bank"] isKindOfClass:[NSDictionary class]]) {
                TPOTCPayWayModel *model = [TPOTCPayWayModel modelWithJSON:dic[@"bank"]];
                model.isSelected = YES;
                model.type = @"bank";

                [self.payWayArray addObject:model];
                [_typesArray addObject:@"bank"];

            }
            
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
            if (self.payWayArray.count == 0) {
                [self showTips:kLocat(@"OTC_post_setpayway")];
            }
        }else{
            [_typesArray  removeAllObjects];
            [self.payWayArray removeAllObjects];
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
            [self showTips:kLocat(@"OTC_post_setpayway")];

        }
        
    }];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return self.titleArray.count - 2;
    }else{
        
//        if (self.payWayArray.count == 0) {
//            return 1;
//        }else{
            return self.payWayArray.count;
//        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        
        static NSString *rid = @"TPOTCPostDetailListCell";
        TPOTCPostDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        if (indexPath.section == 0) {
            cell.itemLabel.text = self.titleArray[indexPath.row];
            if (indexPath.row == 1) {
                cell.lineView.hidden = NO;
                cell.infoLabel.text = _price;
            }else{
                cell.lineView.hidden = YES;
                cell.infoLabel.text = _currencyInfo[@"currency_name"];
            }
        }else{
            cell.itemLabel.text = self.titleArray[indexPath.row+2];
            if (indexPath.row == 7) {
                cell.lineView.hidden = NO;
            }else{
                cell.lineView.hidden = YES;
            }
            if (indexPath.row == 0) {
                cell.infoLabel.text = _volume;

            }else if (indexPath.row == 1){
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_sum];
            }else if (indexPath.row == 2){//最高交易额
                if (_maxDeal) {
                    cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_maxDeal];
                }else{
                    cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_sum];
                }
            }else if (indexPath.row == 3){//最低交易额
                if (_minDeal) {
                    cell.infoLabel.text = [NSString stringWithFormat:@"%@ CNY",_minDeal];
                }else{
                    cell.infoLabel.text = @"1 CNY";
                }
            }else if (indexPath.row == 4){//手续费率
                cell.infoLabel.text = [NSString stringWithFormat:@"%@%%",_currencyInfo[@"currency_otc_sell_fee"]];
            }else if (indexPath.row == 5){//手续费
                
                cell.infoLabel.text = [NSString floatOne:_volume calculationType:CalculationTypeForMultiply floatTwo:[NSString stringWithFormat:@"%@",@([_currencyInfo[@"currency_otc_sell_fee"] doubleValue]/100.0)]];
                
                cell.infoLabel.text = [cell.infoLabel.text rouningDownByScale:6];
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@",cell.infoLabel.text,_currencyInfo[@"currency_name"]];
                
            }else if (indexPath.row == 6){//扣费方式
                
                if (_type == TPOTCPostDetailControllerSell) {
                    cell.infoLabel.text = kLocat(@"OTC_post_directpayfee");
                }
            }else if (indexPath.row == 7){//实际支付数量

                cell.infoLabel.text = [NSString floatOne:_volume calculationType:CalculationTypeForMultiply floatTwo:[NSString stringWithFormat:@"%@",@([_currencyInfo[@"currency_otc_sell_fee"] doubleValue]/100.0 + 1)]];
                cell.infoLabel.text = [cell.infoLabel.text rouningDownByScale:6];

                _realVolume = cell.infoLabel.text;
            }

            
        }
        
        
        
        return cell;
        
    }else{
        
        if (_type == TPOTCPostDetailControllerBuy) {
            static NSString *rid = @"TPOTCPostDetailPayCell";
            TPOTCPostDetailPayCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
            }
            
            return cell;
        }else{
            
//            if (self.payWayArray.count > 0) {
            
                static NSString *rid = @"TPOTCPostDetailSellCell";
                TPOTCPostDetailSellCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
                }
                
                cell.model = self.payWayArray[indexPath.row];
                cell.swtch.tag = indexPath.row;
            
            cell.swtch.on = self.payWayArray[indexPath.row].isSelected;
            __weak typeof(self)weakSelf = self;

                [cell.swtch addTarget:self action:@selector(selectPayWayAction:) forControlEvents:UIControlEventValueChanged];
                [cell.modifyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
                    kNavPushSafe(vc);
                }];
                
                return cell;
//            }else{
//                UITableViewCell *cell = [UITableViewCell new];
//                cell.selectionStyle = 0;
//                cell.contentView.backgroundColor = kColorFromStr(@"1E1F22");
//
//                UIImageView *img = [[UIImageView alloc] initWithFrame:kRectMake((kScreenW - 35)/2, 5, 35, 35)];
//                [cell.contentView addSubview:img];
//                img.image = kImageFromStr(@"shoukuan_icon_shc");
//
//                return cell;
//            }
   
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (self.payWayArray.count == 0) {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (_type == TPOTCPostDetailControllerBuy) {
            return 54;
        }else{
//            if (self.payWayArray.count == 0) {
//                return 45;
//            }else{
                return 70;
//            }
        }
    }else{
        return 25;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        return 38;
    }
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 38)];
        view.backgroundColor = kTableColor;
        view.userInteractionEnabled = YES;
        NSString *str;
        if (_type == TPOTCPostDetailControllerSell) {
            str = kLocat(@"OTC_post_setgetway");
        }else{
            str = kLocat(@"OTC_post_setpayway1");
        }
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 10, 200, 30) text:str font:PFRegularFont(16) textColor:k222222Color textAlignment:0 adjustsFont:YES];
        [view addSubview:label];
        [label alignVertical];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            TPOTCPayWayListController *vc = [TPOTCPayWayListController new];
            kNavPush(vc);
        }]];

        UIImageView *arrow = [[UIImageView alloc] initWithFrame:kRectMake(kScreenW - 12 - 8, 0, 8, 15)];
        [view addSubview:arrow];
        arrow.image = kImageFromStr(@"user_icon_getin");
        [arrow alignVertical];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 37.5, kScreenW-24, 0.5)];
        lineView.backgroundColor = kCCCCCCColor;

        [view addSubview:lineView];
        return view;
    }

    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}




#pragma mark - 点击事件


-(void)bottomButtonAction:(UIButton *)button
{
    if (_type == TPOTCPostDetailControllerSell) {
        
        BOOL hasPayway = NO;
        
        for (TPOTCPayWayModel *model in self.payWayArray) {
            if (model.isSelected) {
                hasPayway = YES;
                break;
            }
        }
        if (hasPayway == NO) {
            [self showTips:kLocat(@"OTC_post_atleaset1payway")];
            return;
        }
        
        if (_confirmButton.selected == NO) {
            [self showTips:kLocat(@"OTC_post_pleaseacceptpro")];
            return;
        }
        
        
        [self showTipsView];
    }else{//直接调用接口
        
    }
    
    
}



-(void)selectPayWayAction:(UISwitch *)swith
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
//    TPOTCPayWayModel *model =  self.payWayArray[swith.tag];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"id"] = self.payWayArray[swith.tag].pid;
    param[@"type"] = self.payWayArray[swith.tag].type;
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Bank/change"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            swith.on = !swith.on;
            
//            self.payWayArray[swith.tag].isSelected = swith.on;
            [self loadPayWayInfo];
//            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self showTips:[responseObj ksObjectForKey:kMessage]];
            [self loadPayWayInfo];

        }
    }];
}

//-(void)addPayPWDVerify
//{
//    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
//    [kKeyWindow addSubview:bgView];
//    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.64];
//
//    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 40 - 12, kStatusBarHeight, 40, 40) title:nil titleColor:kColorFromStr(@"#4C9EE4") font:PFRegularFont(14) titleAlignment:1];
//    [bgView addSubview:cancelButton];
//    [cancelButton setImage:kImageFromStr(@"jies_icon_yinc") forState:UIControlStateNormal];
//
//
//    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
//        [sender.superview removeFromSuperview];
//    }];
//
//
//    CGFloat h = 45 + 60*4 *kScreenHeightRatio;
//    TPWalletSendKeyboardView *keyBoardView = [[TPWalletSendKeyboardView alloc] initWithFrame:kRectMake(0, kScreenH - h, kScreenW, h)];
//    keyBoardView.delegate = self;
//    [bgView addSubview:keyBoardView];
//    _sendButton = keyBoardView.codeButton;
//    [keyBoardView.codeButton addTarget:self action:@selector(showVerifyInfo) forControlEvents:UIControlEventTouchUpInside];
//    _keyboardView = keyBoardView;
//}
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
        param[@"type"] = @"sell_num";
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
            [kKeyWindow showWarning:@"k_popview_list_counter_pwd_placehoder"];
            return;
        }
        [self postActionWith:keyboardView.payTF.text];
    }

}
-(void)postActionWith:(NSString *)pwd
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"price"] = _price;
    param[@"num"] = _volume;
    param[@"currency_id"] = _currencyInfo[@"currency_id"];
    param[@"order_message"] = _remark;
    param[@"pwd"] = [pwd md5String];
    param[@"validate"] = _verifyStr;
    param[@"phone_code"] = _phoneCode;
    if (_maxDeal) {
        param[@"max_money"] = _maxDeal;
    }
    if (_minDeal) {
        param[@"min_money"] = _minDeal;
    }
//    NSMutableString *payway = [NSMutableString string];
//    for (TPOTCPayWayModel *model in self.payWayArray) {
//        if (model.isSelected) {
//            [payway appendString:[NSString stringWithFormat:@"%@,",model.pid]];
//        }
//    }
//
//    if ([payway hasSuffix:@","]) {
//        payway = [payway substringWithRange:NSMakeRange(0, payway.length - 1)].mutableCopy;
//    }
//    param[@"money_type"] = payway;
    
    for (TPOTCPayWayModel *model in self.payWayArray) {
        if (model.isSelected) {
            
            if ([model.type isEqualToString:@"bank"]) {
                param[@"bank"] = model.pid;
            }else if ([model.type isEqualToString:@"alipay"]){
                param[@"alipay"] = model.pid;
            }else{
                param[@"wechat"] = model.pid;
            }
        }
    }
    
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/TradeOtc/sell_num"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
//            [self showTips:@"发布成功"];
            [self.bgView removeFromSuperview];
            self.bgView = nil;
            
            NSString *currency_id = [NSString stringWithFormat:@"%@",_currencyInfo[@"currency_id"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidPostAdKey" object:currency_id];
            
            TPOTCPostStatusController *vc = [TPOTCPostStatusController new];
            vc.type = TPOTCPostStatusControllerTypeSuccess;
            kNavPush(vc);
            
            /**
             result =     {
             "orders_id" = 2;
             };
             
             */
        }else{

            NSInteger code = [[responseObj ksObjectForKey:@"code"] integerValue];
            if (code == 30100) {//未设置昵称
                [self _alertNicknameTextField];
            } else {
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
                
//                [self showTips:[responseObj ksObjectForKey:kMessage]];
            }
            
        }
        
    }];

}




-(NSArray *)titleArray
{
    if (_titleArray == nil) {
//        if (_type == TPOTCPostDetailControllerBuy) {
//
//            _titleArray = @[@""];
//        }else{
//            _titleArray = @[@"币种:",@"限价:",@"发布数量:",@"交易额:",@"最高交易额:",@"最低家交易额:",@"手续费费率:",@"手续费:",@"扣款方式:",@"实际支付数量:"];
//        }
        _titleArray = @[@"幣種:",@"限價:",@"發布數量:",@"交易額:",@"最高交易額:",@"最低交易額:",@"手續費費率:",@"手續費:",@"扣款方式:",@"實際支付數量:"];
        _titleArray = @[kLocat(@"OTC_post_currency"),kLocat(@"OTC_post_limitprice"),kLocat(@"OTC_post_volume"),kLocat(@"OTC_post_sum"),kLocat(@"OTC_post_maxsum"),kLocat(@"OTC_post_minsum"),kLocat(@"OTC_post_feerate"),kLocat(@"OTC_post_fee"),kLocat(@"OTC_post_payway"),kLocat(@"OTC_post_realvolume")];

        
    }
    return _titleArray;
}


-(void)showTipsView
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:kScreenBounds];
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.7];
    [kKeyWindow addSubview:bgView];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:kRectMake(28, 190 *kScreenHeightRatio, kScreenW - 56, 230)];
    [bgView addSubview:midView];
    midView.backgroundColor = kWhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 0, midView.width, 63) text:kLocat(@"OTC_post_attention") font:PFRegularFont(18) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    [midView addSubview:titleLabel];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:kRectMake(0, midView.height - 45, midView.width/2, 45) title:kLocat(@"Cancel") titleColor:kColorFromStr(@"#9CC1EE") font:PFRegularFont(16) titleAlignment:YES];
    
    [cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton* sender) {
        [sender.superview.superview removeFromSuperview];
    }];
    
    [midView addSubview:cancelButton];
    cancelButton.backgroundColor = kColorFromStr(@"#8A94A8");
    
    UIButton *confirmlButton = [[UIButton alloc] initWithFrame:kRectMake(cancelButton.right, midView.height - 45, midView.width/2, 45) title:kLocat(@"OTC_post_ihaveknow") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:YES];
    
    [midView addSubview:confirmlButton];
    confirmlButton.backgroundColor = kColorFromStr(@"#6189C5");
    
    __weak typeof(self)weakSelf = self;

    [confirmlButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * sender) {
        
        [sender.superview.superview removeFromSuperview];

        [weakSelf showVerifyInfo];
    }];
    
    

//    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",kLocat(@"OTC_post_posttips_1"),_realVolume,_currencyInfo[@"currency_name"],kLocat(@"OTC_post_posttips_2")];
    NSString *str = kLocat(@"s0112_OTCPostAction");
    
    str = [str stringByReplacingOccurrencesOfString:@"000" withString:_realVolume];
    str = [str stringByReplacingOccurrencesOfString:@"XRP" withString:_currencyInfo[@"currency_name"]];

//        NSString *str = [NSString stringWithFormat:@"發布後系統將會凍結您發布的%@%@，5小時內撤銷本廣告，廣告手續費不予退回，剩余數額將會原路退回到您的賬戶。",_realVolume,_currencyInfo[@"currency_name"]];

    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(28, titleLabel.bottom-20, midView.width - 56, midView.height - 30 - titleLabel.height) text:str font:PFRegularFont(14) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
//    [midView addSubview:tipsLabel];
    
    UITextView *tv = [[UITextView alloc] initWithFrame:kRectMake(28, 50, midView.width - 56, midView.height - 50 - 45)];
    
    [midView addSubview:tv];
    tv.font = PFRegularFont(14);
    tv.editable = NO;
    tv.textColor = k666666Color;
    tv.text = str;
    
    tipsLabel.numberOfLines = 0;
    
}

-(void)showVerifyInfo
{
    [self hideKeyBoard];
  
    if (_confirmButton.selected == NO) {
        [self showTips:kLocat(@"OTC_post_pleaseacceptpro")];
        return;
    }
    
    BOOL hasPayway = NO;
    
    for (TPOTCPayWayModel *model in self.payWayArray) {
        if (model.isSelected) {
            hasPayway = YES;
            break;
        }
    }
    if (hasPayway == NO) {
        [self showTips:kLocat(@"OTC_post_atleaset1payway")];
        return;
    }
    

    [self.manager openVerifyCodeView:nil];
}
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

#pragma mark - Alert

- (void)_alertNicknameTextField {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"HBMemberViewController_set_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *nickName = alertController.textFields.firstObject.text;
        [self modifyNick:nickName];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"k_meViewcontroler_loginout_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)modifyNick:(NSString *)nick {
    if (!nick) {
        return;
    }
    kShowHud;
    [kNetwork_Tool objPOST:@"/Api/Account/modifynick" parameters:@{@"nick" : nick ?: @""} success:^(YWNetworkResultModel *model, id responseObject) {
        
        kHideHud;
        if ([model succeeded]) {
            [self showSuccessWithMessage:model.message];
            kUserInfo.nickName = nick;
            [kUserInfo saveUserInfo];
        } else {
            [self showInfoWithMessage:model.message];
        }
    } failure:^(NSError *error) {
        kHideHud;
        [self showInfoWithMessage:error.localizedDescription];
    }];
}



-(void)sendCodeAction:(UIButton *)button
{
    [self hideKeyBoard];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"validate"] = _verifyStr;
    param[@"type"] = @"sell_num";
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
            weakSelf.isfirst = YES;
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
@end
