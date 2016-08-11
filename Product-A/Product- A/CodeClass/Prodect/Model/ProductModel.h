//
//  ProductModel.h
//  Product- A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property(nonatomic,strong)NSString *buyurl;
@property(nonatomic,strong)NSString *contentid;
@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *title;

+(NSMutableArray *)modelWithConfigure:(NSDictionary *)jsonDic;


@end
