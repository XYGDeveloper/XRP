//
//  TPWalletAddressAddController.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPWalletAddressAddController : YJBaseViewController


@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,strong)NSDictionary *dateDic;

@property(nonatomic,copy)NSString *currencyID;

@property(nonatomic,assign)BOOL isXrp;
@property(nonatomic,assign)BOOL isEOS;

@end
