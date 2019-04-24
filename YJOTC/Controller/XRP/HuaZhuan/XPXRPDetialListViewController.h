//
//  XPXRPDetialListViewController.h
//  YJOTC
//
//  Copyright © 2019年 前海. All rights reserved.
//

#import "YJBaseViewController.h"

typedef enum {
    XPXRPDetialListViewControllerTypeAll,
    //    XPAssetBankRecordListControllerShouLi,
    XPXRPDetialListViewControllerTypeIn,
    XPXRPDetialListViewControllerTypeOut,
    //    XPAssetBankRecordListControllerExpired
}XPXRPDetialListViewControllerType;




@interface XPXRPDetialListViewController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic,assign)XPXRPDetialListViewControllerType type;


@end


