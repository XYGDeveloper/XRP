//
//  YJUserInfo.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJUserInfo.h"

@implementation YJUserInfo

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"uid" :@"member_id",
             @"avatar" :@"user_head",
             @"phone" :@"phone",
             @"token" :@"token",
             @"userName" :@"name",
             @"nickName" :@"user_nick",
             @"isSeller" : @"is_seller",
             @"account" : @"user_account"

             };
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        //        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        //        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.hx_password = [aDecoder decodeObjectForKey:@"hx_password"];
        self.hx_username = [aDecoder decodeObjectForKey:@"hx_username"];
        self.inviter_id = [aDecoder decodeObjectForKey:@"inviter_id"];
        self.ename = [aDecoder decodeObjectForKey:@"ename"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.verify_state = [aDecoder decodeObjectForKey:@"verify_state"];
        self.securityphone = [aDecoder decodeObjectForKey:@"securityphone"];
        self.securityEmail = [aDecoder decodeObjectForKey:@"securityEmail"];



    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //    kLOG(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.userName forKey:@"userName"];
    //    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    //    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.hx_username forKey:@"hx_username"];
    [aCoder encodeObject:self.hx_password forKey:@"hx_password"];
    [aCoder encodeObject:self.inviter_id forKey:@"inviter_id"];
    [aCoder encodeObject:self.ename forKey:@"ename"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.verify_state forKey:@"verify_state"];
    [aCoder encodeObject:self.securityphone forKey:@"securityphone"];
    [aCoder encodeObject:self.securityEmail forKey:@"securityEmail"];


    
    
}

-(void)saveUserInfo
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:[[NSString stringWithFormat:@"%ld",(long)[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];

    kLOG(@"归档结果---<  %d  >",success);
}

+(YJUserInfo *)userInfo
{
    YJUserInfo *model = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSString stringWithFormat:@"%ld",(long)[kUserDefaults integerForKey:kUserIDKey]] appendDocument]];
    model.ename = model.userName;
//    model.nickName = model.ename;
    return model;
}
-(void)clearUserInfo
{
    YJUserInfo *model = kUserInfo;
    model.token = @"";
    //    model.account = @"";
    model.uid = 0;
    model.phone = @"";
    [model saveUserInfo];
}




@end
