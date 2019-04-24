//
//  XPCashModel.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface walletModel : NSObject
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *wallet_min_percent;
@property (nonatomic,copy)NSString *wallet_num;
@end

@interface xrpjModel : NSObject
@property (nonatomic,assign)double max_xrpj_num;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,assign)double user_xrpj_num;
@property (nonatomic,copy)NSString *wallet_min_percent;
@property (nonatomic,copy)NSString *wallet_num;
@end

@interface xrpzModel : NSObject
@property (nonatomic,assign)double max_xrpz_num;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,assign)double user_xrpz_num;
@property (nonatomic,copy)NSString *wallet_min_percent;
@property (nonatomic,copy)NSString *wallet_num;

@end


@interface payinfoModel : NSObject
@property (nonatomic,copy)NSString *votes;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *cur_votes;
@property (nonatomic,copy)NSString *pay_number;
@end

@interface chooseModel : NSObject
@property (nonatomic,strong)walletModel *wallet;
@property (nonatomic,strong)xrpjModel *xrpj;
@property (nonatomic,strong)xrpzModel *xrpz;
@end

@interface XPCashModel : NSObject
@property (nonatomic,strong)payinfoModel *info;
@property (nonatomic,strong)chooseModel *pay_choose;
@end
