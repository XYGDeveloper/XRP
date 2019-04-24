//
//  TPIdentifyViewController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPIdentifyViewController : YJBaseViewController

/**  0 未认证  1已经认证  */
@property(nonatomic,assign)NSInteger type;

/**   1：身份证 2：护照 3：港澳通行证  */
@property(nonatomic,assign)NSInteger identifyType;



@end
