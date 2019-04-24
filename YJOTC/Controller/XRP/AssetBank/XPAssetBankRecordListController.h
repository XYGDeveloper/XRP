//
//  XPAssetBankRecordListController.h
//  YJOTC
//
//  Created by Roy on 2018/12/21.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"


typedef enum {
 XPAssetBankRecordListControllerAll,
//    XPAssetBankRecordListControllerShouLi,
    XPAssetBankRecordListControllerShengXiing,
    XPAssetBankRecordListControllerShengXied,
//    XPAssetBankRecordListControllerExpired
}XPAssetBankRecordListControllerType;


@interface XPAssetBankRecordListController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic,assign)XPAssetBankRecordListControllerType type;

@end


