
//
//  TPWalletSendRemarkCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/15.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendRemarkCell.h"

@interface TPWalletSendRemarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;


@end


@implementation TPWalletSendRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
    self.remarkTV.font = PFRegularFont(14);
    
    self.remarkTV.textColor = k666666Color;
    self.remarkTV.backgroundColor = kClearColor;

    self.remarkTV.placeholder = kLocat(@"W_plzenterremark");
    kViewBorderRadius(_remarkTV, 0, 0.5, kColorFromStr(@"#999999"));
    
    
    _title.text = kLocat(@"W_leaveword");
    
    /**  修改placeholder颜色  */
    for (UIView *v in _remarkTV.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            label.textColor = kColorFromStr(@"#999999");
            break;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
