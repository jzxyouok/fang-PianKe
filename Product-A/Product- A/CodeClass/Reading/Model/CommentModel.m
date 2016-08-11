//
//  CommentModel.m
//  Product- A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


+ (NSMutableArray *)modelConfigureJson:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dic =jsonDic[@"data"];
    NSArray *array = dic[@"list"];
    for (NSDictionary *dict in array) {
        CommentModel *model = [[CommentModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        model.icon = dict[@"userinfo"][@"icon"];
        model.uname = dict[@"userinfo"][@"uname"];
        [modelArray addObject:model];
    }
    return modelArray;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
