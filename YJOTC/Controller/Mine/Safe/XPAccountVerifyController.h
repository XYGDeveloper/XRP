//
//  XPAccountVerifyController.h
//  YJOTC
//
//  Created by 周勇 on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    XPAccountVerifyControllerEmail,//邮箱
    XPAccountVerifyControllerPhone,//手机
    
}XPAccountVerifyControllerType;

@interface XPAccountVerifyController : YJBaseViewController

@property(nonatomic,assign)XPAccountVerifyControllerType type;


@end


