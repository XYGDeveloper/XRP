//
//  Utilities.m
//  EnergySport
//
//  Copyright © 2016年 Kaisa. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"

@implementation Utilities

+(BOOL)netWorkUnAvalible
{
    NetworkStatus networkStatus = [Utilities netWorkStatus];
    
    switch (networkStatus) {
        case NotReachable:
        {
            NSLog(@"请检查网络");
            return true;
        }
        default:
            break;
    }
    return false;
}

+(NetworkStatus)netWorkStatus
{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return networkStatus;
}

+(float)stdScreenRatio
{
    // 320 4/4s,5/5s
    // 375 6/6s
    // 414 6p/6ps
    // 基于 6/6s 屏为标准
    float ratio = kScreenWidth / 375.0;
    //    NSLog(@"ratio: %f", ratio);
    return ratio;
}
/**  屏幕高度比例系数,以iphone6为基准  */
+(float)stdScreenHeightRatio
{
    float ratio = kScreenHeight / 667.0;
    return ratio;
}
// 传进来的是秒数，不用除以1000
+ (NSString *)returnTimeWithSecond:(NSInteger)second formatter:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr];
    second = second > 140000000000 ? second / 1000 : second;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:second];
    NSString *returnTimeStr = [formatter stringFromDate:confromTimesp];
    return returnTimeStr;
}

// 计算label 高宽
+ (CGRect)calculateWidthAndHeightWithWidth:(CGFloat)width height:(CGFloat)height text:(NSString *)text font:(UIFont *)font
{
//    CGRect titleSize = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  | NSStringDrawingUsesLineFragmentOrigin            attributes:@{NSFontAttributeName: font} context:nil];
    CGRect titleSize = [text boundingRectWithSize:CGSizeMake(width, height) options:  NSStringDrawingUsesLineFragmentOrigin            attributes:@{NSFontAttributeName: font} context:nil];

    
    return titleSize;
}

+(void)showStatusBar;
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

//图片转base64字符串
+(NSString *)encodeToBase64StringWithImage:(UIImage *)image
{
    NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString *_encodedImageStr = [_data base64EncodedString];
    
    return _encodedImageStr;
}


+(UIImage *)getQRImageWithContent:(NSString *)msg
{
    /**
     * 获取所有可用的滤镜 (名字)
     kCICategoryBuiltIn 指是系统内建的滤镜
     */
//    NSArray <NSString *> *fileNames = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    NSLog(@"fileNames: %@", fileNames);
    
    /**
     * 必须要确保滤镜名字是正确, CIQRCodeGenerator
     */
    // 根据滤镜名创建对应的滤镜 (滤镜名必须正确, 而且是系统提供的)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 1. 通过文档来查找该滤镜 (图文效果)
    // 2. 通过代码方式来查找, 找到相应的Key与Value的描述
//    NSDictionary <NSString *, id> *attributes = filter.attributes;
//    NSLog(@"%@", attributes);
    
    // 直接生成一张字符串对应的二维码图片, 并不需要图片输入
    
    // -------- 配置输入参数 --------
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    // 会影响二维码能被遮挡的内容大小 (H接近30%)
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // -------- 获取 --------
    // 获取滤镜的输出图片
    CIImage *outputImage = filter.outputImage;
    
    //消除迷糊
    
    CGFloat scaleX = 200 / outputImage.extent.size.width; // extent 返回图片的frame
    
    CGFloat scaleY = 200 / outputImage.extent.size.height;
    
    CIImage *transformedImage = [outputImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
/**  生成条形码  */
+(UIImage *)getBarCodeImageWithContent:(NSString *)msg
{   //NSNonLossyASCIIStringEncoding   ==>这个key才可以
     // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [msg dataUsingEncoding:NSNonLossyASCIIStringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
//    CGFloat scaleX = 300 * kScreenWidthRatio / barcodeImage.extent.size.width; // extent 返回图片的frame
//    CGFloat scaleY = 200 * kScreenHeightRatio / barcodeImage.extent.size.height;
//    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:barcodeImage];
    
}
// 每隔4个字符空两格
+(NSString *)formatCode:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+(BOOL)isExpired
{
    
//    NSString *token = kUserInfo.token;
    
    
    if (kUserInfo.token == nil || [kUserInfo.token isEqualToString:@""] || kUserInfo.token.length < 2) {
        return YES;
    }
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
//    kLOG(@"currentTime==%@",[Utilities returnTimeWithSecond:currentTime formatter:@"yyyy-MM-dd HH:mm"]);

    //一个月的有效期
//    NSTimeInterval expiredTime = kUserInfo.thisLoginTime.integerValue / 1000 + 60 * 60 * 24 * 30;
//7天有效期
//    id obj = [kUserDefaults objectForKey:@"kLastLoginTimeKey"];
    
    NSTimeInterval expiredTime = [[kUserDefaults objectForKey:@"kLastLoginTimeKey"] timeIntervalSince1970] + 60 * 60 * 24;
//    kLOG(@"上次登录时间 %@",[Utilities returnTimeWithSecond:expiredTime formatter:@"yyyy-MM-dd HH:mm"]);
    
    
    if (currentTime > expiredTime) {
        return YES;
    }else{
        return NO;
    }
}



+(NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
    options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"\"',<>.?/~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|$^:《》,$_€~`!"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}



+ (NSString *)handleParamsWithDic:(NSDictionary *)param
{
//    if ([[param allValues] count] == 0) {
//        return nil;
//    }
    
   NSArray *keys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       return [obj1 compare:obj2]; //升序
    }];
    NSMutableString *resultStr = [NSMutableString string];
    //键值对拼接
    for (NSInteger i = 0; i < keys.count; i++) {
        //去除首尾空格
        NSString *value = param[keys[i]];
        
        if ([value isKindOfClass:[NSString class]]) {
//            while ([value hasPrefix:@" "]) {
//                value = [value substringFromIndex:1];
//            }
//            while ([value hasSuffix:@" "]) {
//                value = [value substringToIndex:value.length - 1];
//            }
            //去除首尾空格
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [resultStr appendString:[NSString stringWithFormat:@"%@=%@&",keys[i],value]];
        }else{
            [resultStr appendString:[NSString stringWithFormat:@"%@=%@&",keys[i],param[keys[i]]]];
        }
    }
    //加上keycode
    [resultStr appendString:[NSString stringWithFormat:@"key=%@",kKeyCode]];
    
    //先md5,再大写
    return  [[resultStr md5String] uppercaseString];
}
+ (NSString *)randomUUID {
    NSString *deviceUID_Str = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceUID"];
    if (deviceUID_Str&&deviceUID_Str.length>0) {
        return deviceUID_Str;
    }
    if(NSClassFromString(@"NSUUID")) { // only available in iOS >= 6.0
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUUID UUID] UUIDString] forKey:@"deviceUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[NSUUID UUID] UUIDString];
    }
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [((__bridge NSString *) cfuuid) copy];
    CFRelease(cfuuid);
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"deviceUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uuid;
}


+ (NSString *)URLDecodedString:(NSString *)str;
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *)view
{
    // 创建BezierPath 并设置角 和 半径 这里只设置了 右上 和 右下
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(view.frame.size.height / 2, view.frame.size.height / 2)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = view.bounds;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

+ (CGSize)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
//    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}



+ (UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


/**  接口格式  */
+ (NSString *)handleAPIWith:(NSString *)url
{
    
    if ([url containsString:@"api"]) {
        return url;
    }else{
//        return url;
        return [@"/api" stringByAppendingPathComponent:url];
        
//        return [NSString stringWithFormat:@"/Api/%@",url];
    }

   //@"mb_index/search"
//    /mobile/index.php?act=mb_login&op=register
    
    
//    NSArray *strArr = [url componentsSeparatedByString:@"/"];
//    return [NSString stringWithFormat:@"/mobile/index.php?act=%@&op=%@",strArr.firstObject,strArr.lastObject];
}


/**  大于0的数字  */
+(BOOL)greaterThanZeroWith:(NSString *)str;
{
    NSString *pattern = @"^\d+(\.{0,1}\d+){0,1}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    return results.count > 0;
}

+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(15,4);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    //    CGFloat offset = 0.f;
    
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    //    view.layer.shouldRasterize = YES;
    //    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
    
}

+(NTESVerifyCodeLang)getLangguageForNTESVerifyCode
{
    if ([[LocalizableLanguageManager userLanguage] containsString:@"en"]) {
        return NTESVerifyCodeLangEN;
    }else{
        return NTESVerifyCodeLangTW;
    }
}

@end
