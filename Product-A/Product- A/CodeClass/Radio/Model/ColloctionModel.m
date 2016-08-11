//
//  ColloctionModel.m
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ColloctionModel.h"

@implementation ColloctionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dic = jsonDic[@"data"];
    NSArray *array = dic[@"hotlist"];
    for (NSDictionary *dict in array) {
        ColloctionModel *model = [[ColloctionModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}




@end
