//
//  TPQuotationModel.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPQuotationModel : NSObject

@property(nonatomic,copy)NSString *currency_id;
@property(nonatomic,copy)NSString *currency_name;
@property(nonatomic,copy)NSString *currency_mark;
@property(nonatomic,copy)NSString *currency_logo;
@property(nonatomic,copy)NSString *old_price;
@property(nonatomic,copy)NSString *nprice;
@property(nonatomic,copy)NSString *nprice_status;
@property(nonatomic,copy)NSString *change_24H;
@property(nonatomic,copy)NSString *done_24H;
@property(nonatomic,copy)NSString *cny;


@property(nonatomic,copy)NSString * trade_currency_mark;
@property(nonatomic,copy)NSString * nprice_cny;



@property(nonatomic,assign)NSInteger isSelected;




@end
