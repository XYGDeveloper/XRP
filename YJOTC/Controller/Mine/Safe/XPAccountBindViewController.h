//
//  XPAccountBindViewController.h
//  YJOTC
//
//  Created by 周勇 on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    XPAccountBindViewControllerTypeEmail,//邮箱
    XPAccountBindViewControllerTypePhone,//手机
    XPAccountBindViewControllerSecondEmail,//第二步綁定郵箱
    XPAccountBindViewControllerSecondPhone,//第二部綁定手機
    
}XPAccountBindViewControllerType;

@interface XPAccountBindViewController : YJBaseViewController

@property(nonatomic,assign)XPAccountBindViewControllerType type;

@property(nonatomic,copy)NSString *oldCode;


@end


