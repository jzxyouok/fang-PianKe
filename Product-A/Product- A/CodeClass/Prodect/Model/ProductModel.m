//
//  ProductModel.m
//  Product- A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel


+ (NSMutableArray *)modelWithConfigure:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dict = jsonDic[@"data"];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        ProductModel *model = [[ProductModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [modelArray addObject:model];
    }
    return modelArray;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
