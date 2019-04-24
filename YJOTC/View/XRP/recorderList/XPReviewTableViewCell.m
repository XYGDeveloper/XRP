//
//  XPReviewTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/1/3.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPReviewTableViewCell.h"

@implementation XPReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.reviewButton.layer.cornerRadius = 5;
    self.reviewButton.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
