//
//  topicComment.m
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "topicComment.h"

@implementation topicComment

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arr = jsonDic[@"data"][@"commentlist"];
    for (NSDictionary *dic in arr) {
        topicComment *model = [[topicComment alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.icon = dic[@"userinfo"][@"icon"];
        model.uid = dic[@"userinfo"][@"uid"];
        model.uname = dic[@"userinfo"][@"uname"];
        [array addObject:model];
    }
    return array;
}


@end
