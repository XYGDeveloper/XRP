//
//  TPWalletVolumeCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletVolumeCell.h"

@implementation TPWalletVolumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    
    _title.font = PFRegularFont(16);
    _title.textColor = k666666Color;
    
    _tf.textColor = k666666Color;
    _tf.font = PFRegularFont(18);
    _tf.placeholder = @"0.000000";
    kTextFieldPlaceHoldColor(_tf, kColorFromStr(@"#999999"));
    
    _nameLabel.textColor = k666666Color;
    _nameLabel.font = PFRegularFont(24);
    
    _avaLabel.textColor = k222222Color;
    _avaLabel.font = PFRegularFont(12);
    
    _cnyLabel.textColor = k222222Color;
    _cnyLabel.font = PFRegularFont(12);
    
    _maxVolumeLabel.textColor = kColorFromStr(@"#E1545A");
    _maxVolumeLabel.font = PFRegularFont(12);
    _maxVolumeLabel.text = @"";
    
    _maxVolumeLabel.hidden = YES;
    
    _title.text = kLocat(@"W_SendVol");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
