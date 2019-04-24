//
//  XPSearchHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPSearchHeaderTableViewCell.h"

@implementation XPSearchHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.accounterContent.layer.borderWidth = 1;
    self.accounterContent.layer.borderColor = kColorFromStr(@"#999999").CGColor;
    self.idContent.layer.borderWidth = 1;
    self.idContent.layer.borderColor = kColorFromStr(@"#999999").CGColor; kViewBorderRadius(self.searchButton, 8, 0, kRedColor);
    [self.searchButton addShadow];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
