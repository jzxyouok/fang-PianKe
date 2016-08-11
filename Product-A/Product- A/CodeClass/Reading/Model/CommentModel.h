//
//  CommentModel.h
//  Product- A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic,strong)NSString *addtime_f;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSString *contentid;
@property(nonatomic,assign)BOOL isdel;

+ (NSMutableArray *)modelConfigureJson:(NSDictionary *)jsonDic;



@end
