//
//  XPCommunityMemberViewController.m
//  YJOTC
//
//  Created by l on 2019/1/19.
//  Copyright © 2019年 前海. All rights reserved.
//

#import "XPCommunityMemberViewController.h"
#import "XPSearchHeaderTableViewCell.h"
#import "XPsearchResultTableViewCell.h"
#import "XPSearchSecftionHeaderTableViewCell.h"
#import "XPSearchResultModel.h"
#import "XPBindViewController.h"
#import "XPTipTableViewCell.h"
#import "XPJHRecorderListViewController.h"
#import "XPCommunityLeaderViewController.h"
#import "XPCommunityLeaderModel.h"


@interface XPCommunityMemberViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;
@property (nonatomic,strong)UIView *header;
@property (nonatomic,strong)UILabel *inviteLabel;
@property (nonatomic,strong)UITextField *inviteContent;
@property (nonatomic,strong)UILabel *inviteidLabel;
@property (nonatomic,strong)UITextField *inviteidContent;
@property (nonatomic,strong)UIButton *searchButton;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)XPCommunityLeaderModel *model;
@end

@implementation XPCommunityMemberViewController

- (void)setHeaderView{
    self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 330)];
    self.header.backgroundColor = kColorFromStr(@"#F4F4F4");
    UILabel *topview = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    topview.textAlignment = NSTextAlignmentLeft;
    topview.text = [NSString stringWithFormat:@"    %@",kLocat(@"C_community_jh_search_community_activit")];
    topview.textColor = kColorFromStr(@"#FFFFFF");
    topview.backgroundColor = kColorFromStr(@"#225686");
    [self.header addSubview:topview];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(topview.frame)+10, kScreenW - 26, 260)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.header addSubview:bgview];
    self.inviteLabel = [[UILabel alloc]init];
    self.inviteLabel.text = kLocat(@"C_community_jh_search_community_bind_member_bind");
    self.inviteLabel.textAlignment = NSTextAlignmentLeft;
    self.inviteLabel.textColor = kColorFromStr(@"#222222");
    self.inviteLabel.font = [UIFont systemFontOfSize:16.0f];
    [bgview addSubview:self.inviteLabel];
    [self.inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.inviteContent = [[UITextField alloc]init];
    self.inviteContent.placeholder = kLocat(@"C_community_jh_search_community_bind_member_bind_placehoder");
    self.inviteContent.layer.borderColor = kColorFromStr(@"#999999").CGColor;
    self.inviteContent.layer.borderWidth = 1.0f;
    self.inviteContent.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.inviteContent.leftViewMode = UITextFieldViewModeAlways;
    self.inviteContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.inviteContent setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.inviteContent];
    [self.inviteContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inviteLabel.mas_left);
        make.top.mas_equalTo(self.inviteLabel.mas_bottom).mas_equalTo(4);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    self.inviteidLabel = [[UILabel alloc]init];
    self.inviteidLabel.text = kLocat(@"C_community_jh_search_community_bind_member_bind_id");
    self.inviteidLabel.textAlignment = NSTextAlignmentLeft;
    self.inviteidLabel.textColor = kColorFromStr(@"222222");
    self.inviteidLabel.font = [UIFont systemFontOfSize:16.0f];

    [bgview addSubview:self.inviteidLabel];
    [self.inviteidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.inviteContent.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];

    self.inviteidContent = [[UITextField alloc]init];
    self.inviteidContent.placeholder = kLocat(@"C_community_jh_search_community_bind_member_bind_id_placehder");
    self.inviteidContent.layer.borderColor = kColorFromStr(@"#999999").CGColor;
    self.inviteidContent.layer.borderWidth = 1.0f;
    self.inviteidContent.keyboardType = UIKeyboardTypeNumberPad;
    self.inviteidContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inviteidContent.leftViewMode = UITextFieldViewModeAlways;
    self.inviteidContent.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.inviteidContent.leftViewMode = UITextFieldViewModeAlways;
    [self.inviteidContent setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [bgview addSubview:self.inviteidContent];
    [self.inviteidContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inviteidLabel.mas_left);
        make.top.mas_equalTo(self.inviteidLabel.mas_bottom).mas_equalTo(4);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.backgroundColor = kColorFromStr(@"");
    [self.searchButton setTitle:kLocat(@"C_community_search") forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgview addSubview:self.searchButton];
    [self.searchButton addTarget:self action:@selector(toSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.frame = CGRectMake(10,260-20-45, kScreenW -46, 45);
    self.searchButton.backgroundColor = kColorFromStr(@"#6189C5");
    kViewBorderRadius(bgview, 8, 0, kRedColor);
    [bgview addShadow];
    kViewBorderRadius(self.searchButton, 8, 0, kRedColor);
    [self.searchButton addShadow];
}

- (void)toSearch:(UIButton *)sender{
    [self hideKeyBoard];
    if (self.inviteContent.text.length <= 0) {
        [self showTips:kLocat(@"C_community_jh_search_community_bind_member_bind_placehoder")];
        return;
    }
    if (self.inviteidContent.text.length <= 0) {
        [self showTips:kLocat(@"C_community_jh_search_community_bind_member_bind_id_placehder")];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    param[@"id"] = self.inviteidContent.text;
    param[@"account"] = self.inviteContent.text;
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/BossPlan/searchByIDAndaccount"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        NSLog(@"%@",responseObj);
        
        if (success) {
            NSLog(@"%@",responseObj);
            self.list = [NSMutableArray array];
            [self.list removeAllObjects];
            self.model = [XPCommunityLeaderModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            [self.list addObject:self.model];
            [self.tableview reloadData];
            self.tableview.tableFooterView = nil;
            
            
            
        }else{
            XPTipTableViewCell *footer =  [[[NSBundle mainBundle] loadNibNamed:@"XPTipTableViewCell" owner:self options:nil] lastObject];
            footer.label.text = [responseObj ksObjectForKey:kMessage];
            self.tableview.tableFooterView = footer;
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"C_community_jh_search_community_leader");
    self.view.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.tableview.backgroundColor = kColorFromStr(@"#F4F4F4");
    self.naviHeight.constant = kNavigationBarHeight;
    [self.tableview registerNib:[UINib nibWithNibName:@"XPsearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
    //    self.header =  [[[NSBundle mainBundle] loadNibNamed:@"XPSearchHeaderTableViewCell" owner:self options:nil] lastObject];
    [self setHeaderView];
    self.tableview.tableHeaderView = self.header;
    self.tableview.tableFooterView = nil;
    [self addRightBarButtonItemWithTitle:kLocat(@"C_basic_bouns_juorecor") titleColor:kColorFromStr(@"#E4A646") action:@selector(recorderList)];
}

- (void)recorderList{
    kNavPush([XPJHRecorderListViewController new]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPsearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XPsearchResultTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.model =[self.list objectAtIndex:indexPath.row];
    
//    if (self.model.parent) {
//        [cell refreshWithjijuoModel2:self.model.parent];
//    }else{
//        [cell refreshWithjijuoModel3:self.model.user];
//    }
    if (self.model.user) {
        [cell refreshWithjijuoModel3:self.model.user];
    }
    
    cell.bind = ^{
        NSLog(@"1111111");
            [self bind:self.model.user];
    };
    
    return cell;
}


- (void)bind:(XPCommunityUserModel *)model{

    XPCommunityLeaderViewController *list = [XPCommunityLeaderViewController new];
    list.memberid = model.member_id;
    list.model = self.model;
    kNavPush(list);

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[[NSBundle mainBundle] loadNibNamed:@"XPSearchSecftionHeaderTableViewCell" owner:self options:nil] lastObject];;
    }else{
        return [[[NSBundle mainBundle] loadNibNamed:@"XPSearchSecftionHeaderTableViewCell" owner:self options:nil] lastObject];;
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
        return 35;
    }else{
        return 35;
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