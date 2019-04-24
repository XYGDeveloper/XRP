//
//  XPCommunityLeaderModel.h
//  YJOTC
//
//  Created by l on 2019/1/19.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPCommunityUserModel : NSObject
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *invit_code;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString * pid_member_id;
@property(nonatomic,copy)NSString * pid_phone;


@end

@interface XPCommunityPrentModel : NSObject
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *invit_code;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *status;
@end

@interface XPCommunityLeaderModel : NSObject
@property (nonatomic,strong)XPCommunityUserModel *user;
@property (nonatomic,strong)XPCommunityPrentModel *parent;
@end

