//
//  XPAssetBangManageController.m
//  YJOTC
//
//  Created by Roy on 2018/12/20.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAssetBangManageController.h"
#import "XPAssetBankCommonCell.h"
#import "XPAssetBankTopCell.h"
//#import "WBPopOverView.h"
//#import "LXCalender.h"
#import "XPAssetBankProgressCell.h"
#import "XPAssetBankInController.h"
#import "XPAssetViewController.h"
#import "TPWalletSendListController.h"
#import "XPAssetBankListController.h"


@interface XPAssetBangManageController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UILabel *timeLabel;

//@property(nonatomic,strong)LXCalendarView *calenderView;


@end

@implementation XPAssetBangManageController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.enablePanGesture = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (_model) {
        [self.tableView reloadData];
    }
    
}
-(void)setupUI
{
    self.title = kLocat(@"z_AssetManage");
    _tableView = [[UITableView alloc]initWithFrame:kRectMake(0,kNavigationBarHeight, kScreenW, kScreenH-kNavigationBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //取消多余的小灰线
    _tableView.tableFooterView = [UIView new];
    
    _tableView.backgroundColor = kTableColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankCommonCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankCommonCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankTopCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankTopCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"XPAssetBankProgressCell" bundle:nil] forCellReuseIdentifier:@"XPAssetBankProgressCell"];
    UIView *footView = [[UIView alloc] initWithFrame:kRectMake(0, 0, kScreenW, 36+45+20)];
    _tableView.tableFooterView = footView;
    footView.backgroundColor = kTableColor;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:kRectMake(12, 36, kScreenW - 24, 45) title:kLocat(@"z_zhuanru") titleColor:kWhiteColor font:PFRegularFont(16) titleAlignment:0];
    [footView addSubview:button];
    kViewBorderRadius(button, 8, 0, kRedColor);
    [button addShadow];
    button.backgroundColor = kColorFromStr(@"#6189C5");
    [button addTarget:self action:@selector(zhuangRuAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *rid = @"XPAssetBankTopCell";
        XPAssetBankTopCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        cell.model = _model;
        return cell;
    }else if(indexPath.section != 4){
        static NSString *rid = @"XPAssetBankCommonCell";
        XPAssetBankCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        if (indexPath.section == 1) {
            cell.itemLabel.text = kLocat(@"z_shengxicurrency");
            cell.infoLabel.text = _model.currency_mark;
            
        }else if (indexPath.section == 2) {
            _timeLabel = cell.infoLabel;
            cell.infoLabel.text = [Utilities returnTimeWithSecond:_model.add_time.longLongValue formatter:@"yyyy/MM/dd"];

            cell.itemLabel.text = kLocat(@"z_addtime");
        }else if (indexPath.section == 3){

            cell.itemLabel.text = kLocat(@"z_endtime");
            
            cell.infoLabel.text = [Utilities returnTimeWithSecond:[self getEndTimeInterval] formatter:@"yyyy/MM/dd"];
            
            
        }else if (indexPath.section == 5){
            
            cell.itemLabel.text = kLocat(@"z_productfeature");
//            cell.infoLabel.text = @"量化自動交易、風險低";
            cell.infoLabel.text = _model.characteristic;
            
        }else{
            
            cell.infoLabel.text = @"";
            cell.itemLabel.text = kLocat(@"z_productdetail");

        }

        if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 6) {
            cell.showArrow = YES;
        }else{
            cell.showArrow = NO;
        }
        
        return cell;
    }else{
        static NSString *rid = @"XPAssetBankProgressCell";
        XPAssetBankProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:rid owner:self options:nil] lastObject];
        }
        
        cell.addtimeLabel.text = [Utilities returnTimeWithSecond:_model.add_time.longLongValue formatter:@"yyyy-MM-dd"];
        cell.managerLabel.text = [NSString stringWithFormat:@"%@-%@",[Utilities returnTimeWithSecond:_model.add_time.longLongValue formatter:@"MM/dd"],[Utilities returnTimeWithSecond:[self getEndTimeInterval] formatter:@"MM/dd"]];
        cell.endtimeLabel.text = [NSString stringWithFormat:@"%@ 23:59%@",[Utilities returnTimeWithSecond:[self getEndTimeInterval] formatter:@"MM/dd"],kLocat(@"z_ago")];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof(self)weakSelf = self;

    if (indexPath.section == 1) {
        
        TPWalletSendListController *vc = [TPWalletSendListController new];
        vc.isAssetBank = YES;
        vc.model = _model;
        vc.callBackBlcok = ^(XPAssetBankModel *model) {
            weakSelf.model = model;
            kLOG(@"====當前xid==%@",model.xid);
        };
        kNavPush(vc);
    }else if (indexPath.section == 3){
        XPAssetBankListController *vc = [XPAssetBankListController new];
        vc.currencyID = _model.currency_id;
        vc.reChooseDate = YES;
        vc.callBackBlcok = ^(XPAssetBankModel *model) {
            weakSelf.model = model;
            kLOG(@"====當前xid==%@",model.xid);

        };
        kNavPush(vc);
    }else if (indexPath.section == 6){
        if (_model.details.length < 1) {
            return;
        }

        BaseWebViewController *vc = [BaseWebViewController webViewControllerWithURIString:[NSString stringWithFormat:@"/mobile/news/detail/id/%@", _model.details] title:nil];
            vc.showNaviBar = NO;
            kNavPush(vc);
    }
    
    
    
    
    
//    if (indexPath.section == 1) {
//
//        //获取cell相对于tableView的frame
//        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//        //获取相对于self.view的frame
//        CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
//
//        CGPoint point = CGPointMake(kScreenW - 30, rect.origin.y + 25);
////        CGPoint point=CGPointMake(_button.frame.origin.x+_button.frame.size.width/2, _button.frame.origin.y+_button.frame.size.height);//箭头点的位置
//        WBPopOverView *view=[[WBPopOverView alloc]initWithOrigin:point Width:280 Height:245 Direction:WBArrowDirectionUp2];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
//
//
//        self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(0, 0, 280, 245)];
//
//        self.calenderView.currentMonthTitleColor =[UIColor colorFromStr:@"2c2c2c"];
//        self.calenderView.lastMonthTitleColor =[UIColor colorFromStr:@"8a8a8a"];
//        self.calenderView.nextMonthTitleColor =[UIColor colorFromStr:@"8a8a8a"];
//
//        self.calenderView.isHaveAnimation = YES;
//
//        self.calenderView.isCanScroll = YES;
//
//        self.calenderView.isShowLastAndNextBtn = YES;
//
//        self.calenderView.isShowLastAndNextDate = YES;
//
//        self.calenderView.todayTitleColor =kColorFromStr(@"#066B98");
//
//        self.calenderView.selectBackColor =[UIColor blueColor];
//
//        self.calenderView.backgroundColor =[UIColor whiteColor];
//
//
//        [self.calenderView dealData];
//
//        [view.backView addSubview:self.calenderView];
//
//
//        self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
//            NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
//            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%zd/%zd/%zd",year,month,day];
//            [view dismiss];
//        };
//        [view popView];
//    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 3){
        return 60;
    }else{
        return 44 + 15;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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

-(NSTimeInterval)getEndTimeInterval
{
    return  _model.add_time.longLongValue + _model.months.integerValue *30*24 *3600;
}


#pragma mark - 点击事件

-(void)zhuangRuAction
{
    XPAssetBankInController *vc = [XPAssetBankInController new];
    vc.model = _model;
    kNavPush(vc);

}

-(void)backAction
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[XPAssetViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
