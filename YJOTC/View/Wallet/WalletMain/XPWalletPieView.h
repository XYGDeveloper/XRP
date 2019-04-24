//
//  XPWalletPieView.h
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWalletCurrencyModel.h"



@interface XPWalletPieView : UIView

@property(nonatomic,strong)NSArray<TPWalletCurrencyModel *> *currencyArray;

@property(nonatomic,assign)BOOL notLogin;



@end


