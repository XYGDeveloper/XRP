//
//  TPDealDetailTopCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPDealDetailTopCell : UITableViewCell

/**  0 历史记录   1  成交明细  2 委托 */
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;

@end
