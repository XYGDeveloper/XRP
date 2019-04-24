//
//  TPIdentifyCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/4.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPIdentifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineView;

@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;


@end
