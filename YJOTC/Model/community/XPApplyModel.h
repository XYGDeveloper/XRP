//
//  XPApplyModel.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface parentModel : NSObject
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *invit_code;
@property (nonatomic,copy)NSString *status;

@end

@interface auditModel : NSObject
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *votes;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *status;

@end

@interface XPApplyModel : NSObject
@property (nonatomic,strong)parentModel *parent;
@property (nonatomic,strong)auditModel *audit;

@end
