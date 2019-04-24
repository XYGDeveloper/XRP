//
//  XPCommunityZTCollectionViewCell.m
//  YJOTC
//
//  Created by l on 2018/12/25.
//  Copyright © 2018年 前海. All rights reserved.
//

#import "XPCommunityZTCollectionViewCell.h"
#import "XPGetValiModel.h"
@implementation XPCommunityZTCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    kViewBorderRadius(self.bgview, 8, 0, kRedColor);
    [self.bgview addShadow];
    self.operationButton.layer.cornerRadius = 8;
    self.operationButton.layer.masksToBounds = YES;
    // Initialization code
}

//@property (weak, nonatomic) IBOutlet UILabel *piaoCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *piaoContentLabel;
//@property (weak, nonatomic) IBOutlet UIButton *operationButton;
//@property (weak, nonatomic) IBOutlet UIView *bgview;
- (void)refreshWithModel:(innerModel *)model{
    self.piaoCountLabel.text = [NSString stringWithFormat:@"%@%@",model.votes,kLocat(@"C_community_search_votes")];
    self.piaoContentLabel.text = model.number;
    if ([model.status isEqualToString:@"0"]) {
        [self.operationButton setTitle:kLocat(@"C_community_search_noopen") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#8697AB");
    }else{
        [self.operationButton setTitle:kLocat(@"C_community_search_jihuo") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#066B98");
    }
}

- (void)refreshWithVotesModel:(innerModel *)model{
    self.piaoCountLabel.text = [NSString stringWithFormat:@"%@%@",model.votes,kLocat(@"C_community_search_votes")];
    self.piaoContentLabel.text = model.number;
    if ([model.status isEqualToString:@"0"]) {
        [self.operationButton setTitle:kLocat(@"C_community_search_noopen") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#8697AB");
    }else if ([model.status isEqualToString:@"1"]){
        [self.operationButton setTitle:kLocat(@"C_community_reward_current_zt") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#066B98");
    }else if ([model.status isEqualToString:@"2"]){
        [self.operationButton setTitle:kLocat(@"C_community_reward_current_ytp") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#AFBBBF");
    }else{
        [self.operationButton setTitle:kLocat(@"C_community_search_dovote") forState:UIControlStateNormal];
        self.operationButton.backgroundColor = kColorFromStr(@"#6189C5");
    }
 
}


- (IBAction)voteAction:(id)sender {
    
    if (self.votes) {
        self.votes();
    }
}




@end
