//
//  XPJHListViewController.m
//  YJOTC
//
//  Created by l on 2018/12/27.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPJHListViewController.h"
#import "XPCommunityZTCollectionViewCell.h"
#import "XPCollectionHeaderReusableView.h"
#import "XPCommunityDetailHeaderTableViewCell.h"
#import "XPGetValiList.h"
#import "EmptyManager.h"
#import "XPGetValiModel.h"
#import "XPJHHeaderTableViewCell.h"
#import "XPCashierViewController.h"
@interface XPJHListViewController ()<ApiRequestDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,strong)XPJHHeaderTableViewCell *header;
@property (nonatomic,strong)XPGetValiList *api;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)XPGetValiModel *model;

@end

@implementation XPJHListViewController

- (NSMutableArray *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocat(@"C_community_search_detai03_nav");
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"XPJHHeaderTableViewCell" owner:self options:nil] lastObject];
    self.header.frame = CGRectMake(0, kNavigationBarHeight, kScreenW, 190);
    [self.view addSubview:self.header];
    [self.collectionview registerNib:[UINib nibWithNibName:@"XPCommunityZTCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XPCommunityZTCollectionViewCell class])];
     [self.collectionview registerClass:[XPCollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XPCollectionHeaderReusableView class])];
    self.collectionview.backgroundColor = kTableColor;
    __weak typeof(self) wself = self;

    self.api  = [[XPGetValiList alloc]initWithKey:kUserInfo.token token_id:[NSString stringWithFormat:@"%ld",(long)kUserInfo.uid]];
    self.api.delegate = self;
    self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(wself) sself = wself;
        [sself.api refresh];
    }];
    
//    self.collectionview.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        __strong typeof(wself) sself = wself;
//        [sself.api loadNextPage];
//    }];
    [self.collectionview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -- dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.model.list.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    outterModel *model = [self.model.list objectAtIndex:section];
    return model.child.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XPCommunityZTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XPCommunityZTCollectionViewCell class]) forIndexPath:indexPath];
    outterModel *model = [self.model.list objectAtIndex:indexPath.section];
    innerModel *model1 = [model.child objectAtIndex:indexPath.row];
    [cell refreshWithModel:model1];
    cell.votes = ^{
        if ([model1.status isEqualToString:@"1"]) {
            XPCashierViewController *casher = [XPCashierViewController new];
            casher.member_id = self.memberid;
            casher.step_list_id = model1.step_list_id;
            kNavPush(casher);
        }
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    XPCollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XPCollectionHeaderReusableView class]) forIndexPath:indexPath];
    outterModel *model = [self.model.list objectAtIndex:indexPath.section];
    [headerView refreshWithModel:model];
    return headerView;
}

//header高度

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenW, 40);
}

//item大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenW - 30)/2, 106);
}

//调节item边距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark -- item点击跳转

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    //    [self showTips:command.response.msg];
    [self.collectionview.mj_footer resetNoMoreData];
    [self.collectionview.mj_header endRefreshing];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.view];
    self.model = responsObject;
    [self.header refreshWithModel:self.model];
    [self.collectionview reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    
    [self.collectionview.mj_footer resetNoMoreData];
    [self.collectionview.mj_header endRefreshing];

}


- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self showTips:command.response.msg];
    [self.collectionview.mj_footer endRefreshing];
//    MineModel *model = responsObject;
//    NSArray *arr = [mlistModel mj_objectArrayWithKeyValuesArray:model.list];
//    [self.list addObjectsFromArray:arr];
//    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.collectionview.mj_footer endRefreshing];
    [self showTips:command.response.msg];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
//    [self.view hideToastActivity];
    //    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}





@end
