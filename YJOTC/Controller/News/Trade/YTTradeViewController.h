//
//  YTTradeViewController.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/9/26.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ListModel;
@interface YTTradeViewController : YJBaseViewController


- (instancetype)initWithModel:(ListModel *)model isTypeOfBuy:(BOOL)isTypeOfBuy;

@property (nonatomic, strong) ListModel *currentListModel;
@property (nonatomic, assign) BOOL isTypeOfBuy;


@end

NS_ASSUME_NONNULL_END
