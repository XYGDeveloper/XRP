//
//  XPSearchSecftionHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPSearchSecftionHeaderTableViewCell.h"

@implementation XPSearchSecftionHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = kLocat(@"C_community_search_result");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
