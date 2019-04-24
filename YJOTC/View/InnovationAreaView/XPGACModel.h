//
//  XPGACModel.h
//  YJOTC
//
//  Created by l on 2019/3/18.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPGACModel : NSObject
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * from_num;
@property(nonatomic,copy)NSString * actual;
@property(nonatomic,copy)NSString * from_cny;
@property(nonatomic,copy)NSString * to_cny;
@property(nonatomic,copy)NSString * from_currency;
@property(nonatomic,copy)NSString * to_currency;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * fee;
@property(nonatomic,copy)NSString * total_cny;
@property(nonatomic,copy)NSString * status_txt;

@end

NS_ASSUME_NONNULL_END
