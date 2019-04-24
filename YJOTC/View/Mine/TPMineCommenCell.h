//
//  TPMineCommenCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/1.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPMineCommenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemIcon;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemLabelLetfMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelRightMargin;

@end
