//
//  XPFridendModel.h
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface membersModel : NSObject

@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *add_time;

@end

@interface XPFridendModel : NSObject
@property (nonatomic,strong)NSArray *member;
@property (nonatomic,copy)NSString *count;

@end


