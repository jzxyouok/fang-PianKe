//
//  ColloctionModel.h
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColloctionModel : NSObject


@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *radioid;


+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic;



@end
