//
//  XPBindHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPBindHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaiLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@end
