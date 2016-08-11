//
//  tabelViewModel.h
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tabelViewModel : NSObject

@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSNumber *count;
@property(nonatomic,strong)NSString *radioid;


+ (NSMutableArray *)modelConfigureJsonDic:(NSDictionary *)jsonDic;
+ (NSMutableArray *)modelConfigureJsonDicMore:(NSDictionary *)jsonDic;




@end
