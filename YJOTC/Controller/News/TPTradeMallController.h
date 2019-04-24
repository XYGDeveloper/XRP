//
//  TPTradeMallController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPTradeMallController : YJBaseViewController

@property(nonatomic,assign)NSInteger isBuy;

@property(nonatomic,copy)NSString *currencyID;

@property(nonatomic,copy)NSString *currencyName;

@property(nonatomic,assign)BOOL isETH;

@property(nonatomic,strong)XPQuotationModel *model;




@end
