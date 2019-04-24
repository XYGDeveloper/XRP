//
//  HBCurrentEntrustContaineeTableViewController.h
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/10/17.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBBaseTableViewController.h"



@class YTTradeUserOrderModel;
@interface HBCurrentEntrustContaineeTableViewController : HBBaseTableViewController

@property (nonatomic, strong) NSArray<YTTradeUserOrderModel *> *orders;

- (CGFloat)getHeight;

@end


