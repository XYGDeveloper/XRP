//
//  TPCurrencyInfoController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/16.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

@interface TPCurrencyInfoController : YJBaseViewController

@property(nonatomic,copy)NSString *currencyID;

@property(nonatomic,assign)BOOL isETH;

@property(nonatomic,copy)NSString *currencyName;


//@property(nonatomic,strong)XPQuotationModel *model;
@property(nonatomic,strong)ListModel *listModel;



@end
