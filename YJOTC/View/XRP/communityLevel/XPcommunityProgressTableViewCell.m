//
//  XPcommunityProgressTableViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPcommunityProgressTableViewCell.h"

@implementation XPcommunityProgressTableViewCell

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    _desLabel.text = dataDic[@"title_level"];
    _preLevelLabel.text = dataDic[@"stat_level"];
    _nextLevelLabel.text = dataDic[@"end_level"];

    _preLabelCount.text = ConvertToString(dataDic[@"stat_recommend"]);
    _nextLabelCount.text = ConvertToString(dataDic[@"end_recommend"]);

    _proW.constant = [dataDic[@"stat_recommend"] doubleValue]/[dataDic[@"end_recommend"] doubleValue] * (kScreenW - 26 - 16);
    
    /**
     "end_level" = LV2;
     "end_recommend" = 2;
     "stat_level" = LV1;
     "stat_recommend" = 0;
     "title_level" = "\U5340\U584a\U793e\U5340\U6578:(\U9700\U8fbe\U5230LV1)";
     */
 
}

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    // Initialization code
    
    
    kViewBorderRadius(_currentView, 10, 0, kRedColor);
    kViewBorderRadius(_progroessLabel, 10, 0, kRedColor);

    _currentView.backgroundColor = kColorFromStr(@"#6189C5");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
