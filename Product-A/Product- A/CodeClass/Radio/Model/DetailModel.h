//
//  DetailModel.h
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DownloadType){
    UnDownload,
    Downloadimg,
    DownloadPause,
    DiDdwonload
};


@interface DetailModel : NSObject

@property(nonatomic,strong)NSString *coverimg;
@property(nonatomic,strong)NSString *musicUrl;
@property(nonatomic,strong)NSString *musicVisit;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSString *webview_url;
@property(nonatomic,assign)BOOL isPlay;
@property(nonatomic,strong)NSString *savePath;
@property(nonatomic,assign)DownloadType downloadType;

@property(nonatomic,assign)BOOL isSelect;

+ (NSMutableArray *)modelWithJson:(NSDictionary *)jsonDic;





@end
