//
//  XPInnovationHomeViewController.m
//  YJOTC
//
//  Created by l on 2019/3/16.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPInnovationHomeViewController.h"
#import "XPInnovationHeaderTableViewCell.h"
#import "XPInnovationTableViewCell.h"
#import "XPInnocationFootViewTableViewCell.h"
#import "THScrollChooseView.h"
#import "XPInnovationRecorderViewController.h"
#import "XPInnovacationExchangeViewController.h"
#import "XPFreezeListViewController.h"
#import "XPInnovationModel.h"
#import "XPExchangeInnocationModel.h"
#import "XPInnovateViewController.h"
#import "XPInternalPurchaseViewController.h"
#import "XPInnovacationGACListViewController.h"
@interface XPInnovationHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)XPInnovationHeaderTableViewCell *header;
@property (nonatomic,strong)XPInnocationFootViewTableViewCell *footer;
@property (nonatomic,strong)XPInnovationModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightN;

@end

@implementation XPInnovationHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"XPInnovationHomeViewController_title");
    self.heightN.constant = kNavigationBarHeight;
    self.header =  [[[NSBundle mainBundle] loadNibNamed:@"XPInnovationHeaderTableViewCell" owner:self options:nil] lastObject];
     [self.header.modifyButton addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
    [self.header.scanButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    self.footer =  [[[NSBundle mainBundle] loadNibNamed:@"XPInnocationFootViewTableViewCell" owner:self options:nil] lastObject];
    [self.tableview registerNib:[UINib nibWithNibName:@"XPInnovationTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPInnovationTableViewCell class])];
     [self.tableview registerNib:[UINib nibWithNibName:@"XPInnovationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    self.tableview.tableHeaderView = self.header;
    self.tableview.tableFooterView = self.footer;
    [self.footer.senderButton addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
     [self.footer.InnerPuButton addTarget:self action:@selector(toInner) forControlEvents:UIControlEventTouchUpInside];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self loadData];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/Exchange/index"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        [self.tableview.mj_header endRefreshing];
        if (success) {
            kLOG(@"操作成功");
            self.model = [XPInnovationModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kResult]];
            [self.header refreshWithModel:self.model];
            
            if ([self.model.is_percent_show isEqualToString:@"0"]) {
                self.header.height = 120;
            } else {
               self.header.height = 175;
            }
            if ([self.model.is_exchange_show isEqualToString:@"0"]) {
                self.footer.senderButton.hidden = YES;
                self.footer.noticeLabel.text = @"";
            }else{
                self.footer.senderButton.hidden = NO;
                self.footer.noticeLabel.text = self.model.lang_notice;
            }
            
            if ([self.model.is_internal_buy_show isEqualToString:@"1"]) {
                self.footer.InnerPuButton.hidden = NO;
                self.footer.height = 172;
            }else{
                self.footer.InnerPuButton.hidden = YES;
                self.footer.height = 95;
            }
            NSLog(@"%@",self.model.allow_percent);
            [self.tableview reloadData];
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
}

- (void)exchange{
    //兑换
    kNavPush([XPInnovacationExchangeViewController new]);
}

- (void)toInner{
    kNavPush([XPInternalPurchaseViewController new]);
}

- (void)modify{
    //更改
    THScrollChooseView * chooswe = [[THScrollChooseView alloc]initWithQuestionArray:self.model.allow_percent withDefaultDesc:[self.model.allow_percent firstObject]];
    [chooswe showView];
    chooswe.confirmBlock = ^(NSInteger selectedValue) {
        //
        NSLog(@"-------------%ld",selectedValue);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *pre = [self.model.allow_percent objectAtIndex:selectedValue];
        param[@"percent"] = pre;
        kShowHud;
        [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"Exchange/set_percent"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
            kHideHud;
            NSLog(@"%@",responseObj);
            if (success) {
                kLOG(@"操作成功");
                self.header.rateLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"XPInnovationHomeViewController_rate"),pre];
                [self.tableview reloadData];
            }else{
                [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
            }
        }];
    };
}

- (void)scan{
    //查看
    XPInnovateViewController *innovication = [XPInnovateViewController new];
    innovication.isInnovate = YES;
    innovication.isList = YES;
    kNavPush(innovication);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.model.is_reward_show isEqualToString:@"0"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            return 1;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"0"]) {
            return 1;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            return 2;
        }else{
            return 0;
        }
    }else{
        if ([self.model.is_internal_buy_show isEqualToString:@"0"]) {
            return 0;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([self.model.is_reward_show isEqualToString:@"0"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            XPInnovationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPInnovationTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel:self.model];
            return cell;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"0"]) {
            XPInnovationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel1:self.model];
            return cell;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            if (indexPath.row == 1) {
                XPInnovationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell refreshWithModel1:self.model];
                return cell;
            }else{
                XPInnovationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPInnovationTableViewCell class])];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell refreshWithModel:self.model];
                return cell;
            }
        }else{
            return nil;
        }
    }else{
        if ([self.model.is_internal_buy_show isEqualToString:@"0"]) {
            return  nil;
        }else{
            XPInnovationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPInnovationTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel2:self.model];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        XPFreezeListViewController  *freezen  = [XPFreezeListViewController new];
        
        if ([self.model.is_reward_show isEqualToString:@"0"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            freezen.isfree = NO;
            freezen.subject = self.model.gac_exchange_name;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"0"]) {
            freezen.subject = self.model.gac_reward_name;
            freezen.isfree = YES;
        }else if ([self.model.is_reward_show isEqualToString:@"1"] && [self.model.is_exchange_show isEqualToString:@"1"]) {
            if (indexPath.row == 0) {
                freezen.isfree = NO;
                freezen.subject = self.model.gac_exchange_name;
            }else{
                freezen.subject = self.model.gac_reward_name;
                freezen.isfree = YES;
            }
        }else{
            
        }
        kNavPush(freezen);
    }else{
        XPFreezeListViewController *list = [XPFreezeListViewController new];
        list.isinner = YES;
        kNavPush(list);
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0.01;
    }else{
        return 0.01;
    }
}

@end
