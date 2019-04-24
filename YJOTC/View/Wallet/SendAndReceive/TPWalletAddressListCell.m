//
//  TPWalletAddressListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletAddressListCell.h"

@implementation TPWalletAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    
    _addressLabel.textColor = k666666Color;;
    _addressLabel.font = PFRegularFont(12);
    
    _tagLabel.textColor = k222222Color;
    _tagLabel.font = PFRegularFont(14);
    
    
    _line.backgroundColor = kCCCCCCColor;
    
    [_editButton setTitleColor:k666666Color forState:UIControlStateNormal];
    _editButton.titleLabel.font = PFRegularFont(12);
    [_deleteButton setTitleColor:k666666Color forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = PFRegularFont(12);
//    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitle:[NSString stringWithFormat:@" %@",kLocat(@"k_popview_select_paywechat_edit_action")] forState:UIControlStateNormal];

    [_deleteButton setTitle:[NSString stringWithFormat:@" %@",kLocat(@"Dis_Delete")] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
