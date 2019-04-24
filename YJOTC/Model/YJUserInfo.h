//
//  YJUserInfo.h
//  YJOTC
//
//  Created by 周勇 on 2017/12/23.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJUserInfo : NSObject


/**  用户id  */
@property(nonatomic,assign)NSInteger uid;
/**  token  */
@property(nonatomic,copy)NSString * token;
/**  头像  */
@property(nonatomic,copy)NSString * avatar;
/**  token  */
@property(nonatomic,copy)NSString * inviter_id;
/**  token  */
@property(nonatomic,copy)NSString * phone;
/**  实名认证姓名  */
@property(nonatomic,copy)NSString * userName;
/**  昵称  */
@property(nonatomic,copy)NSString *nickName;

@property (nonatomic, copy) NSString *user_nick;
/**  环信id  */
@property(nonatomic,copy)NSString * hx_username;
/**  环信密码  */
@property(nonatomic,copy)NSString * hx_password;

@property(nonatomic,copy)NSString * ename;

@property(nonatomic,copy)NSString * mark;

/**  是否是商家  */
//@property(nonatomic,assign)BOOL isSeller;

//@property(nonatomic,strong)NSString *account;
/**  实名认证状态  */
//@property(nonatomic,copy)NSString *status;


/**  verify_state实名认证状态 -1未认证 0未通过 1:已认证 2: 审核中  */
@property(nonatomic,copy)NSString * verify_state;


@property(nonatomic,copy)NSString * email;
/**  帶星號的手機號碼  */
@property(nonatomic,copy)NSString * securityphone;
@property(nonatomic,copy)NSString * securityEmail;





+(YJUserInfo *)userInfo;

-(void)saveUserInfo;

-(void)clearUserInfo;


@end
