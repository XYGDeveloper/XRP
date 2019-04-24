//
//  TPResetPWDController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/6.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum
{
    TPResetPWDTypeLogin,
    TPResetPWDTypeTransaction,
}TPResetPWDType;

@interface TPResetPWDController : YJBaseViewController

@property(nonatomic,assign)NSInteger TPResetPWDType;


@end
