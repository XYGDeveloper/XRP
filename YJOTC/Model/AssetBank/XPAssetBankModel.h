//
//  XPAssetBankModel.h
//  YJOTC
//
//  Created by 周勇 on 2019/1/4.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPAssetBankModel : NSObject

@property(nonatomic,copy)NSString * xid;
@property(nonatomic,copy)NSString * currency_id;
@property(nonatomic,copy)NSString * months;
@property(nonatomic,copy)NSString * min_num;
@property(nonatomic,copy)NSString * max_num;
@property(nonatomic,copy)NSString * rate;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * currency_mark;
@property(nonatomic,copy)NSString * characteristic;
@property(nonatomic,copy)NSString * details;




@end



/**
 "id":1,
 "currency_id":1,
 "months":3,
 "min_num":"0.001000",
 "max_num":"0.000000",
 "rate":"18.00",
 "add_time":1543284383,
 "cn_title":"定期3月",
 "en_title":"3 month"
 */
NS_ASSUME_NONNULL_END
