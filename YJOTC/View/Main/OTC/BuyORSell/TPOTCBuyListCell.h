//
//  TPOTCBuyListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/22.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPOTCBuyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *lineView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UILabel *limitLabel;


@property (weak, nonatomic) IBOutlet UIImageView *way1;
@property (weak, nonatomic) IBOutlet UIImageView *way2;
@property (weak, nonatomic) IBOutlet UIImageView *way3;



@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property(nonatomic,strong)TPOTCOrderModel *model;

@property (weak, nonatomic) IBOutlet UIView *topView;

/**  是否是个人商户页  */
@property(nonatomic,assign)BOOL isProfile;



@end
