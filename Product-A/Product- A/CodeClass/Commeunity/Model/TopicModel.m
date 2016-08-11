//
//  TopicModel.m
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel



+(NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arr = jsonDic[@"data"][@"list"];
    for (NSDictionary *dic in arr) {
        TopicModel *model = [[TopicModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.comment = dic[@"counterList"][@"comment"];
        model.like = dic[@"counterList"][@"like"];
        model.view = dic[@"counterList"][@"view"];
        model.icon = dic[@"userinfo"][@"icon"];
        model.uid = dic[@"userinfo"][@"uid"];
        model.uname = dic[@"userinfo"][@"uname"];
        
        [array addObject:model];
    }
    return array;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
