//
//  XPWalletCurrencyCell.m
//  YJOTC
//
//  Created by Roy on 2018/12/10.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPWalletCurrencyCell.h"

@implementation XPWalletCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat w = self.width/3;
    CGFloat h = 88;
    CGFloat margin = 0;
    
    NSInteger itemCount = 3;
    for (NSInteger i = 0; i < itemCount; i++) {
        TPMainCurrencyInfoView *view = [[TPMainCurrencyInfoView alloc] initWithFrame:kRectMake(0 + (w + margin) * i, 5, w, h)];
        view.backgroundColor = kWhiteColor;
        [self addSubview:view];
//        view.model = self.currencyInfos[i];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
