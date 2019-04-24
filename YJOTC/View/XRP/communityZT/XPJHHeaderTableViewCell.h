//
//  XPJHHeaderTableViewCell.h
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPGetValiModel;

@interface XPJHHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hLabel;
@property (weak, nonatomic) IBOutlet UILabel *fLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firImg;
@property (weak, nonatomic) IBOutlet UILabel *firLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sedImg;
@property (weak, nonatomic) IBOutlet UILabel *sedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagIMg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;

- (void)refreshWithModel:(XPGetValiModel *)model;

@end

