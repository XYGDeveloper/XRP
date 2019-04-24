//
//  XPWalletChibiCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPWalletChibiCell.h"


@interface XPWalletChibiCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation XPWalletChibiCell


-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    if (_isLogin) {
        _youLabel.hidden = YES;
        _orLabel.hidden = YES;
        _registerButton.hidden = YES;
        _loginButton.hidden = YES;
        
        _volumeLabel.hidden = NO;
        _joinButton.hidden = NO;
        _supportLabel.hidden = NO;
        _descLabel.hidden = NO;
    }else{
        _youLabel.hidden = NO;
        _orLabel.hidden = NO;
        _registerButton.hidden = NO;
        _loginButton.hidden = NO;
        _volumeLabel.hidden = YES;
        _joinButton.hidden = YES;
        _supportLabel.hidden = YES;
        _descLabel.hidden = YES;
        
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = kTableColor;
    self.selectionStyle = 0;

    
    self.bgView.backgroundColor = kWhiteColor;
    kViewBorderRadius(self.bgView, 8, 0, kRedColor);
    [self.bgView addShadow];
    self.bgView.layer.masksToBounds = NO;
    
    
    _nameLabel.textColor = k222222Color;
    _nameLabel.font = PFRegularFont(14);
    
    _supportLabel.textColor = k666666Color;
    _supportLabel.font = PFRegularFont(12);
    
    _descLabel.textColor = k666666Color;
    _descLabel.font = PFRegularFont(12);
    _descLabel.adjustsFontSizeToFitWidth = YES;
    
    _volumeLabel.textColor = kColorFromStr(@"#E4A646");
    _volumeLabel.font = PFRegularFont(18);
    
    _joinButton.titleLabel.font = PFRegularFont(13);
    [_joinButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _joinButton.backgroundColor = kColorFromStr(@"#2091C0");
    kViewBorderRadius(_joinButton, 5, 0, kRedColor);
    [_joinButton setTitle:kLocat(@"x_MineJoin") forState:UIControlStateNormal];
    _joinButton.userInteractionEnabled = NO;
    
    
    
    _youLabel.textColor = k666666Color;
    _youLabel.font = PFRegularFont(12);
    _orLabel.textColor = k666666Color;
    _orLabel.font = PFRegularFont(12);
    
    _registerButton.titleLabel.font = PFRegularFont(13);
    kViewBorderRadius(_registerButton, 5, 0.5, kColorFromStr(@"#2091C0"));
    [_registerButton setTitleColor:kColorFromStr(@"2091C0") forState:UIControlStateNormal];

    [_registerButton setTitle:kLocat(@"LRegister") forState:UIControlStateNormal];

    
    _loginButton.titleLabel.font = PFRegularFont(13);
    kViewBorderRadius(_loginButton, 5, 0, kColorFromStr(@"#2091C0"));
    [_loginButton setTitle:kLocat(@"HBLoginTableViewController_des") forState:UIControlStateNormal];
    
    [_loginButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _loginButton.backgroundColor = kColorFromStr(@"2091C0");
    
    
    _youLabel.hidden = YES;
    _orLabel.hidden = YES;
    _registerButton.hidden = YES;
    _loginButton.hidden = YES;

    
    _youLabel.text = kLocat(@"S0114_Youneed");
    _orLabel.text = kLocat(@"S0114_or");

    
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
