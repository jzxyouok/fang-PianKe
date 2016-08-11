//
//  CollectionVIewModel.m
//  Product- A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectionVIewModel.h"

@implementation CollectionVIewModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray *)modelWithJSONDic:(NSDictionary *)JSONDic{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = JSONDic[@"data"];
    NSArray *arr = dic[@"list"];
    for (NSDictionary *dict  in arr) {
        CollectionVIewModel *model = [[CollectionVIewModel alloc] init];
        model.contentId = dict[@"id"];
        [model setValuesForKeysWithDictionary:dict];
        [array addObject:model];
    }
    return array;
}





@end
