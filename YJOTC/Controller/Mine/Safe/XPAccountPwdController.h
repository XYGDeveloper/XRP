//
//  XPAccountPwdController.h
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum {
    XPAccountPwdControllerTypePayPWD,//修改支付密碼
    XPAccountPwdControllerTypeLoginPhone,//手機號修改登錄密碼
    XPAccountPwdControllerTypeLoginEmail,//郵箱修改登錄密碼
    XPAccountPwdControllerTypeLoginOldPWD,//舊密碼修改
}XPAccountPwdControllerType;


@interface XPAccountPwdController : YJBaseViewController


@property(nonatomic,assign)XPAccountPwdControllerType type;

@property(nonatomic,copy)NSString * phone;


@end


