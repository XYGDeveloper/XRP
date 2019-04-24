//
//  XPCashierViewController.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"

@interface XPCashierViewController : YJBaseViewController
@property (nonatomic,strong)NSString *step_list_id;
@property (nonatomic,strong)NSString *member_id;
@property (nonatomic,strong)NSString *parent_id;
@property(nonatomic,assign)NSInteger votes;
@end
