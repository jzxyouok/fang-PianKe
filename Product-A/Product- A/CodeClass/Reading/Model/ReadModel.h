//
//  ReadModel.h
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadModel : NSObject

@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *enname;
@property(nonatomic,strong)NSNumber *type;

+ (NSMutableArray *)stringArrayWithDic:(NSDictionary *)jsonDic;
+ (NSMutableArray *)modelConfigureDic:(NSDictionary *)jsonDic;










@end
