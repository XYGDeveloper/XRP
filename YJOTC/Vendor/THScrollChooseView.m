//
//  THScrollChooseView.m
//  THChooseTool


#define THScreenW [UIScreen mainScreen].bounds.size.width

#define THScreenH [UIScreen mainScreen].bounds.size.height

#define THWParam [UIScreen mainScreen].bounds.size.width/375.0f

#define THfloat(a) a*THWParam

#import "THScrollChooseView.h"


@interface THScrollChooseView()<UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) UIView *bottomView;

/**
 取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;

/**
 确定按钮
 */
@property (strong, nonatomic) UIButton *confirmButton;

/**
 选中数据是第几条
 */
@property (assign, nonatomic) NSInteger selectedValue;

/**
 数组
 */
@property (strong, nonatomic) NSArray *questionArray;
/**
 默认的值
 */
@property (copy, nonatomic) NSString *defaultDesc;

@end

@implementation THScrollChooseView


static NSInteger recordRowOfQuestion;


- (instancetype)initWithQuestionArray:(NSArray *)questionArray withDefaultDesc:(NSString *)defaultDesc {
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        self.frame = CGRectMake(0, 0, THScreenW, THScreenH);
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 198+45)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        _bottomView = whiteView;

        //按钮所在区域
        UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,THScreenW,45)];
        viewBg.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];

        [whiteView addSubview:viewBg];
      
        //创建取消 确定按钮
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, viewBg.height)];
        [viewBg addSubview:cancelButton];
        [cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = PFRegularFont(16);
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
      
        UIButton *confirmlButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, viewBg.height)];
        [viewBg addSubview:confirmlButton];
        confirmlButton.right = kScreenW - kMargin;
        [confirmlButton setTitle:kLocat(@"Confirm") forState:UIControlStateNormal];
        [confirmlButton setTitleColor:kColorFromStr(@"#6189C5") forState:UIControlStateNormal];
        confirmlButton.titleLabel.font = PFRegularFont(16);
        confirmlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        confirmlButton.tag = tag;
        [confirmlButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor  = kColorFromStr(@"#666666");
        label.text = kLocat(@"THScrollChooseView_title");
        [viewBg addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelButton.mas_right);
            make.centerY.mas_equalTo(cancelButton.mas_centerY);
            make.right.mas_equalTo(confirmlButton.mas_left);
            make.height.mas_equalTo(35);
        }];
        self.questionArray = questionArray;
        self.defaultDesc = defaultDesc;
        [whiteView addSubview:self.pickerView];
        
        [UIView animateWithDuration:0.25 animations:^{
           
            whiteView.frame = CGRectMake(0, kScreenH-198-45, kScreenW, 198+45);
            
            
        }];
        
        
    }
    
    return self;
}


#pragma mark - action

- (void)cancelButtonAction:(UIButton *)button {
    
    [self dismissView];
    
}

- (void)confirmButtonAction:(UIButton *)button {
    
    self.confirmBlock(self.selectedValue);
    
    [self dismissView];
}

- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//        self.frame = kRectMake(0, kScreenH, kScreenH, kScreenW);
        
        _bottomView.frame = kRectMake(0, kScreenH, kScreenH, 198+45);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}


#pragma mark - pickerView 代理方法

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.questionArray.count;
}

-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component {
    return THfloat(35);
}

// 显示什么
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.questionArray[row];
}

// 选中时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedValue = row;
}


- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45 , THScreenW, 198)];
        _pickerView.backgroundColor = [UIColor clearColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        // _pickerView 初始化显示的值
        if (self.defaultDesc.length == 0) {
            //无默认值时显示第一个
            [_pickerView selectRow:0 inComponent:0 animated:YES];
            
        }else {
            //有默认值时显示默认值
            recordRowOfQuestion = [self rowOfQuestionWithName:self.defaultDesc];
            [_pickerView selectRow:recordRowOfQuestion inComponent:0 animated:YES];
            self.selectedValue = recordRowOfQuestion;
            
        }
    }
    return _pickerView;
}


- (NSInteger)rowOfQuestionWithName:(NSString *)questionName{
    
    NSInteger row = 0;
    for (NSString *str in self.questionArray) {
        if ([str containsString:self.defaultDesc]) {
            return row;
        }
        row++;
    }
    return row;
}




@end
