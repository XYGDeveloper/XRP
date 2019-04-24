//
//  XPZSModel.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user_numModel : NSObject
@property (nonatomic,copy)NSString *num_award;
@property (nonatomic,copy)NSString *sum_award;
@end

@interface lanModel : NSObject
@property (nonatomic,copy)NSString *clf_id;
@property (nonatomic,copy)NSString *rate;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *currency_mark;
@end

@interface XPZSModel : NSObject
@property (nonatomic,strong)user_numModel *user_num;
@property (nonatomic,strong)NSArray *list;
@end

