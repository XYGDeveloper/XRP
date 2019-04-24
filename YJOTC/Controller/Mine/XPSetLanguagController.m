//
//  XPSetLanguagController.m
//  YJOTC
//
//  Created by Roy on 2018/12/19.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPSetLanguagController.h"
#import "XPSetLanguageCell.h"


@interface XPSetLanguagController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation XPSetLanguagController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

-(void)setupUI
{
    
    self.title = kLocat(@"x_MineLang");
    
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"XPSetLanguageCell" bundle:nil] forCellReuseIdentifier:@"XPSetLanguageCell"];
    _tableView.backgroundColor = kTableColor;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rid = @"XPSetLanguageCell";
    XPSetLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
    }
    NSString *currenLan = [LocalizableLanguageManager userLanguage];
    
    kLOG(@"當前語言%@",currenLan);
    if (indexPath.section == 0) {
        cell.currentLabel.text = @"English";
        cell.descLabel.text = @"English";
        cell.icon.hidden = ![currenLan containsString:@"en"];

    }else{
        cell.currentLabel.text = @"繁体中文";
        cell.descLabel.text = @"繁体中文";
        cell.icon.hidden = [currenLan containsString:@"en"];

    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currenLan = [LocalizableLanguageManager userLanguage];

    if (![currenLan containsString:@"en"]) {
        
        if (indexPath.section == 0) {
 
            [self showTips:kLocat(@"k_popview_select_paywechat_edit_scuess")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                [kUserDefaults setBool:NO forKey:@"isTradition"];
                [LocalizableLanguageManager setUserlanguage:ENGLISH];
            });
        }
    }else{
        if (indexPath.section == 1) {
            [self showTips:kLocat(@"k_popview_select_paywechat_edit_scuess")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [kUserDefaults setBool:YES forKey:@"isTradition"];
                [LocalizableLanguageManager setUserlanguage:CHINESETradition];
            });
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 + 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 2.5;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


@end
