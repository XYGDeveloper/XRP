//
//  TPWalletSendKeyboardView.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPWalletSendKeyboardView;

@protocol TPWalletSendKeyboardViewDelegate<NSObject>

-(void)didClickConfirmButtonWith:(TPWalletSendKeyboardView *)keyboardView toSubmit:(BOOL)toSubmit;

@end

@interface TPWalletSendKeyboardView : UIView

@property(nonatomic,strong)UITextField *payTF;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,weak)id<TPWalletSendKeyboardViewDelegate> delegate;

@property(nonatomic,assign)BOOL showPayView;


@end
