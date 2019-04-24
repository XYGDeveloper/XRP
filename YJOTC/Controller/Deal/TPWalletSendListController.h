//
//  TPWalletSendListController.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "XPAssetBankModel.h"

typedef void(^CallBackBlcok) (id);//1


@interface TPWalletSendListController : YJBaseViewController

@property(nonatomic,assign)BOOL toScan;

/**  持币生息  */
@property(nonatomic,assign)BOOL isAssetBank;

@property(nonatomic,strong)XPAssetBankModel *model;

@property(nonatomic,copy)CallBackBlcok callBackBlcok;




@end
