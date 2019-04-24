//
//  TPWalletRecevieController.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletRecevieController.h"
#import "TPWalletCurrencyModel.h"
#import "UITextView+DisableCopy.h"

@interface TPWalletRecevieController ()

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITextView *addTV;
@property(nonatomic,strong)UIImageView *qrView;
@property(nonatomic,strong)UIImageView *icon;


@property(nonatomic,strong)UIView *bottoView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *dimView;

@property(nonatomic,strong)NSArray *currencyArray;

@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)NSString *is_send;

@property(nonatomic,strong)UILabel *xrpTagLabel;
@property(nonatomic,copy)UIButton *xrpButton;


@property(nonatomic,copy)NSString *XRPTagString;


@property(nonatomic,strong)UITextView *xrpTV;



@end

@implementation TPWalletRecevieController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self loadCurrencyInfo];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if (self.rightView) {
        [UIView animateWithDuration:0.05 animations:^{
            self.rightView.x = kScreenW;
        }];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.rightView) {
        [self.rightView removeFromSuperview];
        self.rightView = nil;
    }
}

-(void)loadCurrencyInfo
{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/asset_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"%@",responseObj);
            _currencyArray = [responseObj ksObjectForKey:kData];
            if (_currencyID) {
                [self loadCurrencyAddress:_currencyID];
            }else{
                [self loadCurrencyAddress:_currencyArray.firstObject[@"currency_id"]];
            }
            [self setupUI];
        }
    }];
}
-(void)loadCurrencyAddress:(NSString *)currencyID
{
    kShowHud;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = currencyID;
    
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Wallet/rechargeCoin"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            _addTV.text = [responseObj ksObjectForKey:kData][@"address"];
            _qrView.image = [Utilities getQRImageWithContent:_addTV.text];
            
            if ([[responseObj ksObjectForKey:kData][@"currency_mark"] containsString:@"XRP"]) {
                _isXRP = YES;
                _xrpTagLabel.hidden = NO;
                _xrpButton.hidden = NO;
                
                _XRPTagString = ConvertToString([responseObj ksObjectForKey:kData][@"tag"]);
                _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"W_Tag"),_XRPTagString];
                
                _xrpTV.hidden = NO;
                _qrView.y = _xrpTV.bottom + 2;
                
                _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"W_Tag"),@(kUserInfo.uid)];
                _xrpTV.text = kLocat(@"s0115_xrpreceiveTips");
                [_xrpButton setTitle:kLocat(@"W_copyTag") forState:UIControlStateNormal];

            }else if([[responseObj ksObjectForKey:kData][@"currency_mark"] containsString:@"EOS"]){
                _isXRP = YES;
                _xrpTagLabel.hidden = NO;
                _xrpButton.hidden = NO;
                
                _XRPTagString = ConvertToString([responseObj ksObjectForKey:kData][@"tag"]);
                _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"W_Tag"),_XRPTagString];
                
                _xrpTV.hidden = NO;
                _qrView.y = _xrpTV.bottom + 2;
                
                _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",@"memo",@(kUserInfo.uid)];
                _xrpTV.text = kLocat(@"s0115_xrpreceiveTips_EOS");
                [_xrpButton setTitle:kLocat(@"W_copyEOSTag") forState:UIControlStateNormal];
                
            }else{
                _isXRP = NO;
                _xrpTagLabel.hidden = YES;
                _xrpButton.hidden = YES;
                _xrpTV.hidden = YES;
                _qrView.y = 165*kScreenHeightRatio;

            }
            
            
            //获取成功,调用一次本接口
            [self getUserInpayLogWith:currencyID];
            
        }else{
            _addTV.text = nil;
            _qrView.image = [Utilities getQRImageWithContent:_addTV.text];
//            NSInteger code = [[responseObj ksObjectForKey:kCode]integerValue];
//            if (code == 10100) {
//                [self gotoLoginVC];
//            }
            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

//拉取用户转入记录
-(void)getUserInpayLogWith:(NSString *)currencyID
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"currency_id"] = currencyID;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Wallet/inpay_log"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        
        
    }];
}


-(void)setupUI
{
    self.title = kLocat(@"W_receive");
    self.view.backgroundColor = kTableColor;
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:kRectMake(0,30 *kScreenHeightRatio + kNavigationBarHeight, 325 *kScreenWidthRatio, 442 *kScreenHeightRatio)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    [bgView alignHorizontal];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:kRectMake(70, 25, 60, 17) text:@"BTC" font:PFRegularFont(18) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [bgView addSubview:nameLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:kRectMake(20, 15, 40, 40)];
    [bgView addSubview:imageView];
    
    if (_currencyID) {
        for (NSDictionary *dic in _currencyArray) {
            if ([ConvertToString(dic[@"currency_id"]) isEqualToString:_currencyID]) {
                NSString *logo = dic[@"currency_logo"];
                [imageView setImageWithURL:logo.ks_URL placeholder:nil];
                nameLabel.text = dic[@"currency_mark"];
                break;
            }
        }
    }else{
        NSString *logo = _currencyArray.firstObject[@"currency_logo"];
        [imageView setImageWithURL:logo.ks_URL placeholder:nil];
        nameLabel.text = _currencyArray.firstObject[@"currency_mark"];
    }
    
    CGFloat cypY = 0;
    
    if (kScreenW > 321) {
        cypY = 73;
    }else{
        cypY = 73*kScreenHeightRatio;
    }
    UIButton *cpyButton = [[UIButton alloc] initWithFrame:kRectMake(0, cypY, 62, 16) title:kLocat(@"W_copyaddress") titleColor:kColorFromStr(@"#066B98") font:PFRegularFont(14) titleAlignment:YES];
    [bgView addSubview:cpyButton];
    [cpyButton sizeToFit];
    cpyButton.right = bgView.width - 25;
    
    __weak typeof(self)weakSelf = self;

    [cpyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [UIPasteboard generalPasteboard].string = weakSelf.addTV.text;
        [weakSelf showTips:kLocat(@"OTC_copySuccess")];
    }];
    
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:kRectMake(25, 54, 100, 12) text:[NSString stringWithFormat:@"%@:",kLocat(@"W_receiveaddress")] font:PFRegularFont(12) textColor:kColorFromStr(@"#666666") textAlignment:0 adjustsFont:YES];
    [bgView addSubview:tipsLabel];
    tipsLabel.centerY = cpyButton.centerY;
    
    
    UITextView *addTV = [[UITextView alloc] initWithFrame:kRectMake(25, tipsLabel.bottom + 5, bgView.width - 50, 45)];
    [bgView addSubview:addTV];
    addTV.editable = NO;
    addTV.userInteractionEnabled = NO;
    addTV.font = PFRegularFont(12);
    addTV.backgroundColor = kClearColor;
    addTV.textColor = tipsLabel.textColor;
    addTV.text = @"";
    
    
    CGFloat tagY = 0;
    
    if (kScreenW > 321) {
        tagY = 140;
    }else{
        tagY = 140*kScreenHeightRatio;
    }
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:kRectMake(25, tagY, 140, 13) text:[NSString stringWithFormat:@"%@:%@",kLocat(@"W_Tag"),@(kUserInfo.uid)] font:PFRegularFont(12) textColor:k666666Color textAlignment:0 adjustsFont:NO];
    [bgView addSubview:tagLabel];
    
    UIButton *tagButotn = [[UIButton alloc] initWithFrame:kRectMake(cpyButton.x, 0, 82, cpyButton.height+5) title:kLocat(@"W_copyTag") titleColor:cpyButton.currentTitleColor font:PFRegularFont(13.5) titleAlignment:0];
    [bgView addSubview:tagButotn];
//    tagButotn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [tagButotn sizeToFit];
    tagButotn.centerY = tagLabel.centerY;
    tagButotn.right = bgView.width - 25;
    tagButotn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cpyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    [tagButotn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (weakSelf.XRPTagString) {
            
            [UIPasteboard generalPasteboard].string = weakSelf.XRPTagString;
            [weakSelf showTips:kLocat(@"OTC_copySuccess")];
        }
        
    }];
    tagButotn.hidden = YES;
    tagLabel.hidden = YES;
    _xrpButton = tagButotn;
    _xrpTagLabel = tagLabel;
    

 
    UITextView *tv = [[UITextView alloc] initWithFrame:kRectMake(20, tagButotn.bottom + 2, bgView.width - 40, 65 * kScreenHeightRatio)];
    [bgView addSubview:tv];
    tv.textColor = kColorFromStr(@"#E1545A");
    tv.text = kLocat(@"s0115_xrpreceiveTips");
    tv.font = PFRegularFont(12);
    tv.editable = NO;

    CGFloat qrW;
    if (kScreenW < 321) {
        qrW = 200 *kScreenWidthRatio;
    }else{
        qrW = 210 *kScreenWidthRatio;
    }
    UIImageView *qrView = [[UIImageView alloc] initWithFrame:kRectMake(34, tv.bottom + 2, qrW,qrW)];
    [bgView addSubview:qrView];
    [qrView alignHorizontal];
    
    _xrpTV = tv;
    _qrView = qrView;
    _nameLabel = nameLabel;
    _addTV = addTV;
    _icon = imageView;
    

    UIView *bottomView = [[UIView alloc] initWithFrame:kRectMake(0, kScreenH - 110 *kScreenHeightRatio, kScreenW, 110 *kScreenHeightRatio)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = kWhiteColor;
    UILabel *title = [[UILabel alloc] initWithFrame:kRectMake(12, 15, 200, 12) text:kLocat(@"W_CurrencyToReceive") font:PFRegularFont(12) textColor:k222222Color textAlignment:0 adjustsFont:YES];
    [bottomView addSubview:title];
    _bottoView = bottomView;
    
    
    CGFloat w = 50;
    CGFloat margin = (kScreenW - 50 * 4)/8.0;
    
    NSInteger count;
    if (_currencyArray.count > 3) {
        count = 4;
    }else{
        count = _currencyArray.count;
    }
    
    for (NSInteger i = 0; i < count; i++) {
        
        YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(w*i + (2*i+1)*margin, 38 *kScreenHeightRatio, w, 32+5+14)];
        [bottomView addSubview:button];
        button.tag = i;
        
        if (i < 3) {
            [self configureButtonWithTitle:_currencyArray[i][@"currency_mark"] imageUrl:_currencyArray[i][@"currency_logo"] button:button];
        }else{
            [self configureButtonWithTitle:kLocat(@"W_more") imageUrl:@"jie_icon_more" button:button];
            button.tag = 100;
        }
        [button addTarget:self action:@selector(currencyButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }

}

#pragma mark - 选择币种
-(void)currencyButtonTapAction:(UIButton *)button
{
   
    if (button.tag == 100) {//更多
        [self showMoreViewAction];
    }else{
        NSLog(@"]]]]]]]]]%@",_currencyArray[button.tag][@"currency_logo"]);
        NSString *is_send = _currencyArray[button.tag][@"is_send"];
        if ([[NSString stringWithFormat:@"%@",is_send] isEqualToString:@"0"]) {
            [self showTips:kLocat(@"W_thiscurrencycanntreceive")];
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.rightView.x = kScreenW;
        }];
        //重新赋值
        _nameLabel.text = _currencyArray[button.tag][@"currency_mark"];
        NSString *logo = _currencyArray[button.tag][@"currency_logo"];
        [_icon setImageWithURL:logo.ks_URL placeholder:nil];
        
        
        
        
        if ([_nameLabel.text containsString:@"XRP"]) {
            _isXRP = YES;
            _xrpTagLabel.hidden = NO;
            _xrpButton.hidden = NO;
            _xrpTV.hidden = NO;

            _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"W_Tag"),@(kUserInfo.uid)];

        }else if ([_nameLabel.text containsString:@"EOS"]) {
            _isXRP = YES;
            _xrpTagLabel.hidden = NO;
            _xrpButton.hidden = NO;
            _xrpTV.hidden = NO;
            
            _xrpTagLabel.text = [NSString stringWithFormat:@"%@:%@",@"memo",@(kUserInfo.uid)];

        }else{
            _isXRP = NO;
            _xrpTagLabel.hidden = YES;
            _xrpButton.hidden = YES;
            _xrpTV.hidden = YES;
        }
        
        
        [self loadCurrencyAddress:_currencyArray[button.tag][@"currency_id"]];
    }
}


-(void)showMoreViewAction
{
    if (_rightView) {
        [UIView animateWithDuration:0.25 animations:^{
            _rightView.x = kScreenW - 90;
        }];
        return;
    }
    
    UIView *rightView = [[UIView alloc] initWithFrame:kRectMake(kScreenW, kNavigationBarHeight, 90, kScreenH - kNavigationBarHeight)];
    [kKeyWindow addSubview:rightView];
    _rightView = rightView;
    rightView.backgroundColor = kColorFromStr(@"#DEA62E");
    [UIView animateWithDuration:0.25 animations:^{
        rightView.x = kScreenW - 90;
    }];
    
    
    
    
    CGFloat w = 50;
    CGFloat h = 32+5+14;
    CGFloat margin = 30;
    
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:kRectMake(0, 0, rightView.width, rightView.height - 80)];
    [rightView addSubview:scView];
    
    
    
    for (NSInteger i = 0; i < self.currencyArray.count - 3; i++) {
        
        YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(0,margin+ (margin+h) * i, w, h)];
        [scView addSubview:button];
        [self configureButtonWithTitle:_currencyArray[i+3][@"currency_mark"] imageUrl:_currencyArray[i+3][@"currency_logo"] button:button];
        button.tag = i + 3;
        [button alignHorizontal];
        [button addTarget:self action:@selector(currencyButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        scView.contentSize = kSizeMake(0, button.bottom + 10);
    }
    
    YLButton *button = [[YLButton alloc] initWithFrame:kRectMake(0,0, w, h)];
    [rightView addSubview:button];
    [button alignHorizontal];
    button.bottom = _rightView.bottom -80;
    [self configureButtonWithTitle:kLocat(@"OTC_main_hide") imageUrl:@"jies_icon_yinc" button:button];
    button.imageRect = kRectMake(13, 5, 24, 24);
    __weak typeof(self)weakSelf = self;
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];

    [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.rightView.x = kScreenW;
            weakSelf.dimView.hidden = YES;
        }];
    }];

    
    
}




-(void)configureButtonWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl button:(YLButton *)button
{
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = PFRegularFont(14);
    button.imageRect = kRectMake(9, 0, 32, 32);
    button.titleRect = kRectMake(0, 32 + 5, button.width, 16);

    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (![imageUrl containsString:@"/"]) {
        [button setImage:kImageFromStr(imageUrl) forState:UIControlStateNormal];
    }else{
        [button setImageWithURL:imageUrl.ks_URL forState:UIControlStateNormal placeholder:nil];
    }
    [button setTitleColor:k222222Color forState:UIControlStateNormal];
}






@end
