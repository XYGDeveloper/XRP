
//
//  XPMineTableCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPMineTableCell.h"

@implementation XPMineTableCell




-(void)setIsAuth:(BOOL)isAuth
{
    _isAuth = isAuth;
    _label5.hidden = !isAuth;
    _icon5.hidden = !isAuth;
    _line5.hidden = !isAuth;
    _statusLabel.hidden= !isAuth;
    _arrow5.hidden = !isAuth;
}


-(void)setDataWithIcons:(NSArray *)icons titles:(NSArray *)titles
{
    _label1.text = titles[0];
    _icon1.image = kImageFromStr(icons[0]);
    
    _label2.text = titles[1];
    _icon2.image = kImageFromStr(icons[1]);
    
    _label3.text = titles[2];
    _icon3.image = kImageFromStr(icons[2]);
    
    _label4.text = titles[3];
    _icon4.image = kImageFromStr(icons[3]);
    

    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _label1.textColor = k222222Color;
    _label1.font = PFRegularFont(14);
    
    _label2.textColor = k222222Color;
    _label2.font = PFRegularFont(14);
    
    _label3.textColor = k222222Color;
    _label3.font = PFRegularFont(14);
    
    _label4.textColor = k222222Color;
    _label4.font = PFRegularFont(14);
    
    _label5.textColor = k222222Color;
    _label5.font = PFRegularFont(14);
    
    _statusLabel.textColor = k666666Color;
    _statusLabel.font = PFRegularFont(12);
    
    _label5.text = kLocat(@"s_shimingrenzheng");
    
    
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    
    kViewBorderRadius(_bgView, 8, 0, kRedColor);
    [_bgView addShadow];
    
    for (UIButton *button in _bgView.subviews) {
        
        if ([button isKindOfClass:[UIButton class]]) {
            [button addTarget:self action:@selector(sectionTapAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)sectionTapAction:(UIButton*)button
{
    
    if ([self.delegate respondsToSelector:@selector(xPMineTableCell:didTapIndex:)]) {
        [self.delegate xPMineTableCell:self didTapIndex:button.tag];
    }
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
