
//
//  tabelViewModel.m
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "tabelViewModel.h"

@implementation tabelViewModel

+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dic = jsonDic[@"data"];
    NSArray *array = dic[@"alllist"];
    for (NSDictionary *dict in array) {
        tabelViewModel *model = [[tabelViewModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        NSDictionary *d = dict[@"userinfo"];
        model.uname = d[@"uname"];
        [modelArray addObject:model];
    }
    return modelArray;
}


+ (NSMutableArray *)modelConfigureJsonDicMore:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dic = jsonDic[@"data"];
    NSArray *array = dic[@"list"];
    for (NSDictionary *dict in array) {
        tabelViewModel *model = [[tabelViewModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        NSDictionary *d = dict[@"userinfo"];
        model.uname = d[@"uname"];
        [modelArray addObject:model];
    }
    return modelArray;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}









@end
