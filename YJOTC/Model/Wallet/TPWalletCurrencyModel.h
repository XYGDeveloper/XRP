//
//  TPWalletCurrencyModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/13.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPWalletCurrencyModel : NSObject

@property(nonatomic,copy)NSString * currency_id;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * forzen_num;
@property(nonatomic,copy)NSString * currency_name;
@property(nonatomic,copy)NSString * currency_logo;
@property(nonatomic,copy)NSString * total;
@property(nonatomic,copy)NSString * cny_total;
@property(nonatomic,copy)NSString * is_send;
/**  锁仓/释放  */
@property(nonatomic,assign)NSInteger is_lock;
@property(nonatomic,assign)NSInteger is_release;

@property(nonatomic,copy)NSString * rgb;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * currency_mark;
@property(nonatomic,copy)NSString * cny;
/**  1为开启提币，2为关闭  */
@property(nonatomic,assign)NSInteger take_switch;
/**  1为开启充币，2为关闭  */
@property(nonatomic,assign)NSInteger recharge_switch;

@property(nonatomic,copy)NSString * nw_price_unit;






/**
 "currency_id":"29",
 "num":"0.000000",
 "forzen_num":"0.000000",
 "currency_name":"BCB糖果",
 "currency_logo":"https://xinlianqianbao-sh.oss-cn-shanghai.aliyuncs.com/currency_logo/2018-07-31/edcc1c728de46cbd.png",
 "cny":"0.0000",
 "total":0,
 "cny_price":0
 
 */
@end
