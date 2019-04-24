//
//  TPWalletAddreddListController.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef void(^CallBackBlcok) (id);//1

@interface TPWalletAddreddListController : YJBaseViewController
/**  选择回调  */
@property(nonatomic,copy)CallBackBlcok callBackBlock;

@property(nonatomic,copy)NSString *currencyID;

@property(nonatomic,assign)BOOL isXrp;
@property(nonatomic,assign)BOOL isEOS;


@end
