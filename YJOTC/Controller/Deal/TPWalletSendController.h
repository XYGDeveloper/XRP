//
//  TPWalletSendController.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "TPWalletCurrencyModel.h"

@interface TPWalletSendController : YJBaseViewController

@property(nonatomic,strong)TPWalletCurrencyModel *model;
/**  扫描地址  */
@property(nonatomic,copy)NSString * addressStr;


@end
