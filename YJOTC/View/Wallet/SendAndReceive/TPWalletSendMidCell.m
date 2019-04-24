//
//  TPWalletSendMidCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/12.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletSendMidCell.h"

@interface TPWalletSendMidCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;


@end

@implementation TPWalletSendMidCell

-(void)setIsXRP:(BOOL)isXRP
{
    _isXRP = isXRP;
    if (_isXRP) {
        _bottomMargin.constant = 46*2;
        _xrpTF.hidden = NO;
        _xrpLine.hidden = NO;
        _xrpTF.placeholder = kLocat(@"M_enterxrptag");

    }else{
        _bottomMargin.constant = 46;
        _xrpTF.hidden = YES;
        _xrpLine.hidden = YES;
    }

}

-(void)setIsEOS:(BOOL)isEOS
{
    _isEOS = isEOS;
    if (_isEOS) {
        _bottomMargin.constant = 46*2;
        _xrpTF.hidden = NO;
        _xrpLine.hidden = NO;
        _xrpTF.placeholder = kLocat(@"M_enterxrptag_EOS");
    }else{
        _bottomMargin.constant = 46;
        _xrpTF.hidden = YES;
        _xrpLine.hidden = YES;
    }
    
}





- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    
    [_saveButton setImage:kImageFromStr(@"kuang_icon") forState:UIControlStateNormal];
    [_saveButton setImage:kImageFromStr(@"kuang_icon_gou") forState:UIControlStateSelected];
    
    _saveButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    _saveButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    [_saveButton setTitleColor:kColorFromStr(@"#999999") forState:UIControlStateNormal];
    _saveButton.titleLabel.font = PFRegularFont(12);
    [_saveButton setTitle:kLocat(@"W_savetobooklist") forState:UIControlStateNormal];

    
    _title.textColor = k666666Color;
    _title.font = PFRegularFont(16);
    
    [_addressButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
    _addressButton.titleLabel.font = PFRegularFont(14);
    
    _addTF.textColor = k666666Color;
    _addTF.font = PFRegularFont(12);
    _addTF.placeholder = kLocat(@"W_enterorpasteaddress");
    kTextFieldPlaceHoldColor(_addTF, kColorFromStr(@"#999999"));
    
    _tagTF.textColor = k666666Color;
    _tagTF.font = PFRegularFont(12);
    _tagTF.placeholder = kLocat(@"s0115_nameoptioinal");
    kTextFieldPlaceHoldColor(_tagTF, kColorFromStr(@"#999999"));
    
    [_addressButton setTitle:kLocat(@"W_addressBook") forState:UIControlStateNormal];
    
    _title.text = kLocat(@"W_receiveaddress");
    
    _xrpTF.textColor = k666666Color;
    _xrpTF.font = PFRegularFont(12);
    _xrpTF.placeholder = kLocat(@"M_enterxrptag");
    kTextFieldPlaceHoldColor(_xrpTF, kColorFromStr(@"#999999"));
    _xrpTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _xrpLine.hidden = YES;
    _xrpTF.hidden = YES;
    _bottomMargin.constant = 46;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
