//
//  XPInnovationModel.h
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPInnovationModel : NSObject
@property(nonatomic,copy)NSString * user_num;
@property(nonatomic,copy)NSString * gac_exchange_name;
@property(nonatomic,copy)NSString * gac_reward_name;
@property(nonatomic,copy)NSString * gac_internal_buy_name;
@property(nonatomic,copy)NSString * reward_num;
@property(nonatomic,copy)NSString * percent;
@property(nonatomic,copy)NSString * forzen_num;
@property(nonatomic,copy)NSString * lang_notice;
@property(nonatomic,strong)NSArray * allow_percent;
@property(nonatomic,copy)NSString * is_percent_show;
@property(nonatomic,copy)NSString * is_exchange_show;
@property(nonatomic,copy)NSString * is_reward_show;
@property(nonatomic,copy)NSString * is_internal_buy_show;
@property(nonatomic,copy)NSString * internal_buy_num;

@end

NS_ASSUME_NONNULL_END
