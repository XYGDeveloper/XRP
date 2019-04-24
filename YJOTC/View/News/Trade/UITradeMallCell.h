//
//  UITradeMallCell.h
//  YJOTC
//
//  Created by 周勇 on 2018/8/14.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol UITradeMallCellDelegate <NSObject>

-(void)didClickPanKouListWith:(NSDictionary *)dataDic;

@end

@interface UITradeMallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *limiteButton;
@property (weak, nonatomic) IBOutlet XNCustomTextfield *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *progressBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressEndLabel;


@property (weak, nonatomic) IBOutlet XNCustomTextfield *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCurrencyLabel;

@property (weak, nonatomic) IBOutlet UILabel *dealLabel;


@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCNYLabel;

@property (weak, nonatomic) IBOutlet UISlider *slide;

/**  卖盘  */
@property (weak, nonatomic) IBOutlet UIView *topPanKouView;
/**  买盘  */
@property (weak, nonatomic) IBOutlet UIView *bottomPanKouView;

@property(nonatomic,assign)NSArray *buyArray;
@property(nonatomic,assign)NSArray *sellArray;


@property(nonatomic,weak)id <UITradeMallCellDelegate> delegate;





@end
