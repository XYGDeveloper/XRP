//
//  TPCommonListCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCommonListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
