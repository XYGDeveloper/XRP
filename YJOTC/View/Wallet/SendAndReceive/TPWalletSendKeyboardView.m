//
//  TPWalletSendKeyboardView.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendKeyboardView.h"


@interface TPWalletSendKeyboardView()

@property(nonatomic,assign)NSInteger second;

@end

@implementation TPWalletSendKeyboardView



-(void)setShowPayView:(BOOL)showPayView
{
    _showPayView = showPayView;
    _codeButton.hidden = YES;
    _codeTF.hidden = YES;
    _payTF.hidden = NO;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.backgroundColor = kWhiteColor;
    
    _second = 60;
    
    UIView *topView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 45)];
    [self addSubview:topView];
//    topView.backgroundColor = kRedColor;
    
    CGFloat h = self.height - topView.height;
    h = h/4.0;
    CGFloat w = self.width / 4.0;
    
    UIView *keyBoardView = [[UIView alloc] initWithFrame:kRectMake(0, topView.bottom, kScreenW, self.height - topView.height)];
    [self addSubview:keyBoardView];
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(w * (i%3), h * (i/3)+45, w, h) title:[NSString stringWithFormat:@"%d",i+1] titleColor:k323232Color font:PFRegularFont(25) titleAlignment:1];
        button.tag = i+1;
        [self addSubview:button];
        [button addTarget:self action:@selector(numberButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *zore = [[UIButton alloc] initWithFrame:kRectMake(0, topView.height + 3 *h, 3 *w, h) title:@"0" titleColor:k323232Color font:PFRegularFont(25) titleAlignment:1];
    zore.tag = 0;
    [self addSubview:zore];
    [zore addTarget:self action:@selector(numberButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:kRectMake(w*3, topView.bottom, w, 2*h) title:nil titleColor:kRedColor font:PFRegularFont(12) titleAlignment:YES];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    [deleteButton setImage:kImageFromStr(@"mima_icon_del") forState:UIControlStateNormal];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:kRectMake(w*3, deleteButton.bottom, w, 2*h) title:kLocat(@"Confirm") titleColor:kWhiteColor font:PFRegularFont(20) titleAlignment:YES];
    confirmButton.backgroundColor = kColorFromStr(@"#4C9EE4");
    [self addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.SG_eventTimeInterval = 1.5;
    
    UIColor *lineColor = kColorFromStr(@"f4f4f4");
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, 0.5)];
    lineView1.backgroundColor = lineColor;
    [self addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45+h, 3*w, 0.5)];
    lineView2.backgroundColor = lineColor;
    [self addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 45+2*h, 3*w, 0.5)];
    lineView3.backgroundColor = lineColor;
    [self addSubview:lineView3];
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 45+3*h, 3*w, 0.5)];
    lineView4.backgroundColor = lineColor;
    [self addSubview:lineView4];
    
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(w, 45, .5, 3*h)];
    lineView5.backgroundColor = lineColor;
    [self addSubview:lineView5];
    UIView *lineView6 = [[UIView alloc] initWithFrame:CGRectMake(2*w, 45, 0.5, 3*h)];
    lineView6.backgroundColor = lineColor;
    [self addSubview:lineView6];
    UIView *lineView7 = [[UIView alloc] initWithFrame:CGRectMake(3*w, 45, 0.5, 2*h)];
    lineView7.backgroundColor = lineColor;
    [self addSubview:lineView7];
    
    UITextField *payTF = [[UITextField alloc] initWithFrame:topView.bounds];
    [topView addSubview:payTF];
    payTF.placeholder = kLocat(@"LEnterTransactionPWD");
    payTF.textColor = k323232Color;
    payTF.font = PFRegularFont(15);
    kTextFieldPlaceHoldColor(payTF, kColorFromStr(@"#999999"));
    payTF.keyboardType = UIKeyboardTypeNumberPad;
    payTF.userInteractionEnabled = NO;
    payTF.textAlignment = NSTextAlignmentCenter;
    _payTF = payTF;
    payTF.secureTextEntry = YES;
    
    UITextField *codeTF = [[UITextField alloc] initWithFrame:kRectMake(12, 0, kScreenW - 24 - 115, 45)];
    [topView addSubview:codeTF];
    codeTF.placeholder = kLocat(@"HBForgetPasswordTableViewController_valcode_placehoder");
    codeTF.textColor = k323232Color;
    codeTF.font = PFRegularFont(15);
    kTextFieldPlaceHoldColor(payTF, kColorFromStr(@"#999999"));
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.userInteractionEnabled = NO;
    
    UIButton *codeButton = [[UIButton alloc] initWithFrame:kRectMake(kScreenW - 115, 0, 115, 45) title:kLocat(@"HBForgetPasswordTableViewController_valcode_get") titleColor:kWhiteColor font:PFRegularFont(12) titleAlignment:1];
    [topView addSubview:codeButton];
    codeButton.backgroundColor = kColorFromStr(@"#4C9EE4");;
    
    
    _codeTF = codeTF;
    _codeButton = codeButton;
    _payTF.hidden = YES;
    
}
-(void)numberButtonTap:(UIButton *)button
{
    if (_payTF.hidden == NO) {
        if (_payTF.text.length < 6) {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",_payTF.text];
            [str appendString:[NSString stringWithFormat:@"%zd",button.tag]];
            _payTF.text = str.copy;
        }
        
    }else{
        if (_codeTF.text.length < 6) {
            NSMutableString *str = [NSMutableString stringWithFormat:@"%@",_codeTF.text];
            [str appendString:[NSString stringWithFormat:@"%zd",button.tag]];
            _codeTF.text = str.copy;
        }
    }
}
-(void)deleteAction
{
    if (_payTF.hidden == NO) {
        
        if (_payTF.text.length > 0 ) {
            _payTF.text = [_payTF.text substringToIndex:_payTF.text.length - 1];
        }
    }else{
        if (_codeTF.text.length > 0) {
            _codeTF.text = [_codeTF.text substringToIndex:_codeTF.text.length - 1];
        }
    }
}


-(void)confirmButtonAction
{
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonWith:toSubmit:)]) {
        if (self.payTF.hidden == NO) {//提交
            [self.delegate didClickConfirmButtonWith:self toSubmit:YES];
        }else{//验证验证码
            [self.delegate didClickConfirmButtonWith:self toSubmit:NO];
        }
    }
}


@end
