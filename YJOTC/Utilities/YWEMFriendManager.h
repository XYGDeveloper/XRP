//
//  YWEMFriendManager.h
//  ywshop
//
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWEMFriendManager : NSObject

+ (instancetype)sharedInstance;

-(void)saveFriendWith:(YJUserInfo *)model;

-(YJUserInfo *)getInfoWithUserID:(NSInteger)uid;

@end
