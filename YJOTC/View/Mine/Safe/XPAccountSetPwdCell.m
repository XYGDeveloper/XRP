
//
//  XPAccountSetPwdCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/11.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAccountSetPwdCell.h"

@interface XPAccountSetPwdCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;


@end


@implementation XPAccountSetPwdCell

-(void)setShowCodeButton:(BOOL)showCodeButton
{
    _showCodeButton = showCodeButton;
    if (_showCodeButton) {
        _rightMargin.constant = 80;
        _codeButton.hidden = NO;
    }else{
        _rightMargin.constant = 12;
        _codeButton.hidden = YES;
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kWhiteColor;
    self.lineView.backgroundColor = kGrayLineColor;
    self.descLabel.textColor = k222222Color;
    self.descLabel.font = PFRegularFont(14);
    
    _TF.textColor = k222222Color;
    _TF.font = PFRegularFont(16);
    
    _TF.placeholder = @"1";
    
    kTextFieldPlaceHoldColor(_TF, kColorFromStr(@"cccccc"));
    [_codeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _codeButton.titleLabel.font = PFRegularFont(12);
    _codeButton.backgroundColor = kColorFromStr(@"#6189C5");
    
    [_codeButton setTitle:kLocat(@"HBRegisterTableViewController_getvalcode") forState:UIControlStateNormal];
    _codeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    _countryButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [_countryButton setTitleColor:k666666Color forState:UIControlStateNormal];
    _countryButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
