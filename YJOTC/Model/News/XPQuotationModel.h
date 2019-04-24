//
//  XPQuotationModel.h
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XPQuotationModel : NSObject

@property(nonatomic,copy)NSString *change_price_24;
@property(nonatomic,copy)NSString *change_24;
@property(nonatomic,copy)NSString *done_num_24H;
@property(nonatomic,copy)NSString *currency_id;
@property(nonatomic,copy)NSString *trade_currency_id;
@property(nonatomic,copy)NSString *currency_mark;
@property(nonatomic,copy)NSString *trade_currency_mark;
@property(nonatomic,copy)NSString *currency_buy_fee;
@property(nonatomic,copy)NSString *currency_sell_fee;
@property(nonatomic,copy)NSString *n_price;
@property(nonatomic,copy)NSString *n_price_status;
@property(nonatomic,copy)NSString *n_price_usd;

/**  单位  */
@property(nonatomic,copy)NSString * nw_price_unit;


@end
/**
 "change_price_24":"0.00",
 "change_24":"+0.00",
 "done_num_24H":"0.00",
 "currency_id":31,
 "trade_currency_id":"33",
 "currency_mark":"ETH",
 "trade_currency_mark":"USDT",
 "currency_buy_fee":0.1,
 "currency_sell_fee":0.2,
 "new_price":"0.00000000",
 "new_price_status":1,
 "new_price_usd":"0.00000000"
 */


