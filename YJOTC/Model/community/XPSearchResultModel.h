//
//  XPSearchResultModel.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPSearchResultModel : NSObject

@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *head;
@property (nonatomic,copy)NSString *invit_code;
@property (nonatomic,copy)NSString *member_id;
@property (nonatomic,copy)NSString *nick;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *status;

//email = "";
//head = "https://www.hbdaex.com/Public/Home/images/image/head_p.png";
//"invit_code" = 3VGUL8;
//"member_id" = 806922;
//nick = davel2375;
//phone = 13823751575;
//status = 1;

@end

NS_ASSUME_NONNULL_END
