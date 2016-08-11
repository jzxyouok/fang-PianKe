//
//  ProductDetailViewController.m
//  Product- A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "NSString+Html.h"
#import <WebKit/WebKit.h>

@interface ProductDetailViewController ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *shareBtn;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.commentBtn];
    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.shareBtn];
    
    
}


- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69)];
    }
    return _webView;
}
- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _commentBtn.frame = CGRectMake(kScreenWidth - 200, 30, 40, 30);
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"u76"] forState:(UIControlStateNormal)];
        _commentBtn.tintColor = [UIColor whiteColor];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _commentBtn;
}
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _likeBtn.frame = CGRectMake(kScreenWidth - 140, 30, 40, 30);
        _likeBtn.tintColor = [UIColor whiteColor];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"u80"] forState:(UIControlStateNormal)];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _likeBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _shareBtn.frame = CGRectMake(kScreenWidth - 60, 30, 30, 30);
        _shareBtn.tintColor = PKCOLOR(180, 180, 180);
        [_shareBtn setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
    }
    return _shareBtn;
}


#pragma mark ---------加载数据 -------
- (void)loadData{
    NSDictionary *parDic = @{@"auth":[UserInfoManager getUserAuth],@"contentid":self.contentid};
    [RequestManager requestWithUrlString:kProductsDetail parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSString *html = dic[@"data"][@"postsinfo"][@"html"];
        NSString *htmlString = [NSString importStyleWithHtmlString:html];
        [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"data"][@"commenttotal"]] forState:(UIControlStateNormal)];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"data"][@"postsinfo"][@"counterList"][@"like"]] forState:(UIControlStateNormal)];
        NSLog(@"%@",dic);
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}


#pragma mark  ----- button 的点击方法 -----


@end
