//
//  DetailViewController.m
//  Product- A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+Html.h"
#import "CommentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface DetailViewController ()
@property(strong,nonatomic)UIButton *startBtn;
@property(strong,nonatomic)UIButton *fontBtn;
@property(strong,nonatomic)UIButton *hearts;
@property(strong,nonatomic)UILabel *heartL;
@property(strong,nonatomic)UIButton *comment;
@property(strong ,nonatomic)UILabel *commentL;
@property(strong,nonatomic)UIButton *more;
@property(nonatomic,strong)NSString *html;
@end

@implementation DetailViewController

- (UIButton *)startBtn  {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _startBtn.frame = CGRectMake(15, 20 + 15, 20, 20);
        [_startBtn  setImage:[UIImage imageNamed:@"left.png"]  forState:(UIControlStateNormal)];
        [_startBtn setTintColor:PKCOLOR(40, 40, 40)];
        [_startBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _startBtn;
}

- (UIButton *)fontBtn{
    if (!_fontBtn) {
        _fontBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _fontBtn.frame = CGRectMake(60, 30, 30, 30);
        [_fontBtn setBackgroundImage:[UIImage imageNamed:@"generic_text.png"] forState:(UIControlStateNormal)];
//        [_fontBtn setTintColor:PKCOLOR(255, 255, 255)];
    }
    return _fontBtn;
}

- (UIButton *)hearts{
    if (!_hearts) {
        _hearts = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _hearts.frame = CGRectMake(kScreenWidth - 135, 30, 30, 30);
        [_hearts addTarget:self action:@selector(heartsAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_hearts setBackgroundImage:[UIImage imageNamed:@"hearts.png"] forState:(UIControlStateNormal)];
    }
    return _hearts;
}

- (UILabel *)heartL{
    if (!_heartL) {
        _heartL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 135 + 35, 35, 40, 20)];
        _heartL.font = [UIFont systemFontOfSize:15];
    }
    return _heartL;
}


- (UIButton *)comment{
    if (!_comment) {
        _comment = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _comment.frame = CGRectMake(kScreenWidth - 210, 30, 30, 30);
        [_comment addTarget:self action:@selector(commentAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_comment setBackgroundImage:[UIImage imageNamed:@"SMS_filled"] forState:(UIControlStateNormal)];
    }
    return _comment;
}


- (UILabel *)commentL{
    if (!_commentL) {
        _commentL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 210 + 35, 35, 40, 20)];
        _commentL.font = [UIFont systemFontOfSize:15];
    }
    return _commentL;
}


- (UIButton *)more{
    if (!_more) {
        _more = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _more.frame = CGRectMake(kScreenWidth - 50, 30, 30, 30);
       [_more addTarget:self action:@selector(moreAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_more setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:(UIControlStateNormal)];
    }
    return _more;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.fontBtn];
    [self.view addSubview:self.hearts];
    [self.view addSubview:self.heartL];
    [self.view addSubview:self.comment];
    [self.view addSubview:self.commentL];
    [self.view addSubview:self.more];
    [self getWebView];
   
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(49, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(200, 200, 200);
    [self.view addSubview:vertical];
    
    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 19 + KNaviH, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(200, 200, 200);
    [self.view addSubview:horizontal];
    
}



- (void)backBtnAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)heartsAction:(UIButton *)btn{
    
    
    
}
- (void)commentAction:(UIButton *)btn{
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.contentid = self.contnedID;
    [self.navigationController pushViewController:comment animated:YES];
}



- (void)getWebView{
    if (self.url) {
        self.contendid = [self.url substringFromIndex:self.url.length - 24];
    }
    NSDictionary *dic = @{@"contentid":self.contendid,@"client":@"1",@"deviceid":@"63A94D37-33F9-40FF-9EBB-481182338873",@"auth":@"Wc06FCrkoq1DCMVzGMTikDJxQ8bm3Mrm2NpT9qWjwzcWP23tBKQx1c4P0",@"version":@"3.0.2"};
    [RequestManager requestWithUrlString:kReadDetail parDic:dic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSDictionary *dict = dic[@"data"];
        NSString *html = dict[@"html"];
        self.commentL.text = [NSString stringWithFormat:@"%@",dict[@"counterList"][@"comment"]];
        self.heartL.text = [NSString stringWithFormat:@"%@",dict[@"counterList"][@"like"]];
        self.contnedID = dict[@"contentid"];
        
        self.html = [NSString importStyleWithHtmlString:html];
        UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20 + KNaviH, kScreenWidth, kScreenHeight - 69)];
        [webV loadHTMLString:self.html baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        [self.view addSubview:webV];
    } error:^(NSError *error) {
//        NSLog(@"error ========= %@",error);
    }];
}






- (void)moreAction:(UIButton *)btn{
    
    //1、创建分享参数
    NSArray* imageArray = @[self.covimg];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容" images:imageArray url:[NSURL URLWithString:self.html] title:@"分享标题" type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        }];
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                            items:nil
                            shareParams:shareParams
                            onShareStateChanged:^(SSDKResponseState state,SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                switch (state) {
                                    case SSDKResponseStateSuccess:{
                                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                                                 [alertView show];
                                        
                                    break;
                                }
                                    case SSDKResponseStateFail:{
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                 [alert show];
                                    break;
                                }
                                    default:
                                    break;
                                }
                    }
         ];
    }

    
    
}


@end
