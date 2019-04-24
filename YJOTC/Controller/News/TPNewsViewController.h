//
//  TPNewsViewController.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "YJBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface TPNewsViewController : YJBaseViewController<ZJScrollPageViewChildVcDelegate>

@property(nonatomic,copy)NSArray<XPQuotationModel*> *dataArray;

@property(nonatomic,strong)NSArray<ListModel *>*ListModelArray;

@property(nonatomic,assign)NSInteger index;




@end
