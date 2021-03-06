//
//  YJBaseViewController.h
//  YJOTC
//
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJBaseViewController : UIViewController


@property (nonatomic, assign) BOOL enablePanGesture;//是否支持拖动pop手势，默认yes,支持手势

//无导航条时候的返回按钮
@property(nonatomic,strong)UIButton *backBtn;
//无导航条时候的标题
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSString *titleWithNoNavgationBar;

-(void)initBackButton;

//返回事件
-(void)backAction;

-(void)gotoLoginVC;

-(void)gotoRegisterVC;

-(void)userDidLogin;

-(void)userDidlogout;
/**  修改状态栏颜色  */
-(void)setStatusBarColor:(UIColor *)color;

-(void)changeStatusBarColorWithWhite:(BOOL)isWhite;

-(void)showTips:(NSString *)msg;

-(void)hideKeyBoard;

-(void)hideBackButton;


@end
