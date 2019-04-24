//
//  XPGetValiModel.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface currentModel : NSObject
@property (nonatomic,copy)NSString *current;
@property (nonatomic,copy)NSString *votes;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *min;
@end



@interface innerModel : NSObject
@property (nonatomic,copy)NSString *step_list_id;
@property (nonatomic,copy)NSString *step_id;
@property (nonatomic,copy)NSString *votes;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *is_open;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *status_txt;
@end

@interface outterModel : NSObject
@property (nonatomic,copy)NSString *step_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *is_open;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,strong)NSArray *child;
@end

@interface XPGetValiModel : NSObject
@property (nonatomic,strong)currentModel *current;
@property (nonatomic,strong)NSArray *list;
@end

