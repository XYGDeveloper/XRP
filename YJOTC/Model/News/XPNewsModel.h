//
//  XPNewsModel.h
//  YJOTC
//
//  Created by 前海数交（ZJ） on 2018/12/13.
//  Copyright © 2018年 前海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPNewsModel : NSObject

@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *art_pic;

@end

NS_ASSUME_NONNULL_END
