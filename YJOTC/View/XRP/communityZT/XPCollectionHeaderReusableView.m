//
//  XPCollectionHeaderReusableView.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCollectionHeaderReusableView.h"
#import "XPGetValiModel.h"
@interface XPCollectionHeaderReusableView()
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation XPCollectionHeaderReusableView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=kColorFromStr(@"#F4F4F4");
        [self createBasicView];
    }
    return self;
    
}


-(void)createBasicView{
    
    self.leftView = [[UIView alloc]init];
    self.leftView.backgroundColor = kColorFromStr(@"#066B98");
    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(13);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
//    titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = kColorFromStr(@"#222222");
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.leftView.mas_right).mas_equalTo(10);
    }];
}

- (void)refreshWithModel:(outterModel *)model{
    self.titleLabel.text = model.name;
}


@end
