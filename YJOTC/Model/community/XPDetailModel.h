//
//  XPDetailModel.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface boundsModel : NSObject
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *number;
@end

@interface infoModel : NSObject
@property (nonatomic,copy)NSString *votes;
@property (nonatomic,copy)NSString *level;
@property (nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *xrpz_num;
@property(nonatomic,copy)NSString *xrpj_num;

@end

@interface XPDetailModel : NSObject
@property (nonatomic,strong)infoModel *info;
@property (nonatomic,copy)NSString *today_type;
@property (nonatomic,strong)NSArray *bouns;
@end

