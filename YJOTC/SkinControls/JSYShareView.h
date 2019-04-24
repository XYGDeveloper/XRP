//
//  JSYShareView.h
//  jys
//
//

#import <UIKit/UIKit.h>


typedef enum {
    JSYShareViewTypeCircle = 0,//商圈分享
    JSYShareViewTypeNews, //资讯分享
    JSYShareViewTypeApp //app分享
} JSYShareViewType;

@interface JSYShareView : UIView

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,strong)NSString *shareTitle;

-(instancetype)initWithFrame:(CGRect)frame model:(YWDynamicModel *)model type:(JSYShareViewType)type;





@end
