//
//  DetailModel.m
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailModel.h"
#import "MusicDownloadTable.h"

@implementation DetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSMutableArray *)modelWithJson:(NSDictionary *)jsonDic{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arr = jsonDic[@"data"][@"list"];
    for (NSDictionary *dic in arr) {
        DetailModel *model = [[DetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.uname = dic[@"playInfo"][@"authorinfo"][@"uname"];
        model.webview_url = dic[@"playInfo"][@"webview_url"];
        model.downloadType = UnDownload;
        
        MusicDownloadTable *table = [[MusicDownloadTable alloc] init];
        NSArray *arr = [table selectAll];
        for (NSArray *array in arr) {
            if ([array containsObject:model.musicUrl]) {
                model.downloadType = DiDdwonload;
            }
        }
        [array addObject:model];
    }
    return array;
}







@end
