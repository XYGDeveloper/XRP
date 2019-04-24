//
//  RequestPath.h
//  jys
//
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#ifndef RequestPath_h
#define RequestPath_h

//测试环境      
#define kBasePath @"http://test.xrpplus.net"

//正式环境
//#define kBasePath @"https://www.xrpplus.net"

//全局权限keyCode
#define kKeyCode @"G0S57a7aADHWIhx0Beluj2chZENHVCd6R8Vn9MeqetVsLLkr9jvdk"

#pragma mark - 登录注册
//发送手机验证码
#define kSenderSMS @"/Sms/code"
//发送邮箱验证码
#define kSendEmail @"/Email/code"

//注册
#define kUserRegister @"/users/regformobile"
//登录
#define kUserLogin @"/users/loginformobile"
//发送邮箱验证码
#define KSenderEmail @"/api/account/sendemail"
//找回密码
#define kfindPassword @"mb_index/forgetpwd"
//退出登录
#define kLoginOut @"/api/account/logout"
//修改登录密码
#define kModifyLoginPwd @"district/update_loginpdw"
//修改交易密码
#define kModifyDealPwd @"district/update_paypdw"
//邮箱绑定
#define kBoundEmal @"/api/SetUp/upd_email"
//手势密码验证
#define kGesturePwdCheck @"/api/SetUp/chk_login_pwd"

//app注册教程
#define kAppRegisterLink @"/api/about/app_reg" 

//服务条款
#define kAppServiceRule @"/api/about/app_agree"


//扫一扫
#define kScanForLogin @"mb_index/scanlogin"


//自动登录
#define kAutoLogin @"/api/account/auto_login"
//总资产
#define kProperty @"/api/AccountManage/account_all"




#pragma mark - 首页
//banner
#define kMainBanner @"/mobile/index.php?act=mb_index&op=banner"
//新闻
#define kMainNews @"/mobile/index.php?act=mb_index&op=news"
//首页7图
#define kMain7Pic @"/mobile/index.php?act=mb_index&op=imagespecial"
//首页上面列表
#define kMainGoodList @"mb_index/goodslist"
//首页搜索返回链接
#define kMainSearchUrl @"mb_index/search"

//首页专区
#define kMainSpecial @"mb_index/specialblock"
//热门市场  多图
#define kHotMarket @"mb_index/hotmarket"
//分类10个链接
#define kMain10Links @"mb_index/classlinks"

//分类链接
#define kMainCategory @"mb_index/shopclass"


//地址
//地址列表
#define kAddressList @"mb_member_address/address_list"
//编辑地址
#define kEditAddress @"mb_member_address/address_edit"
//添加地址
#define kAddAddress @"mb_member_address/address_add"
//删除地址
#define kDeleteAddress @"mb_member_address/address_del"
//设为默认地址
#define kSetDefaulAddress @"mb_member_address/is_default"



//邀请奖励列表
#define kGetAwardList @"/api/AccountManage/award_list"
//获取邀请url及邀请规则
#define kGetInviteUrl  @"/api/AccountManage/invite_rule"
//获取邀请二维码
#define kGetQRView @"/api/AccountManage/qrcode"
//获取邀请人列表
#define kGetInviteList @"/api/AccountManage/invite_list"
//发送邀请email
#define kSenderInviteEmail @"/api/AccountManage/do_invite"




#define kInviteUrl @"/mobile/invite/index"







//分类ID取列表
#define kArtIndex @"/api/art/index"
//文章详情
#define kArtDetail @"/api/art/details"
//文章搜索
#define kArtSearch @"/api/art/search"




//帮助中心
#define kHelpList @"/api/SetUp/help"
//根据文章id获取帮助详情
#define kHeplDetail @"/api/SetUp/get_article"


#pragma mark - 商圈

//发布动态
#define kDistrictPublish @"district/publish"
//获取动态列表
#define kGetDistrictList @"/Api/district/read"

//获取粉丝//关注列表
#define kGetFollows @"district/get_member_follow"
//获取用户资料
#define kGetCircleInfo @"District/members"
//修改用户头像
#define kChangeAvatar @"district/update_headpic"
//关注/取消关注
#define kFollowAction @"district/follows"

//点赞操作
#define kLikeAction @"district/to_like"

#define kCommentList @"district/comment_get"

//评论操作
#define kCommentAction @"district/comment_push"
//删除动态
#define kDeleteDistrict @"district/district_remove"

//搜索动态
#define kSearchDistrict @"district/search"


#pragma mark - 环信
/**  搜索好友  */
#define kSearchUser @"district/searchUser"
//环信好友列表
#define kEMFriendList @"district/friendList"
//添加好友申请
#define kEMAddFriendRequest @"district/friendApplicationAdd"
//好友申请列表
#define kEMFriendRequestList @"district/friendApplicationList"
//同意添加好友
#define kEMAcceptFriendRequest @"district/applicationStatus"
//删除好友申请记录
#define kEMDeleteFrinedRequest @"district/delFriend"

//群列表
#define kEMGroupList @"district/HuanxinGroupList"
//删除群
#define kDeleteEMGroup @"district/HuanxinGroupDel"
//创建群
#define kCreateEMGroup @"district/addHuanxinGroup"
//修改群头像
#define kUpdateEMGroupAvatar @"district/update_huanxin_headpic"
//群成员列表
#define kEMGroupMemberList @"district/getGroupMember"



//获取标签
#define kGetTabs @"/api/AccountManage/get_tabs"
//获取行业
#define kGetProfession @"/api/AccountManage/get_profession"


//获取用户信息
#define kGetUserInfo @"district/memberinfo"


//修改个人资料
#define kUpdataProfile @"district/update_member_info"
//获取卖家信息
#define kGetSellerInfo @"mb_index/getSellerInfo"

//获取商家推荐商品列表
#define kGetRecommendGoodsList @"district/recommendgoods"


//删除评论
#define kDeleteComment @"district/district_comment_remove"

//获取国家
#define kCountrylist @"/Api/Account/countrylist"
//注册
#define kUserRegisterPhone @"/Api/Account/phoneAddReg"
#define kUserRegisterEmail @"/Api/Account/emailAddReg"

//获取群组列表
#define kGetGroup @"/district/group"
//商圈城市列表
#define kGetGroupCityList @"district/citylist"
//获取商圈信息
#define kGetGroupInfo @"district/group"

//发现列表
#define kDiscoverArticleList @"mb_index/getFindArticle"


//关注列表
#define kAttentionList @"District/followlist"

//反馈
#define kFeedBack @"district/feedback_add"




#endif /* RequestPath_h */
