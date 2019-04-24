
//
//  TPMainItemView.m
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPMainItemView.h"

@implementation TPMainItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame icon:(NSString *)imageName itemName:(NSString *)name
{
    TPMainItemView *view = [[TPMainItemView alloc]initWithFrame:frame];
    view.icon.image = kImageFromStr(imageName);
    view.nameLabel.text = name;
    return view;
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIImageView *icon = [[UIImageView alloc]initWithFrame:kRectMake(0, 22, 35, 35)];
    [self addSubview:icon];
    [icon alignHorizontal];
    
    UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(0, icon.bottom + 6, self.width, 15) text:@"" font:PFRegularFont(14) textColor:k222222Color textAlignment:1 adjustsFont:YES];
    [self addSubview:label];
    
    _nameLabel = label;
    _icon = icon;
    
}



@end
