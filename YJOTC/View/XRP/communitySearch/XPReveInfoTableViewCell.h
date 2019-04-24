//
//  XPReveInfoTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@class auditModel;

@interface XPReveInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *firImg;
@property (weak, nonatomic) IBOutlet UIImageView *sedImg;
@property (weak, nonatomic) IBOutlet UILabel *firLabel;
@property (weak, nonatomic) IBOutlet UILabel *sedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;

- (void)refreshWithModel:(auditModel *)model;

@end
