//
//  XPCashTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPCashTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *rightImg;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
