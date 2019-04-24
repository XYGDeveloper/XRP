//
//  TPOTCPostCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/27.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCPostCell.h"

@interface TPOTCPostCell ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sumTopMargin;


@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *dealSum;
@property (weak, nonatomic) IBOutlet UILabel *postVolume;
@property (weak, nonatomic) IBOutlet UILabel *limtPrice;






@end

@implementation TPOTCPostCell


-(void)setType:(NSInteger)type
{
    _type = type;
    /**  0 买  1 卖  */

    if (_type == 0) {
        _sliderView.hidden = YES;
        _sumTopMargin.constant = 50;
    }else{
        _sliderView.hidden = NO;
        _sumTopMargin.constant = 135;
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor =  kWhiteColor;
    _priceTF.placeholder = @"0.0000";
    _priceTF.superview.backgroundColor = kClearColor;
    _priceTF.textColor = k222222Color;
    _priceTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor(_priceTF, kColorFromStr(@"#999999"));
    
    _volumeTF.placeholder = @"0.000000";
    _volumeTF.superview.backgroundColor = kClearColor;
    _volumeTF.textColor = k222222Color;
    _volumeTF.font = PFRegularFont(14);
    kTextFieldPlaceHoldColor(_volumeTF, kColorFromStr(@"#999999"));
    
    
    _limitMarkLabel1.textColor = k666666Color;
    _limitMarkLabel1.font = PFRegularFont(14);
    _limitMarkLabel2.textColor = k666666Color;
    _limitMarkLabel2.font = PFRegularFont(14);
    
    _sumMarkLabel.font = PFRegularFont(12);
    _sumMarkLabel.textColor = k666666Color;
    
    _ownVolumeLabel.textColor = k666666Color;
    _ownVolumeLabel.font = PFRegularFont(12);
    
    _limiteInfoLabel.font = PFRegularFont(12);
    
    
    
    _limiteLowButton.titleLabel.font = PFRegularFont(12);
    [_limiteLowButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [_limiteLowButton setImage:kImageFromStr(@"fbcs_icon_nox") forState:UIControlStateNormal];
    [_limiteLowButton setImage:kImageFromStr(@"fbcs_icon_prex") forState:UIControlStateSelected];
    
    _limiteHighButton.titleLabel.font = PFRegularFont(12);
    [_limiteHighButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [_limiteHighButton setImage:kImageFromStr(@"fbcs_icon_nox") forState:UIControlStateNormal];
    [_limiteHighButton setImage:kImageFromStr(@"fbcs_icon_prex") forState:UIControlStateSelected];
    
    _limiteLowButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    _limiteLowButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    _limiteHighButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    _limiteHighButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    
    
    _remarkTV.placeholder = kLocat(@"OTC_view_necessary");
    _remarkTV.backgroundColor = kClearColor;
    _remarkTV.font = PFRegularFont(14);
    _remarkTV.textColor = k222222Color;
    
    _lowLimitTF.textColor = k222222Color;
    _lowLimitTF.font = PFRegularFont(14);
    
    _highLimitTF.textColor = k222222Color;
    _highLimitTF.font = PFRegularFont(14);
    
    _sumTF.superview.backgroundColor = kClearColor;
    _sumTF.textColor = k222222Color;
    _sumTF.font = PFRegularFont(14);
    _sumTF.placeholder = @"0.00";
    kTextFieldPlaceHoldColor(_sumTF, kColorFromStr(@"#999999"));
    
    
    kViewBorderRadius(_lowLimitTF.superview, 0, 0.5, kColorFromStr(@"#999999"));
    kViewBorderRadius(_highLimitTF.superview, 0, 0.5, kColorFromStr(@"#999999"));
    kViewBorderRadius(_sumTF.superview, 0, 0.5, kColorFromStr(@"#999999"));
    
    kViewBorderRadius(_topView, 0, 0.5, k999999Color);
    kViewBorderRadius(_midView, 0, 0.5, k999999Color);
    kViewBorderRadius(_remarkTV.superview, 0, 0.5, kColorFromStr(@"#999999"));
    kViewBorderRadius(_topView, 0, 0.5, kColorFromStr(@"#999999"));
    kViewBorderRadius(_topView, 0, 0.5, kColorFromStr(@"#999999"));
    
    
    _dealSum.text = kLocat(@"k_MyassetViewController_tableview_list_cell_right_jye");
    _postVolume.text = kLocat(@"OTC_post_volume");
    _limtPrice.text = kLocat(@"limit_price");
    _remark.text = kLocat(@"OTC_view_moneyremark");
    
    [_limiteLowButton setTitle:kLocat(@"OTC_view_limitelowsum") forState:UIControlStateNormal];
    [_limiteHighButton setTitle:kLocat(@"OTC_view_limitehighsum") forState:UIControlStateNormal];
    
    _lowLimitTF.userInteractionEnabled = NO;
    _highLimitTF.userInteractionEnabled = NO;
    [_limiteLowButton setTitleColor:k222222Color forState:UIControlStateNormal];
    [_limiteHighButton setTitleColor:k222222Color forState:UIControlStateNormal];
    
    _limtPrice.textColor = k222222Color;
    _postVolume.textColor = _limtPrice.textColor;
    _dealSum.textColor = _limtPrice.textColor;
    _remark.textColor = _limtPrice.textColor;
    _remarkTV.textColor = _limtPrice.textColor;
    
    
    
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
