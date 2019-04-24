//
//  XPAboutXRPViewController.m
//  YJOTC
//
//  Created by l on 2018/12/29.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPAboutXRPViewController.h"
#import "XPAboutModel.h"
#import "MQGradientProgressView.h"

@interface XPAboutXRPViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;

@property (weak, nonatomic) IBOutlet UILabel *wLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *progroessLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonatomic,strong)MQGradientProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *bgview;

@end

@implementation XPAboutXRPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = kLocat(@"C_community_bouns_static_sum_about");
    self.naviHeight.constant = kNavigationBarHeight;
    self.bgview.y = kNavigationBarHeight;
    self.progressView = [[MQGradientProgressView alloc] init];
    [self.bgview addSubview:self.progressView];
    self.progressView.bgProgressColor = kColorFromStr(@"#5DDFD1");
    //    progressView.colorArr = @[(id)MQRGBColor(59, 221, 255).CGColor,(id)MQRGBColor(34, 126, 239).CGColor];
//    [self.progroessLabel addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(26);
    }];
    self.progressView.layer.cornerRadius = 13;
    self.progressView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"key"] = kUserInfo.token;
    param[@"token_id"] = @(kUserInfo.uid);
    NSLog(@"%@",param);
    kShowHud;
    [kNetwork_Tool POST_HTTPS:[Utilities handleAPIWith:@"/AwardRelease/info"] andParam:param completeBlock:^(BOOL success, NSDictionary *responseObj, NSError *error) {
        kHideHud;
        if (success) {
            NSLog(@"%@",responseObj);
            XPAboutModel *model = [XPAboutModel mj_objectWithKeyValues:[responseObj ksObjectForKey:kData]];
            self.wLabel.text = kLocat(@"C_community_bouns_empty_status");
            self.mainLabel.text = model.title;
            NSString *_test  = model.desc;
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.alignment = NSTextAlignmentLeft;
            paraStyle01.headIndent = 0.0f;
            //    CGFloat emptylen = self.deaLabel.font.pointSize * 1;
            //    paraStyle01.firstLineHeadIndent = emptylen;
            paraStyle01.tailIndent = 0.0f;
            paraStyle01.lineSpacing = 10.0f;
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
            self.contentLabel.attributedText = attrText;
            self.rightLabel.text = [NSString stringWithFormat:@"%@%@", [responseObj ksObjectForKey:kData][@"btc"],[responseObj ksObjectForKey:kData][@"currency_name"]];
            if (model.xrp_btc.doubleValue/model.btc.doubleValue >=1.0) {
                self.typeLabel.text = kLocat(@"C_community_bouns_empty_fenqi");
                self.progressView.progress = 1.0f;
                self.leftLabel.text = [NSString stringWithFormat:@"%@%@",model.xrp_btc,model.currency_name];
            }else{
                self.typeLabel.text = kLocat(@"C_community_bouns_empty_lishi");
                self.leftLabel.text = [NSString stringWithFormat:@"%@%@",model.xrp_btc,model.currency_name];
                [self.progressView setBackgroundColor:kColorFromStr(@"#5DDFD1")];
                self.progressView.progress = model.xrp_btc.doubleValue/model.btc.doubleValue;
            }
        }else{
            [kKeyWindow showWarning:[responseObj ksObjectForKey:kMessage]];
        }
    }];
    
}

@end
