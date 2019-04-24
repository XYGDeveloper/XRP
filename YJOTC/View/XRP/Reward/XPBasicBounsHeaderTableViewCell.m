//
//  XPBasicBounsHeaderTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/26.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPBasicBounsHeaderTableViewCell.h"
#import "XPBoundHeadModel.h"
#import "MQGradientProgressView.h"

@interface XPBasicBounsHeaderTableViewCell()
@property (nonatomic,strong)MQGradientProgressView *progressView;
@property (nonatomic,strong)MQGradientProgressView *progressView01;

@end

@implementation XPBasicBounsHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.optionButton.layer.cornerRadius = 32/2;
    self.optionButton.layer.masksToBounds = YES;
    self.progressView = [[MQGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, 20)];
    self.progressView.bgProgressColor = kColorFromStr(@"#5DDFD1");
    //    progressView.colorArr = @[(id)MQRGBColor(59, 221, 255).CGColor,(id)MQRGBColor(34, 126, 239).CGColor];
    [self.progroess01 addSubview:self.progressView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshWithModel:(XPBoundHeadModel *)model  type:(NSString *)type{
    self.totalRenueLabel.text  =kLocat(@"C_community_reward_manager_totalrenun");
    self.todayRenueLabel.text = kLocat(@"C_community_reward_manager_todayrenun");
    NSString *_test  = model.text;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;
    paraStyle01.headIndent = 0.0f;
    paraStyle01.tailIndent = 0.0f;
    paraStyle01.lineSpacing = 10.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    self.deaLabel.attributedText = attrText;
    if ([type isEqualToString:@"1"]) {
        self.currentRenueContent.text = [NSString stringWithFormat:@"%@‰",model.profit_rate];
        self.currentRenueLabel.text = kLocat(@"C_community_bouns_basiccurrenti");
        if ([model.bar_type isEqualToString:@"1"]) {
            self.progroessDesLabel.text = kLocat(@"C_community_bouns_basicshouyi");
            NSLog(@"[[[[[[[[[[%d",model.base_bar1.intValue/model.base_bar2.intValue);
            if (model.base_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.base_bar1.floatValue/model.base_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_optioned"),model.base_bar1];
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.base_bar2];
        }else{
            self.progroessDesLabel.text = kLocat(@"C_community_bouns_basics_static_houyi");
            if (model.move_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.move_bar1.floatValue/model.move_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_basics_homic_houyi"),model.move_bar1];
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.move_bar2];
        }
    }else if ([type isEqualToString:@"2"]){
        self.currentRenueContent.text = [NSString stringWithFormat:@"%@‰",model.profit_rate];
        self.currentRenueLabel.text = kLocat(@"C_community_bouns_basiccurrenti");
        if ([model.bar_type isEqualToString:@"1"]) {
            if (model.base_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.base_bar1.floatValue/model.base_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_optioned"),model.base_bar1];
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.base_bar2];
        }else{
            self.progroessDesLabel.text = kLocat(@"C_community_bouns_basics_static_houyi");
            if (model.move_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.move_bar1.floatValue/model.move_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_opti"),model.move_bar1];
            ;
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.move_bar2];
        }
    }else{
        if ([type isEqualToString:@"4"]) {
            self.currentRenueContent.hidden = YES;
            self.currentRenueLabel.hidden = YES;
        }else{
            self.currentRenueContent.text = [NSString stringWithFormat:@"%@",model.child_num];
            self.currentRenueLabel.text = kLocat(@"C_community_bouns_yestedayshouyi");
        }

        if ([model.bar_type isEqualToString:@"1"]) {
            if (model.base_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.base_bar1.floatValue/model.base_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_optioned"),model.base_bar1];
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.base_bar2];
        }else{
            self.progroessDesLabel.text = kLocat(@"C_community_bouns_basics_static_houyi");
            if (model.move_bar2.floatValue == 0) {
                self.progressView.progress = 0;
            }else{
                self.progressView.progress = model.move_bar1.floatValue/model.move_bar2.floatValue;
            }
            self.leftLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_opti"),model.move_bar1];
            ;
            self.rightLabel.text = [NSString stringWithFormat:@"%@:%@XRP",kLocat(@"C_community_bouns_static_sumoptioned"),model.move_bar2];
        }
    }
    [self.zengtouButton setTitle:kLocat(@"C_community_bouns_zengtou") forState:UIControlStateNormal];
    self.totalRenueContent.text = model.count_profit;
    self.todayRenueContent.text = model.today_profit;
    if ([model.color_type isEqualToString:@"1"]) {
        [self.optionButton setTitle:model.button forState:UIControlStateNormal];
        self.optionButton.backgroundColor  = kColorFromStr(@"#E4A646");
        self.optionButton.userInteractionEnabled = YES;
    }else{
        [self.optionButton setTitle:model.button forState:UIControlStateNormal];
        self.optionButton.backgroundColor  = kColorFromStr(@"#AFBBBF");
        self.optionButton.userInteractionEnabled = NO;
    }
}




@end
