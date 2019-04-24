//
//  XPAssetBankListController.h
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "YJBaseViewController.h"
typedef void(^CallBackBlcok) (id);//1

NS_ASSUME_NONNULL_BEGIN

@interface XPAssetBankListController : YJBaseViewController

@property(nonatomic,copy)NSString * currencyID;
@property(nonatomic,copy)CallBackBlcok callBackBlcok;
/**  重新选择日期  */
@property(nonatomic,assign)BOOL reChooseDate;


@end

NS_ASSUME_NONNULL_END
