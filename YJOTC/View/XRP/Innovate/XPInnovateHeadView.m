//
//  XPInnovateHeadView.m
//  YJOTC
//
//  Created by Roy on 2019/1/18.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovateHeadView.h"

@implementation XPInnovateHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.backgroundColor = kColorFromStr(@"#225686");
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 36, kScreenW, 14) text:kLocat(@"C_community_bouns_static_sum_leveel") font:PFRegularFont(12) textColor:kWhiteColor textAlignment:1 adjustsFont:YES];
    [self addSubview:titleLabel];
    UILabel *volumeLabel = [[UILabel alloc] initWithFrame:kRectMake(0, 63, kScreenW, 26) text:@"0" font:PFRegularFont(26) textColor:kWhiteColor textAlignment:1 adjustsFont:YES];
    [self addSubview:volumeLabel];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:kRectMake(0, 106 , 240 * kScreenWidthRatio, 40) title:kLocat(@"s0118_sendXRPGToMember") titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:0];
    sendButton.backgroundColor = kColorFromStr(@"#E4A646");
    [self addSubview:sendButton];
    [sendButton alignHorizontal];
    kViewBorderRadius(sendButton, 8, 0, kRedColor);
    _volumeLabel = volumeLabel;
    _sendButton = sendButton;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    CGPoint tempPoint = [_sendButton convertPoint:point fromView:self];
    if ([_sendButton pointInside:tempPoint withEvent:event]) {
        return _sendButton;
    }
    return view;
}




@end
