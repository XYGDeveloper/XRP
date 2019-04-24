

//
//  TPWalletCurrencyDetailListCell.m
//  YJOTC
//
//  Created by 周勇 on 2018/9/11.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "TPWalletCurrencyDetailListCell.h"

@interface TPWalletCurrencyDetailListCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *W;

@end

@implementation TPWalletCurrencyDetailListCell


-(void)setAccountDic:(NSDictionary *)accountDic
{
    _accountDic = accountDic;
    //1:兑换 5:充币 6:提币 8:转账到口袋账户 9:OTC交易 10:OTC交易撤销手续费 11:币币交易 12:持币生息 13:管理员充值 15:转账到信链星球

    switch ([accountDic[@"type"] integerValue]) {
        case 1:
        {
            _icon.image = kImageFromStr(@"eth_icon_huanbi_1");
        }
            break;
        case 5://充
        {
            _icon.image = kImageFromStr(@"eth_icon_jies");
        }
            break;
        case 6://提
        {
            _volumeLabel.text = [NSString stringWithFormat:@"%@ %@",accountDic[@"number"],accountDic[@"from_name"]];
            _icon.image = kImageFromStr(@"eth_icon_fsong");
        }
            break;
        case 7://提
        {
            _icon.image = kImageFromStr(@"eth_icon_jies");
        }
            break;
        case 8:
        {
            _icon.image = kImageFromStr(@"zzhu_icon");
        }
            break;
        case 9:
        {
            _icon.image = kImageFromStr(@"eth_icon_huanbi_1");
        }
            break;
        case 10:
        {
            _icon.image = kImageFromStr(@"eth_icon_huanbi_1");
        }
            break;
        case 11:
        {
            _icon.image = kImageFromStr(@"eth_icon_huanbi_1");
        }
            break;
        case 12:
        {
            _icon.image = kImageFromStr(@"cbsx_icon");
        }
            break;
        case 13:
        {
            _icon.image = kImageFromStr(@"guanlu_icon");
        }
            break;
        case 15:
        {
            _icon.image = kImageFromStr(@"xingqiu_icon");
        }
            break;
    
        default:
            
            _icon.image = kImageFromStr(@"eth_icon_huanbi_1");

            break;
    }
    
    _addLabel.text = accountDic[@"content"];
    _tagLabel.text = accountDic[@"type_name"];
    _timeLabel.text = accountDic[@"add_time"];
    NSLog(@"////////////%@",accountDic[@"add_time"]);
    if ([accountDic[@"number_type"] intValue] == 1) {//number_type 1收入 2支出
        _volumeLabel.text = [NSString stringWithFormat:@"%@ %@",accountDic[@"number"],accountDic[@"from_name"]];
        _volumeLabel.textColor = kColorFromStr(@"#03C086");

    }else{
        _volumeLabel.text = [NSString stringWithFormat:@"%@ %@",accountDic[@"number"],accountDic[@"from_name"]];
        _volumeLabel.textColor = kColorFromStr(@"#EA6E44");
    }

}




-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    _addLabel.text = dataDic[@"address"];
    _volumeLabel.text = dataDic[@"actual"];
    _timeLabel.text = dataDic[@"add_time"];

    _tagLabel.text = [NSString stringWithFormat:@"%@:%@",kLocat(@"M_addressTag"),dataDic[@"names"]];
    
    if ([dataDic[@"type"]isEqualToString:@"in"] ) {//type 0充值+ 1提币-
        _icon.image = kImageFromStr(@"eth_icon_jies");
        _volumeLabel.textColor = kColorFromStr(@"#03C086");
    }else{
        _icon.image = kImageFromStr(@"eth_icon_fsong");
        _volumeLabel.textColor = kColorFromStr(@"#EA6E44");
    }
    
    
    
    /**
    "type":"0",
    "address":"GDYIDYCE2UGASZJUT7IP6W6D2YBVJQIGN4LS7U7UJE6XE3DZGUFKSBB6",
    "name":"Davel123",
    "add_time":"1536826226",
    "num":"+0.00099000",
    "status":"1",
    "fee":"0.00",
    "actual":"0.00099000",
    "remarks":"",
    "status_txt":"充币成功"
    */
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = 0;
    self.contentView.backgroundColor = kTableColor;
    
    
//    self.addLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    _addLabel.textColor = kLightGrayColor;
    _addLabel.font = PFRegularFont(14);
    
    _tagLabel.textColor = kLightGrayColor;
    _tagLabel.font = PFRegularFont(12);
    
    _volumeLabel.textColor = kColorFromStr(@"#03C086");//#EA6E44 黄色
    _volumeLabel.font = PFRegularFont(14);
    
    _timeLabel.textColor = kColorFromStr(@"#999999");
    _timeLabel.font = PFRegularFont(10);
    
    
    //eth_icon_fsong 红色    eth_icon_jies 绿色
    
    if (kScreenW < 321) {
        _W.constant = 145;
    }else{
        _W.constant = 180;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
