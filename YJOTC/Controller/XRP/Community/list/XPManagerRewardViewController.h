//
//  XPManagerRewardViewController.h
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XPManagerRewardViewController : YJBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *boundsType;
@end

NS_ASSUME_NONNULL_END
