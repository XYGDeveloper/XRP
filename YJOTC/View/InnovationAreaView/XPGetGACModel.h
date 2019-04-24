//
//  XPGetGACModel.h
//  YJOTC
//
//  Created by l on 2019/3/18.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InnerModel : NSObject
@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * middle;
@property(nonatomic,copy)NSString * bottom;
@property(nonatomic,copy)NSString * currency_name;
@property(nonatomic,copy)NSString * num_type;
@end


@interface XPGetGACModel : NSObject
@property(nonatomic,copy)NSString * user_num;
@property(nonatomic,copy)NSString * release_ratio;
@property(nonatomic,copy)NSString * currency_name;
@property(nonatomic,copy)NSString * today_num;
@property(nonatomic,strong)NSArray * list;

@end

NS_ASSUME_NONNULL_END
