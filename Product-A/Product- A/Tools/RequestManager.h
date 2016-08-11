//
//  RequestManager.h
//  18UILessonCocoapods
//
//  Created by I三生有幸I on 16/6/16.
//  Copyright © 2016年 盛辰. All rights reserved.
//

#import <Foundation/Foundation.h>
// 这个类是基于对AFNetWorking的一个二次封装
// 之前我们请求的方式是用NSURLSession 现在我们请求的方式变成AFNetWorking

// 请求方式的枚举
typedef NS_ENUM(NSInteger, RequestType) {
    RequestGET, // GET请求
    RequestPOST // POST请求
};

// 请求成功回调的block
typedef void(^Finish)(NSData *data);

// 请求失败回调的block
typedef void(^Error)(NSError *error);

@interface RequestManager : NSObject
// block属性
@property (nonatomic, copy)Finish finish;
@property (nonatomic, copy)Error error;

// 给controller提供的接口 传进来字符串网址 字典 请求类型 成功block 失败blcok
+ (void)requestWithUrlString:(NSString *)urlString parDic:(NSDictionary *)parDic requestType:(RequestType)requestType finish:(Finish)finish error:(Error)error;
@end









