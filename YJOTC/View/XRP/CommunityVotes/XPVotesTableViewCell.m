//
//  XPVotesTableViewCell.m
//  YJOTC
//
//  Created by l on 2019/1/5.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPVotesTableViewCell.h"
@interface XPVotesTableViewCell()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *titleLabel;


@end

@implementation XPVotesTableViewCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HiraginoSans(20);
        _titleLabel.text = kLocat(@"C_community_reward_xrp_vote_count");
        _titleLabel.textColor = kColorFromStr(@"#222222");
    }
    return _titleLabel;
}

- (HYStepper *)stepper{
    if (!_stepper) {
        _stepper = [[HYStepper alloc]init];
    }
    return _stepper;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.font = HiraginoSans(12);
        _desLabel.text = kLocat(@"C_community_reward_xrp_vote_count");
        _desLabel.textColor = kColorFromStr(@"#222222");
    }
    return _desLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorFromStr(@"#F4F4F4");
        [self.contentView addSubview:self.bgView];
        [Utilities addShadowToView:self.bgView withOpacity:0.3 shadowRadius:2 andCornerRadius:8];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.stepper];
        self.stepper.valueChanged = ^(double value) {
            NSLog(@"%.f",value);
//            _label.text = [NSString stringWithFormat:@"%.f",value];
        };
        self.stepper.layer.cornerRadius = 50/2;
        self.stepper.layer.masksToBounds = YES;
        self.stepper.layer.borderWidth = 1.0f;
        self.stepper.layer.borderColor = kColorFromStr(@"#37A8E2").CGColor;
        [self.bgView addSubview:self.desLabel];
        kViewBorderRadius(self.bgView, 8, 0, kRedColor);
        [self.bgView addShadow];
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW/2);
        make.top.mas_equalTo(self.stepper.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(33);
        make.height.mas_equalTo(12);
    }];

}


- (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(15,4);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    //    CGFloat offset = 0.f;
    
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    //    view.layer.shouldRasterize = YES;
    //    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
    
}

//- (void)refreshWithModel:(XPCommunityIndexModel *)model{
//    self.titleLabel.text = model.title;
//    self.detailLabel.text = model.desc;
//    [self.img setImageWithURL:[NSURL URLWithString:model.img2] options:0];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
