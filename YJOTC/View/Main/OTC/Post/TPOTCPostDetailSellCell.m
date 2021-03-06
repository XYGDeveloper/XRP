//
//  TPOTCPostDetailSellCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/28.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostDetailSellCell.h"

@implementation TPOTCPostDetailSellCell


-(void)setModel:(TPOTCPayWayModel *)model
{
    _model = model;
    
    if ([model.type isEqualToString:kZFB]) {
        _icon.image = kImageFromStr(@"gmxq_icon_zfb");
        _typeLabel.text = kLocat(@"k_popview_select_payalipay");
    }else if ([model.type isEqualToString:kWechat]){
        _icon.image = kImageFromStr(@"gmxq_icon_wx");
        _typeLabel.text = kLocat(@"k_popview_select_paywechat");
    }else{
        _icon.image = kImageFromStr(@"gmxq_icon_yhk");
        _typeLabel.text = kLocat(@"k_popview_select_paybank");
    }
    _accountLabel.text = model.cardnum;
    
    _swtch.on = model.isSelected;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    self.lineView.backgroundColor = kCCCCCCColor;
    
    self.typeLabel.textColor = k222222Color;;
    self.typeLabel.font = PFRegularFont(14);
    
    self.accountLabel.textColor = k666666Color;;
    self.accountLabel.font = PFRegularFont(16);
    
    [self.modifyButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    [self.modifyButton setTitle:kLocat(@"k_YTsetViewController_bt1") forState:UIControlStateNormal];
    self.modifyButton.titleLabel.font = PFRegularFont(16);
    
    self.swtch.tintColor = kColorFromStr(@"#6189C5");
    self.swtch.onTintColor = kColorFromStr(@"#6189C5");

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
