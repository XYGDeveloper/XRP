//
//  XPGACInnerPurchModel.h
//  YJOTC
//
//  Created by l on 2019/4/4.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPGACInnerPurchModel : NSObject
@property(nonatomic,copy)NSString * from_name;
@property(nonatomic,copy)NSString * from_currency;
@property(nonatomic,copy)NSString * to_currency;
@property(nonatomic,copy)NSString * from_cny;
@property(nonatomic,copy)NSString * to_cny;
@property(nonatomic,copy)NSString * ratio;
@property(nonatomic,copy)NSString * from_user_num;
@property(nonatomic,copy)NSString * limit_num;
@property(nonatomic,copy)NSString * has_buy;
@property(nonatomic,copy)NSString * yu;

@end

NS_ASSUME_NONNULL_END
