//
//  HYStepper.m
//  HYStepper
//
//  Created by zhuxuhong on 2017/7/16.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

#import "HYStepper.h"


@interface HYStepper()

@property(nonatomic,copy)UIButton *minusBtn;
@property(nonatomic,copy)UIButton *plusBtn;
@property(nonatomic,copy)UITextField *valueTF;

@end

@implementation HYStepper

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self initData];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initData];
        
        [self setupUI];
    }
    return self;
}

-(void)initData{
    _isValueEditable = true;
    _stepValue = 1;
    _minValue = 0;
    _maxValue = 100;
    
    self.value = 0;
}

-(void)setupUI{
    [self addSubview: self.minusBtn];
    [self addSubview: self.plusBtn];
    [self addSubview: self.valueTF];
    [self setupLayout];
}

-(void)setupLayout{
    
    [self.valueTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenW/2);
        make.height.mas_equalTo(45);
    }];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.plusBtn.mas_left).mas_equalTo(-12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(36);
    }];
    
}

#pragma mark - action
-(void)actionForButtonClicked: (UIButton*)sender{
    if ([sender isEqual:_minusBtn]) {
        self.value = _value - _stepValue;
    }
    else if([sender isEqual:_plusBtn]){
        self.value = _value + _stepValue;
    }
}

-(void)actionForTextFieldValueChanged: (UITextField*)sender{
    if ([sender isEqual:_valueTF]) {
        self.value = [sender.text doubleValue];
    }
}


#pragma mark - setters
-(void)setValue:(double)value{
    if (value < _minValue) {
        value = _minValue;
    }
    else if (value > _maxValue){
        value = _maxValue;
    }
    
    _minusBtn.enabled = value > _minValue;
    _plusBtn.enabled = value < _maxValue;
    _valueTF.text = [NSString stringWithFormat:@"%.0f",value];
        
    _value = value;
    
    _valueChanged ? _valueChanged(_value) : nil;
}

-(void)setMaxValue:(double)maxValue{
    if (maxValue < _minValue) {
        maxValue = _minValue;
    }
    _maxValue = maxValue;
}

-(void)setMinValue:(double)minValue{
    if (minValue > _maxValue) {
        minValue = _maxValue;
    }
    _minValue = minValue;
}

-(void)setIsValueEditable:(BOOL)isValueEditable{
    _isValueEditable = isValueEditable;
    
    _valueTF.enabled = _isValueEditable;
}

#pragma mark - private
-(UIButton*)actionButtonWithTitle: (NSString*)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = kColorFromStr(@"#2091C0");
    btn.tintColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:28];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionForButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


#pragma mark - getters
-(UITextField *)valueTF{
    if (!_valueTF) {
        UITextField *tf = [UITextField new];
        tf.font = [UIFont systemFontOfSize:16];
        [tf addTarget:self action:@selector(actionForTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        tf.borderStyle = UITextBorderStyleNone;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentLeft;
        tf.enabled = self.isValueEditable;
        tf.translatesAutoresizingMaskIntoConstraints = false;
        tf.text = [NSString stringWithFormat:@"%.0f",self.value];
        _valueTF = tf;
    }
    return _valueTF;
}

-(UIButton *)minusBtn{
    if (!_minusBtn) {
        UIButton *btn = [self actionButtonWithTitle:@"-"];
        btn.layer.cornerRadius = 36/2;
        btn.layer.masksToBounds = YES;
        _minusBtn = btn;
    }
    return _minusBtn;
}

-(UIButton *)plusBtn{
    if (!_plusBtn) {
        UIButton *btn = [self actionButtonWithTitle:@"+"];
        btn.layer.cornerRadius = 36/2;
        btn.layer.masksToBounds = YES;
        _plusBtn = btn;
    }
    return _plusBtn;
}

@end
