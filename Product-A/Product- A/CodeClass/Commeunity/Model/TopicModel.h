//
//  TopicModel.h
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

@property(nonatomic,strong)NSString *addtime_f;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *contentid;
@property(nonatomic,strong)NSNumber *comment;
@property(nonatomic,strong)NSNumber *like;
@property(nonatomic,strong)NSNumber *view;
@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *ishot;
@property(nonatomic,strong)NSString *isrecommend;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *songid;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *uname;


+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic;


@end
