//
//  ReadModel.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray *)stringArrayWithDic:(NSDictionary *)jsonDic{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = jsonDic[@"data"];
    NSArray *arr = dict[@"carousel"];
    for (NSDictionary *dic in arr) {
        ReadModel *model = [[ReadModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [array addObject:model];
    }
    return array;
}



+ (NSMutableArray *)modelConfigureDic:(NSDictionary *)jsonDic{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = jsonDic[@"data"];
    NSArray *arr = dict[@"list"];
    for (NSDictionary *dic in arr) {
        ReadModel *model = [[ReadModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [array addObject:model];
    }
    return array;
}


@end
