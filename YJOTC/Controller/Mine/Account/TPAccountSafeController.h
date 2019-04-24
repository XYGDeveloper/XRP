//
//  TPAccountSafeController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum {
    TPAccountSafeControllerTypeMain,//安全设置
    TPAccountSafeControllerTypeLoginPWD,//更改登录密码
    TPAccountSafeControllerTypeSafe//账户安全
}TPAccountSafeControllerType;

@interface TPAccountSafeController : YJBaseViewController

@property(nonatomic,assign)TPAccountSafeControllerType type;




@end
