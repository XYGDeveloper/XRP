//
//  YTBuyAndSellDetailTableViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"


@class ListModel;
@interface YTBuyAndSellDetailTableViewController : HBBaseTableViewController


+ (instancetype)fromStoryboard;

@property (nonatomic, strong) ListModel *model;

@property (nonatomic, assign) BOOL isTypeOfBuy;




@end

