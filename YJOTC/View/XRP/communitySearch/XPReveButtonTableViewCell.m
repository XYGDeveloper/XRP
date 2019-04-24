//
//  XPReveButtonTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPReveButtonTableViewCell.h"

@implementation XPReveButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    kViewBorderRadius(self.firstButton, 8, 0, kRedColor);
    [self.firstButton addShadow];
    [self.firstButton setTitle:kLocat(@"C_community_search_bind_sure") forState:UIControlStateNormal];
    kViewBorderRadius(self.sedButton, 8, 1, kColorFromStr(@"#6189C5"));
    [self.sedButton addShadow];
    [self.sedButton setTitle:kLocat(@"C_community_search_bind_reset") forState:UIControlStateNormal];
    
    kViewBorderRadius(self.seButton, 8, 0, kRedColor);
    [self.seButton addShadow];
    [self.seButton setTitle:kLocat(@"C_community_search_bind_self") forState:UIControlStateNormal];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)firAction:(id)sender {
    if (self.sure) {
        self.sure();
    }
    
}


- (IBAction)sedAction:(id)sender {
    if (self.reset) {
        self.reset();
    }
    
}

- (IBAction)selAction:(id)sender {
    if (self.tose) {
        self.tose();
    }
}

@end
