//
//  topicComment.h
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topicComment : NSObject

@property(nonatomic,strong)NSString *addtime_f;
@property(nonatomic,strong)NSString *cmtnum;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *contentid;
@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,assign)BOOL isdel;
@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSNumber *likenum;

+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic;



@end
