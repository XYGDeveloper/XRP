
//
//  XPAssetBankCommonCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBankCommonCell.h"

@interface XPAssetBankCommonCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation XPAssetBankCommonCell


-(void)setShowArrow:(BOOL)showArrow
{
    _showArrow = showArrow;
    
    if (showArrow == YES) {
        _leftMargin.constant = 10 + 10 + 2;
        _icon.hidden = NO;
    }else{
        _leftMargin.constant = 10;
        _icon.hidden = YES;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor =kTableColor;
    _itemLabel.textColor = k666666Color;
    _itemLabel.font = PFRegularFont(14);
    
    _infoLabel.textColor = k222222Color;
    _infoLabel.font = PFRegularFont(14);
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    
    [self.bgView addShadow];
    
    
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _icon.hidden = YES;
    _infoLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
