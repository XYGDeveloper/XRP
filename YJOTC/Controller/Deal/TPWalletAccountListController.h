//
//  TPWalletAccountListController.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPWalletAccountListController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

/**  0全部  1收入  2支出  */
@property(nonatomic,assign)NSInteger type;


@end
