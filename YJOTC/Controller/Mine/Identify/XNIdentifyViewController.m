//
//  XNIdentifyViewController.m
//  YJOTC
//
//  Created by 周勇 on 2018/6/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "XNIdentifyViewController.h"
#import "XNIdentifyCell.h"

@interface XNIdentifyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ImagePickerManagerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)BOOL isChina;

@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)ImagePickerManager *imagePickerManager;
@property(nonatomic,assign)BOOL isLeftImgView;


@property(nonatomic,strong)NSArray *sexArr;
@property(nonatomic,strong)NSArray *cardTypeArr;
@property(nonatomic,strong)NSArray *cardNOIdTypeArr;


@property(nonatomic,strong)NSArray *nationArr;
@property(nonatomic,strong)NSArray *countryArr;

@property(nonatomic,strong)UITextField *countryTF;
@property(nonatomic,strong)UITextField *cardTypeTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *numberTF;
@property(nonatomic,strong)UITextField *nationTF;
@property(nonatomic,strong)UITextField *sexTF;

@property(nonatomic,copy)NSString *temSelectedItem;

@property(nonatomic,strong)NSDictionary *selectedNationDic;
@property(nonatomic,strong)NSDictionary *selectedCountryDic;


@property(nonatomic,strong)UIImageView *leftImg;
@property(nonatomic,strong)UIImageView *rightImg;
@property(nonatomic,strong)UIImageView *handImg;


@property(nonatomic,assign)BOOL hasLeftImg;
@property(nonatomic,assign)BOOL hasRightImg;
@property(nonatomic,assign)BOOL hasHandImg;


@property(nonatomic,strong)NSArray *notChinaTitleArray;


@property(nonatomic,assign)NSInteger picTag;



@end

@implementation XNIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isChina = YES;
    _sexArr = @[kLocat(@"s_male"),kLocat(@"s_female")];
    _cardTypeArr = @[kLocat(@"s_idcard"),kLocat(@"s_passport"),kLocat(@"s_drivinglicence")];//1身份證，2護照，3駕駛證
    _cardNOIdTypeArr = @[kLocat(@"s_passport"),kLocat(@"s_drivinglicence")];
    [self setupUI];
    [self loadData];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}


-(void)setupUI
{
    self.title = kLocat(@"s_shimingrenzheng");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    
    self.tableView.backgroundColor = kTableColor;
    
    UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 90)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 42, kScreenW - 24, 40) title:kLocat(@"R_Submit") titleColor:kWhiteColor font:PFRegularFont(14) titleAlignment:0];
    button.backgroundColor = kColorFromStr(@"#6189C5");
    [footView addSubview:button];
    kViewBorderRadius(button, 8, 0, kRedColor);
    [button addShadow];
    _tableView.tableFooterView =footView;

    [button addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    button.SG_eventTimeInterval = 4.5;
    
    _tableView.backgroundColor = kWhiteColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"XNIdentifyCell" bundle:nil] forCellReuseIdentifier:@"XNIdentifyCell"];

}

-(void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    __weak typeof(self)weakSelf = self;

    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/account/country_list"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        if (success) {
            weakSelf.nationArr = [responseObj ksObjectForKey:kData][@"nation"];
            weakSelf.countryArr = [responseObj ksObjectForKey:kData][@"countries"];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isChina) {
        return self.titleArray.count;
    }else{
        return self.notChinaTitleArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *rid = @"XNIdentifyCell";
    XNIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }

    
    if(indexPath.section == 0){//地区
        cell.arrow.hidden = NO;
        cell.tf.userInteractionEnabled = NO;
        cell.tf.placeholder = kLocat(@"s_china");
        if (_isChina) {
//            cell.tf.text = @"中国";
        }
        _countryTF = cell.tf;
    }else if (indexPath.section == 1){//证件类型
        cell.arrow.hidden = NO;
        cell.tf.userInteractionEnabled = NO;
        if (_isChina) {
            cell.tf.placeholder = kLocat(@"s_idcard");
        }else{
            cell.tf.placeholder = kLocat(@"s_passport");
            cell.tf.text = kLocat(@"s_passport");
        }
        
        _cardTypeTF = cell.tf;
    }else if (indexPath.section == 2){//真实姓名
        cell.arrow.hidden = YES;
        cell.tf.userInteractionEnabled = YES;
        cell.tf.placeholder = @"";

        _nameTF = cell.tf;
    }else if (indexPath.section == 3){//证件号码
        cell.arrow.hidden = YES;
        cell.tf.userInteractionEnabled = YES;
        cell.tf.placeholder = kLocat(@"s_cardnumber");
        _numberTF = cell.tf;
    }else if (indexPath.section == 4){//性别
        cell.arrow.hidden = NO;
        cell.tf.userInteractionEnabled = NO;
        cell.tf.placeholder = kLocat(@"s_male");
        _sexTF = cell.tf;
    }else if (indexPath.section == 5){//民族
        
        if (_isChina) {
            cell.arrow.hidden = NO;
            cell.tf.userInteractionEnabled = NO;
            cell.tf.placeholder = kLocat(@"s_hanzu");
            _nationTF = cell.tf;
            return cell;
        }else{
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = 0;
            
            CGFloat w = (kScreenW - 30 - 46)/2.0;
            UIImageView *leftImg = [[UIImageView alloc] initWithFrame:kRectMake(23, 10, w, w*260/300)];
            [cell.contentView addSubview:leftImg];
            leftImg.image = kImageFromStr(@"ad_img_bgkuang");
            
            UILabel *tips1 = [[UILabel alloc] initWithFrame:kRectMake(0, leftImg.bottom + 12, w, 14) text:kLocat(@"s_phont1") font:PFRegularFont(12) textColor:kColorFromStr(@"abacb0") textAlignment:1 adjustsFont:1];
            
            [cell.contentView addSubview:tips1];
            tips1.centerX = leftImg.centerX;
            
            UIImageView *rightImg = [[UIImageView alloc] initWithFrame:kRectMake(23, 10, w, w*260/300)];
            [cell.contentView addSubview:rightImg];
            rightImg.image = kImageFromStr(@"ad_img_bgkuang");
            rightImg.right = kScreenW - 23;
            UILabel *tips2 = [[UILabel alloc] initWithFrame:kRectMake(0, leftImg.bottom + 12, w, 14) text:kLocat(@"s_phono2") font:PFRegularFont(12) textColor:kColorFromStr(@"abacb0") textAlignment:1 adjustsFont:1];
            
            [cell.contentView addSubview:tips2];
            tips2.centerX = rightImg.centerX;
            
            _leftImg = leftImg;
            _rightImg = rightImg;
            [leftImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];
            [rightImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];
            leftImg.tag = 100;
            rightImg.tag = 101;

            leftImg.userInteractionEnabled = YES;
            rightImg.userInteractionEnabled = YES;
            
            
            UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:kRectMake(23, leftImg.bottom + 44, w, w*260/300)];
            [cell.contentView addSubview:bottomImg];
            bottomImg.image = kImageFromStr(@"ad_img_bgkuang");
            bottomImg.tag = 103;

        
            UILabel *tips3 = [[UILabel alloc] initWithFrame:kRectMake(0, bottomImg.bottom + 12, w, 14) text:kLocat(@"s_photo3") font:PFRegularFont(12) textColor:k999999Color textAlignment:1 adjustsFont:1];

            [cell.contentView addSubview:tips3];
            tips3.centerX = leftImg.centerX;
            
            [bottomImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];

            _handImg = bottomImg;
            _handImg.userInteractionEnabled = YES;
            
            return cell;
            
        }
        
        
        
    }else if (indexPath.section == 6) {
        
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = 0;
        
        CGFloat w = (kScreenW - 30 - 46)/2.0;
        UIImageView *leftImg = [[UIImageView alloc] initWithFrame:kRectMake(23, 10, w, w*260/300)];
        [cell.contentView addSubview:leftImg];
        leftImg.image = kImageFromStr(@"ad_img_bgkuang");
        
        UILabel *tips1 = [[UILabel alloc] initWithFrame:kRectMake(0, leftImg.bottom + 12, w, 14) text:kLocat(@"s_phont1") font:PFRegularFont(12) textColor:kColorFromStr(@"abacb0") textAlignment:1 adjustsFont:1];
        
        [cell.contentView addSubview:tips1];
        tips1.centerX = leftImg.centerX;
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:kRectMake(23, 10, w, w*260/300)];
        [cell.contentView addSubview:rightImg];
        rightImg.image = kImageFromStr(@"ad_img_bgkuang");
        rightImg.right = kScreenW - 23;
        UILabel *tips2 = [[UILabel alloc] initWithFrame:kRectMake(0, leftImg.bottom + 12, w, 14) text:kLocat(@"s_phono2") font:PFRegularFont(12) textColor:kColorFromStr(@"abacb0") textAlignment:1 adjustsFont:1];
        
        [cell.contentView addSubview:tips2];
        tips2.centerX = rightImg.centerX;
        
        _leftImg = leftImg;
        _rightImg = rightImg;
        [leftImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];
        [rightImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];
        leftImg.tag = 100;
        rightImg.tag = 101;
        leftImg.userInteractionEnabled = YES;
        rightImg.userInteractionEnabled = YES;
        
        UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:kRectMake(23, leftImg.bottom + 44, w, w*260/300)];
        [cell.contentView addSubview:bottomImg];
        bottomImg.image = kImageFromStr(@"ad_img_bgkuang");
        bottomImg.tag = 103;
        
        UILabel *tips3 = [[UILabel alloc] initWithFrame:kRectMake(0, bottomImg.bottom + 12, w, 14) text:kLocat(@"s_photo3") font:PFRegularFont(12) textColor:k999999Color textAlignment:1 adjustsFont:1];
        
        [cell.contentView addSubview:tips3];
        tips3.centerX = leftImg.centerX;
        [bottomImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertViewVC:)]];

        _handImg = bottomImg;
        _handImg.userInteractionEnabled = YES;
        
        return cell;
    }
    return cell;
}
#pragma mark - 提交

-(void)submitAction:(UIButton *)button
{
    
    if (_countryTF.text.length == 0) {
        [self showTips:kLocat(@"s_plzchoosenationorarea")];
        return;
    }
    if (_cardTypeTF.text.length == 0) {
        [self showTips:kLocat(@"s_plzchoosecardtype")];
        return;
    }
    if (_nameTF.text.length == 0) {
        [self showTips:kLocat(@"s_plzchooseyourname")];
        return;
    }
    if (_numberTF.text.length == 0) {
        [self showTips:kLocat(@"s_plzchoosecardnumber")];
        return;
    }
    if (_sexTF.text.length == 0) {
        [self showTips:kLocat(@"s_plzchoosesex")];
        return;
    }
    if (_nationTF.text.length == 0 && _isChina == YES) {
        [self showTips:kLocat(@"s_plzchoosenation")];
        return;
    }
    if (_hasLeftImg == NO) {
        [self showTips:kLocat(@"s_plzuploadphoto1")];
        return;
    }
    if (_hasRightImg == NO) {
        [self showTips:kLocat(@"s_plzuploadphoto2")];
        return;
    }
    if (_handImg == NO) {
        [self showTips:kLocat(@"s_plzuploadphoto3")];
        return;
    }
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    if (_selectedCountryDic == nil) {
        param[@"country_code"] = @"86";
    }else{
        param[@"country_code"] = _selectedCountryDic[@"phone_code"];
    }
    if (_isChina) {
        param[@"nation_id"] = _selectedNationDic[@"nation_id"];
    }else{
        param[@"nation_id"] = @"0";
    }
    

    if ([_cardTypeTF.text isEqualToString:kLocat(@"s_idcard")]) {
        param[@"cardtype"] = @"1";
    }else if ([_cardTypeTF.text isEqualToString:kLocat(@"s_passport")]){
        param[@"cardtype"] = @"2";
    }else if ([_cardTypeTF.text isEqualToString:kLocat(@"s_drivinglicence")]){
        param[@"cardtype"] = @"5";
    }
    param[@"member_id"] = @(kUserInfo.uid);
    param[@"sex"] = [_sexTF.text isEqualToString:kLocat(@"s_male")]?@"1":@"2";
    param[@"name"] = _nameTF.text;
    param[@"idcard"] = _numberTF.text;
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:_leftImg.image]];

    param[@"pic1"] = [[Utilities convertToJSONData:@[str1]] base64EncodedString];
    
    NSString *str2 = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:_rightImg.image]];
    
    param[@"pic2"] = [[Utilities convertToJSONData:@[str2]] base64EncodedString];
    
    NSString *str3 = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",[Utilities encodeToBase64StringWithImage:_handImg.image]];
    
    param[@"pic3"] = [[Utilities convertToJSONData:@[str3]] base64EncodedString];
    
    
    button.userInteractionEnabled = NO;

    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/account/member_verify"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        button.userInteractionEnabled = YES;
        if (success) {
            [self showTips:kLocat(@"s_submitsuccesssplzwait")];
            YJUserInfo *model = kUserInfo;
            model.verify_state = @"2";
            [model saveUserInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];

            });
        }else{

            [self showTips:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            [self showPickViewWithTag:indexPath.section];
        }
            break;
        case 1:
        {
            [self showPickViewWithTag:indexPath.section];

        }
            break;
        case 4:
        {
            [self showPickViewWithTag:indexPath.section];

        }
            break;
        case 5:
        {
            [self showPickViewWithTag:indexPath.section];

        }
            break;
        default:
            break;
    }
    
    
    
    
}

//性别..
-(void)showPickViewWithTag:(NSInteger )tag
{
    [self hideKeyBoard];

    self.coverView.hidden = NO;
    UIView *bgView = [[UIView alloc]initWithFrame:kRectMake(0, kScreenH, kScreenW, 220)];
    [self.coverView addSubview:bgView];
    bgView.tag = 100;
    
    UIView *titleView = [[UIView alloc]initWithFrame:kRectMake(0, 0 , kScreenW, 45)];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 55, titleView.height)];
    [titleView addSubview:cancelButton];
    [cancelButton setTitle:kLocat(@"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:kColorFromStr(@"#066B98") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = PFRegularFont(14);
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelButton addTarget:self action:@selector(hidePickView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    UIButton *confirmlButton = [[UIButton alloc]initWithFrame:kRectMake(kMargin, 0, 60, titleView.height)];
    [titleView addSubview:confirmlButton];
    confirmlButton.right = kScreenW - kMargin;
    [confirmlButton setTitle:kLocat(@"Confirm") forState:UIControlStateNormal];
    [confirmlButton setTitleColor:kColorFromStr(@"#066B98") forState:UIControlStateNormal];
    confirmlButton.titleLabel.font = PFRegularFont(14);
    confirmlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmlButton.tag = tag;
    [confirmlButton addTarget:self action:@selector(confirmChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_pickerView) {
        [_pickerView removeAllSubviews];
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
    _pickerView = [[UIPickerView alloc]initWithFrame:kRectMake(0, 45, kScreenW, 175)];
    _pickerView.tag = tag;
    _pickerView.backgroundColor = kWhiteColor;
    [bgView addSubview:_pickerView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    //        _addressTF.text = self.bankArray.firstObject.bankname;
    [UIView animateWithDuration:0.25 animations:^{
        bgView.frame = kRectMake(0, kScreenH - 220, kScreenW, 220);
    }];
    
    
}
-(void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, 220);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
    _temSelectedItem = nil;
}
-(void)confirmChooseAction:(UIButton *)button
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *view in self.coverView.subviews) {
            view.frame = kRectMake(0, kScreenH, kScreenW, 220);
        }
        
    } completion:^(BOOL finished) {
        [self.coverView removeAllSubviews];
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
    switch (button.tag) {
        case 0:
        {
            if (_temSelectedItem.length == 0) {
                _temSelectedItem = self.countryArr.firstObject[@"name"];
                _selectedCountryDic = self.countryArr.firstObject;
            }
            _countryTF.text = _temSelectedItem;
            
            
            if ([_temSelectedItem isEqualToString:self.countryArr[0][@"name"]]) {
                _isChina = YES;
            }else{
                _isChina = NO;
            }
            
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            if (_temSelectedItem.length == 0) {
                if (_isChina) {
                    _temSelectedItem = self.cardTypeArr.firstObject;
                }else{
                    _temSelectedItem = self.cardNOIdTypeArr.firstObject;
                }
            }
            _cardTypeTF.text = _temSelectedItem;
        }
            break;
        case 4:
        {
            if (_temSelectedItem.length == 0) {
                _temSelectedItem = self.sexArr.firstObject;
            }
            _sexTF.text = _temSelectedItem;
        }
            break;
        case 5:
        {
            if (_temSelectedItem.length == 0) {
                _temSelectedItem = self.nationArr.firstObject[@"nation_name"];
                _selectedNationDic = self.nationArr.firstObject;
            }
            _nationTF.text = _temSelectedItem;
        }
            break;
            
        default:
            break;
    }
    
    _temSelectedItem = nil;
}

#pragma mark - 选择器
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
        {
            return self.countryArr.count;
        }
            break;
        case 1:
        {
            if (_isChina) {
                return self.cardTypeArr.count;
            }else{
                return self.cardNOIdTypeArr.count;
            }
        }
            break;
        case 4:
        {
            return self.sexArr.count;
        }
            break;
        case 5:
        {
            return self.nationArr.count;
        }
            break;
            
        default:
            return 100;
            break;
    }
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str1 = nil;
    
    switch (pickerView.tag) {
            
        case 0:
        {
            str1 = self.countryArr[row][@"name"];
        }
            break;
        case 1:
        {
            if (_isChina) {
                str1 = self.cardTypeArr[row];

            }else{
                str1 = self.cardNOIdTypeArr[row];
            }
        }
            break;
        case 4:
        {
            str1 = self.sexArr[row];
        }
            break;
        case 5:
        {
            str1 = self.nationArr[row][@"nation_name"];
        }
            break;
            
        default:
            
            break;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    [str addAttribute:NSForegroundColorAttributeName
                value:k323232Color
                range:NSMakeRange(0, [str1 length])];
    [str addAttribute:NSFontAttributeName
                value:PFRegularFont(18)
                range:NSMakeRange(0, [str1 length])];
    return str.mutableCopy;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
        {
            _temSelectedItem = self.countryArr[row][@"name"];
            _selectedCountryDic = self.countryArr[row];
            
        }
            break;
        case 1:
            if (_isChina) {
                _temSelectedItem = self.cardTypeArr[row];
            }else{
                _temSelectedItem = self.cardNOIdTypeArr[row];
            }
            break;
        case 4:
            _temSelectedItem = self.sexArr[row];
            break;
        case 5:
        {
            _temSelectedItem = self.nationArr[row][@"nation_name"];
            _selectedNationDic = self.nationArr[row];
        }
            break;
        default:
            break;
    }
}

//图片
-(void)showAlertViewVC:(UITapGestureRecognizer *)tap
{
    _picTag = tap.view.tag;
    
//    _isLeftImgView = tap.view.tag == 100;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:kLocat(@"Dis_TakePhoto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.imagePickerManager requestImagePickerWithCamera:YES controller:self];
    }];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:kLocat(@"EMyAlbum") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.imagePickerManager requestImagePickerWithCamera:NO controller:self];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:takePhotoAction];
    [alertController addAction:picAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)pickerImage:(UIImage *)image
{
    if (_picTag == 100) {
        _leftImg.image = image;
        _hasLeftImg = YES;
    }else if (_picTag == 101){
        _rightImg.image = image;
        _hasRightImg = YES;
    }else{
        _handImg.image = image;
        _hasHandImg = YES;
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (_isChina == NO) {
            if (kScreenW > 375) {
                return 80;
            }else if(kScreenW < 321){
                return 85;
            }else{
                return 85;
            }
        }
    }
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 75/2.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 75/2.0)];
    if (_isChina) {
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 17, kScreenW-24, 15) text:self.titleArray[section] font:PFRegularFont(14) textColor:k222222Color textAlignment:0 adjustsFont:YES];
        [view addSubview:label];
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:kRectMake(12, 17, kScreenW-24, 15) text:self.notChinaTitleArray[section] font:PFRegularFont(14) textColor:k222222Color textAlignment:0 adjustsFont:YES];
        [view addSubview:label];
    }
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && _isChina == NO) {
        
        UIView *view = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 107)];
        
        UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:kRectMake(12, 16, 80, 11) text:[NSString stringWithFormat:@"%@:",kLocat(@"s_v_tips1")] font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        
        [view addSubview:tipLabel1];
        
        CGFloat labelW = kScreenW - 24 - tipLabel1.width;
        
        CGSize size1 = [Utilities calculateWidthAndHeightWithWidth:labelW height:10000 text:kLocat(@"s_v_tips2") font:PFRegularFont(10)].size;
        
        UILabel *rightLabel1 = [[UILabel alloc] initWithFrame:kRectMake(tipLabel1.right, tipLabel1.y-2, size1.width, size1.height) text:kLocat(@"s_v_tips2") font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        rightLabel1.numberOfLines = 0;
        [view addSubview:rightLabel1];
        
        
        UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:kRectMake(12, rightLabel1.bottom+7, 80, 11) text:[NSString stringWithFormat:@"%@:",kLocat(@"s_v_tips3")] font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        
        [view addSubview:tipLabel2];
        
        CGSize size2 = [Utilities calculateWidthAndHeightWithWidth:labelW height:10000 text:kLocat(@"s_v_tips4") font:PFRegularFont(10)].size;

        UILabel *rightLabel2 = [[UILabel alloc] initWithFrame:kRectMake(tipLabel2.right, tipLabel2.y-2, size2.width, size2.height) text:kLocat(@"s_v_tips4") font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        rightLabel2.numberOfLines = 0;
        
        [view addSubview:rightLabel2];
        
        
        
        UILabel *tipLabel3 = [[UILabel alloc] initWithFrame:kRectMake(12, rightLabel2.bottom+7, 80, 11) text:[NSString stringWithFormat:@"%@:",kLocat(@"s_v_tips5")] font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        
        [view addSubview:tipLabel3];
        
        CGSize size3 = [Utilities calculateWidthAndHeightWithWidth:labelW height:10000 text:kLocat(@"s_v_tips6") font:PFRegularFont(10)].size;

        
        UILabel *rightLabel3 = [[UILabel alloc] initWithFrame:kRectMake(tipLabel3.right, tipLabel3.y-2, size3.width, size3.height) text:kLocat(@"s_v_tips6") font:PFRegularFont(10) textColor:kColorFromStr(@"9e9e9e") textAlignment:0 adjustsFont:YES];
        rightLabel3.numberOfLines = 0;
        
        [view addSubview:rightLabel3];

        
        return view;
    }
    
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 58/2;

    if (_isChina) {
        if (indexPath.section == self.titleArray.count - 1) {
            CGFloat w = (kScreenW - 30 - 46)/2.0;
            return w*260/300+10+12 + w*260/300 + 44;
        }

        return 58/2;
    }else{
        if (indexPath.section == self.notChinaTitleArray.count - 1) {
            CGFloat w = (kScreenW - 30 - 46)/2.0;
            return w*260/300+10+12 + w*260/300 + 44;
        }
        return 58/2;
    }
}



-(NSArray *)titleArray
{
    if (_titleArray == nil) {
//        _titleArray = @[@"选择国家和地区",@"证件类型",@"真实姓名",@"证件号码",@"性别",@"民族",@"证件照片(请选择小于2M图片)"];
        _titleArray = @[kLocat(@"s_nationandarea"),kLocat(@"s_cardtype"),kLocat(@"s_realname"),kLocat(@"s_cardnumber"),kLocat(@"s_sex"),kLocat(@"s_nation"),kLocat(@"s_photosize")];
        }
    return _titleArray;
}


-(NSArray *)notChinaTitleArray
{
    if (_notChinaTitleArray == nil) {
//        _notChinaTitleArray = @[@"选择国家和地区",@"证件类型",@"真实姓名",@"证件号码",@"性别",@"证件照片(请选择小于2M图片)"];
        _notChinaTitleArray = @[kLocat(@"s_nationandarea"),kLocat(@"s_cardtype"),kLocat(@"s_realname"),kLocat(@"s_cardnumber"),kLocat(@"s_sex"),kLocat(@"s_photosize")];

    }
    return _notChinaTitleArray;
}

-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]initWithFrame:kScreenBounds];
        [kKeyWindow addSubview:_coverView];
        _coverView.userInteractionEnabled = YES;
        _coverView.hidden = YES;
    }
    return _coverView;
}
-(ImagePickerManager *)imagePickerManager
{
    if (_imagePickerManager == nil) {
        _imagePickerManager = [[ImagePickerManager alloc] init];
        _imagePickerManager.imagePickerMgrDelegate = self;
    }
    return _imagePickerManager;
}


@end
