//
//  TPOTCMyADModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/30.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCOrderModel.h"

@interface TPOTCMyADModel : TPOTCOrderModel

@property(nonatomic,copy)NSString * fail_allnum;
@property(nonatomic,copy)NSString * trade_money;
@property(nonatomic,copy)NSString * avail_money;
/**  -1主动撤销 2已完成  */
@property(nonatomic,copy)NSString * status;


@end
