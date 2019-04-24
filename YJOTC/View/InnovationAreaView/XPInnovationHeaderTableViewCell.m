//
//  XPInnovationHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovationHeaderTableViewCell.h"
#import "XPInnovationModel.h"
@implementation XPInnovationHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)refreshWithModel:(XPInnovationModel *)model{
    self.leftLabel.text = kLocat(@"XPInnovationHomeViewController_left");
    self.recoederlabel.text = kLocat(@"XPInnovationHomeViewController_recorder");
    [self.modifyButton setTitle:kLocat(@"XPInnovationHomeViewController_change") forState:UIControlStateNormal];
    [self.scanButton setTitle:kLocat(@"XPInnovationHomeViewController_scan") forState:UIControlStateNormal];
    self.leftCountLabel.text = model.user_num;
    if ([model.is_percent_show isEqualToString:@"0"]) {
        self.rateLabel.text = @"";
        self.modifyButton.hidden = YES;
        self.middleImg.hidden = YES;
    }else{
        self.middleImg.hidden = NO;
        self.modifyButton.hidden = NO;
        self.rateLabel.text = [NSString stringWithFormat:@"%@ %@%%",kLocat(@"XPInnovationHomeViewController_rate"),model.percent];
    }
}


@end
