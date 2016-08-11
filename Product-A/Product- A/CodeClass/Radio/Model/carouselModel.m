//
//  carouselModel.m
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "carouselModel.h"

@implementation carouselModel


+ (NSMutableArray *)carouselModelConfigureJson:(NSDictionary *)jsonDic{
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dic = jsonDic[@"data"];
    NSArray *array = dic[@"carousel"];
    for (NSDictionary *modelDic in array) {
        carouselModel *model = [[carouselModel alloc] init];
        [model setValuesForKeysWithDictionary:modelDic];
        NSString *url = modelDic[@"url"];
        NSArray *arr = [url componentsSeparatedByString:@"/"];
        model.radioid = arr.lastObject;
        [modelArray addObject:model];
    }
    return modelArray;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}




@end
