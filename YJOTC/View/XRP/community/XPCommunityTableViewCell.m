//
//  XPCommunityTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/24.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityTableViewCell.h"
#import "XPCommunityIndexModel.h"
@interface XPCommunityTableViewCell()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *flagView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIImageView *img;

@end

@implementation XPCommunityTableViewCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)flagView{
    if (!_flagView) {
        _flagView = [[UIView alloc]init];
        _flagView.backgroundColor = kColorFromStr(@"#066B98");
    }
    return _flagView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HiraginoSans(14);
        _titleLabel.textColor = kColorFromStr(@"#222222");
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = HiraginoSans(12);
        _detailLabel.textColor = kColorFromStr(@"#666666");
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
    }
    return _img;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorFromStr(@"#F4F4F4");
        [self.contentView addSubview:self.bgView];
        [Utilities addShadowToView:self.bgView withOpacity:0.3 shadowRadius:2 andCornerRadius:8];
        [self.bgView addSubview:self.flagView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.detailLabel];
        [self.bgView addSubview:self.img];
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
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.flagView.mas_centerY);
        make.left.mas_equalTo(self.flagView.mas_right).mas_equalTo(13);
        make.height.mas_equalTo(20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.flagView.mas_left);
        make.top.mas_equalTo(self.flagView.mas_bottom).mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
        make.width.mas_equalTo(kScreenW - 26 - 20);
    }];
    
    
    
    
//    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.detailLabel.mas_right).mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//        make.top.mas_equalTo(self.flagView.mas_bottom).mas_equalTo(20);
//        make.height.mas_equalTo(130);
//    }];
    self.img.hidden = YES;
    
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


- (void)refreshWithModel:(XPCommunityIndexModel *)model{
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.desc;
    
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.lineSpacing = 10 - (self.detailLabel.font.lineHeight - self.detailLabel.font.pointSize);
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:model.desc attributes:attributes];
    
//    [self.img setImageWithURL:[NSURL URLWithString:model.img2] options:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
