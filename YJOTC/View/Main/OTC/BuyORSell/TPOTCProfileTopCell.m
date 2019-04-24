//
//  TPOTCProfileTopCell.m
//  HuaBi
//
//  Created by 周勇 on 2018/11/1.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPOTCProfileTopCell.h"

@interface TPOTCProfileTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *email;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *iden;


@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;




@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sum;

@property (weak, nonatomic) IBOutlet UILabel *applealLabel;
@property (weak, nonatomic) IBOutlet UILabel *appleal;
@property (weak, nonatomic) IBOutlet UILabel *thirtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirty;

@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UILabel *success;

@property (weak, nonatomic) IBOutlet UILabel *finishLAbel;
@property (weak, nonatomic) IBOutlet UILabel *finish;
@property (weak, nonatomic) IBOutlet UILabel *releaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *release1;


@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UIImageView *idenImg;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImg;



@end


@implementation TPOTCProfileTopCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    _nameLabel.text = dataDic[@"name"];
    if ([dataDic[@"name"] length] == 0) {
        _name.text = @"";
    }else{
        _name.text = [dataDic[@"name"] substringWithRange:NSMakeRange(0, 1)];
    }
    
    _registerTimeLabel.text = [NSString stringWithFormat:@"%@ %@",kLocat(@"OTC_pro_registertime"),dataDic[@"reg_time"]];
    
    _sum.text = kLocat(@"OTC_pro_sum");
    _sumLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"total_order"],kLocat(@"OTC_pro_time")];
    
    _thirty.text = kLocat(@"OTC_pro_30");
    _thirtyLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"total_order_30"],kLocat(@"OTC_pro_time")];

    _finish.text = kLocat(@"OTC_profile_finishrate");
    _finishLAbel.text = [NSString stringWithFormat:@"%@%%",dataDic[@"evaluate_num"]];
    
    _appleal.text = kLocat(@"OTC_appleal");
    _applealLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"appeal_allnum"],kLocat(@"OTC_pro_time")];
    
    _appleal.text = kLocat(@"OTC_appleal");
    _applealLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"appeal_allnum"],kLocat(@"OTC_pro_time")];
    
    
    _success.text = kLocat(@"OTC_pro_success");
    _successLabel.text = [NSString stringWithFormat:@"%@%@",dataDic[@"appeal_succnum"],kLocat(@"OTC_pro_time")];
    
    _release1.text = kLocat(@"OTC_pro_avati");
    _releaseLabel.text = [NSString stringWithFormat:@"%@ %@",dataDic[@"fang_time"],kLocat(@"OTC_pro_minute")];
    
    _email.text = kLocat(@"s0115_mailauth");
    _phone.text = kLocat(@"s0115_phoneauth");
    _iden.text = kLocat(@"s0115_idauth");

    /**  "s0115_mailauth" = "Email certified";
     "s0115_phoneauth" = "PhoneCertified";
     "s0115_idauth" = "Authentication";
     */
    
    
    if ([dataDic[@"email"] intValue] == 0) {
        _emailImg.image = kImageFromStr(@"user_icon_wxuanzhong");
    }else{
        _emailImg.image = kImageFromStr(@"user_icon_xuanzhong");
    }
    
    if ([dataDic[@"phone"] intValue] == 0) {
        _phoneImg.image = kImageFromStr(@"user_icon_wxuanzhong");
    }else{
        _phoneImg.image = kImageFromStr(@"user_icon_xuanzhong");
    }
    
    if ([dataDic[@"idcard"] intValue] == 0) {
        _idenImg.image = kImageFromStr(@"user_icon_wxuanzhong");
    }else{
        _idenImg.image = kImageFromStr(@"user_icon_xuanzhong");
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
    _line1.backgroundColor = kCCCCCCColor;
    _line2.backgroundColor = _line1.backgroundColor;

    _name.textColor = kWhiteColor;
    _name.font = PFRegularFont(14);
    
    _nameLabel.textColor = k222222Color;
    _nameLabel.font = PFRegularFont(16);
    
    _registerTimeLabel.textColor = k666666Color;
    _registerTimeLabel.font = PFRegularFont(12);
    
    
    
    _sum.textColor = k666666Color;
    _sum.font = PFRegularFont(12);
    _sumLabel.textColor = kColorFromStr(@"#666666");
    _sumLabel.font = PFRegularFont(12);
    
    _thirty.textColor = kColorFromStr(@"#666666");
    _thirty.font = PFRegularFont(12);
    _thirtyLabel.textColor = kColorFromStr(@"#666666");
    _thirtyLabel.font = PFRegularFont(12);
    
    _finish.textColor = kColorFromStr(@"#666666");
    _finish.font = PFRegularFont(12);
    _finishLAbel.textColor = kColorFromStr(@"#666666");
    _finishLAbel.font = PFRegularFont(12);
    
    _appleal.textColor = kColorFromStr(@"#666666");
    _appleal.font = PFRegularFont(12);
    _applealLabel.textColor = kColorFromStr(@"#666666");
    _applealLabel.font = PFRegularFont(12);
    
    _success.textColor = kColorFromStr(@"#666666");
    _success.font = PFRegularFont(12);
    _successLabel.textColor = kColorFromStr(@"#666666");
    _successLabel.font = PFRegularFont(12);
    
    _release1.textColor = kColorFromStr(@"#666666");
    _release1.font = PFRegularFont(12);
    _releaseLabel.textColor = kColorFromStr(@"#666666");
    _releaseLabel.font = PFRegularFont(12);
    
    _email.textColor = kColorFromStr(@"#666666");
    _phone.textColor = kColorFromStr(@"#666666");
    _iden.textColor = kColorFromStr(@"#666666");
    _email.font = PFRegularFont(12);
    _phone.font = PFRegularFont(12);
    _iden.font = PFRegularFont(12);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
