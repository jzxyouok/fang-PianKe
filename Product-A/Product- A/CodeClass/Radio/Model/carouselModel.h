//
//  carouselModel.h
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface carouselModel : NSObject

@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *radioid;

+ (NSMutableArray *)carouselModelConfigureJson:(NSDictionary *)jsonDic;

@end
