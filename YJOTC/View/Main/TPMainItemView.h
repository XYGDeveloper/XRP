//
//  TPMainItemView.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/3.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPMainItemView : UIView

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *nameLabel;



-(instancetype)initWithFrame:(CGRect)frame icon:(NSString *)imageName itemName:(NSString *)name;




@end
