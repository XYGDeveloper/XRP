//
//  TPDealHistoryController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum
{
    TPDealHistoryControllerTypeEntrust,//当前委托
    TPDealHistoryControllerTypeHistory//历史记录
    
}TPDealHistoryControllerType;


@interface TPDealHistoryController : YJBaseViewController


@property(nonatomic,assign)TPDealHistoryControllerType type;

@property(nonatomic,copy)NSString *currencyName;
@property(nonatomic,copy)NSString *markName;


@end
