//
//  XPPayMethodTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/28.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPPayMethodTableViewCell.h"

@implementation XPPayMethodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.payButton, 8, 0, kRedColor);
    [self.payButton addShadow];
    
    kViewBorderRadius(self.rbjButton, 8, 1, kColorFromStr(@"#6189C5"));
    [self.rbjButton addShadow];
    [self.rbjButton setTitle:kLocat(@"C_basic_recorlist_rbjpay") forState:UIControlStateNormal];
    
    kViewBorderRadius(self.rbzButton, 8, 1, kColorFromStr(@"#6189C5"));
    [self.rbzButton addShadow];
    [self.rbzButton setTitle:kLocat(@"C_basic_recorlist_rbzpay") forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
