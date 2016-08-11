//
//  musicViewController.m
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "musicViewController.h"
#import "DetailModel.h"
#import "DetailListTableViewCell.h"
#import "NSString+Html.h"
#import "DownloadManager.h"
#import "Download.h"
#import "MusicDownloadTable.h"
#import "BlurView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface musicViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *bassScrollView;
@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)UIView *plyerTableView;
@property(nonatomic,strong)UIView *LyricsTableView;
@property(nonatomic,strong)UIWebView *webV;
@property(nonatomic,assign)BOOL isList;
@property(nonatomic,assign)BOOL play;
@property(nonatomic,assign)BOOL scroll;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)BlurView *blurView;
@property(nonatomic,strong)NSMutableArray *downloadArray;
@property(nonatomic,strong)CABasicAnimation *animation;
@end

@implementation musicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view removeGestureRecognizer:self.tap];
    [self.view addSubview:self.blurView];
    [self setValue];
    [self reloadViewWithIndex:[MyPlayerManager defaultManager].index];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];

}

- (NSMutableArray *)downloadArray{
    if (!_downloadArray) {
        _downloadArray = [NSMutableArray array];
    }
    return _downloadArray;
}




-(BlurView *)blurView{
    if (!_blurView) {
        NSInteger index = [MyPlayerManager defaultManager].index;
        DetailModel *model = [MyPlayerManager defaultManager].musicLists[index];
        _blurView = [[BlurView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69) Image:model.coverimg];
    }
    return _blurView;
}




//播放按钮搭建
- (void)setValue{
    self.bassScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 70 - 75)];
    self.bassScrollView.contentSize = CGSizeMake(kScreenWidth * 3, CGRectGetHeight(_bassScrollView.frame));
    self.bassScrollView.delegate = self;
    self.bassScrollView.pagingEnabled = YES;
    self.bassScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.bassScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bassScrollView];
    [self.bassScrollView addSubview:self.plyerTableView];
    [self.bassScrollView addSubview:self.listTableView];
    [self.bassScrollView addSubview:self.LyricsTableView];
    
    self.pagOne = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 - 40, kScreenHeight - 75, 15, 2)];
    self.pagOne.backgroundColor = [UIColor lightGrayColor];
    self.pagTwo = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 - 10, kScreenHeight - 75, 15, 2)];
    self.pagTwo.backgroundColor = [UIColor greenColor];
    self.pagThree = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 + 20, kScreenHeight - 75, 15, 2)];
    self.pagThree.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pagOne];
    [self.view addSubview:self.pagTwo];
    [self.view addSubview:self.pagThree];
    self.bassView = [[UIView alloc] initWithFrame:CGRectMake(40, kScreenHeight - 65, kScreenWidth - 80, 1)];
    self.bassView.backgroundColor = PKCOLOR(150, 150, 150);
    [self.view addSubview:self.bassView];
    self.lastBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.lastBtn.frame = CGRectMake(60, kScreenHeight - 47, 30, 30);
    [self.lastBtn addTarget:self action:@selector(lastBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:@"music_icon_last_highlighted"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.lastBtn];
    self.playAndPause = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playAndPause addTarget:self action:@selector(playAndPauseBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.playAndPause.frame = CGRectMake(kScreenWidth/2.0 - 25, kScreenHeight -57, 50, 50);
    [self.playAndPause setBackgroundImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.playAndPause];
    self.next = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.next addTarget:self action:@selector(nextBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.next.frame = CGRectMake(kScreenWidth - 50 -30, kScreenHeight -47, 30, 30);
    [self.next setBackgroundImage:[UIImage imageNamed:@"music_icon_next_highlighted"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.next];
    
    self.roundBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.roundBtn.frame = CGRectMake(kScreenWidth/2.0 - 60, 35, 25, 25);
    NSString *playType = [[NSUserDefaults standardUserDefaults] objectForKey:@"playType"];
    if ([playType isEqualToString:@"refresh"]) {
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:(UIControlStateNormal)];
    } else if([playType isEqualToString:@"shuffle"]){
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"shuffle"] forState:(UIControlStateNormal)];
    } else if ([playType isEqualToString:@"repeat"]){
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"repeat"] forState:(UIControlStateNormal)];
    }
    [self.roundBtn addTarget:self action:@selector(roundBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.roundBtn];
    self.collectionBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.collectionBtn.frame = CGRectMake(kScreenWidth/2.0 + 10, 35, 25, 25);
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"star"] forState:(UIControlStateNormal)];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.collectionBtn];
    self.shareBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.shareBtn.frame = CGRectMake(kScreenWidth/2.0 + 100, 30, 30, 30);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
    [self.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.shareBtn];
}






// 播放界面搭建
- (UIView *)plyerTableView{
    if (!_plyerTableView) {
        _plyerTableView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 69 - 75)];
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(45, 45, kScreenWidth -45*2,kScreenWidth -45*2)];
        _imageV.layer.masksToBounds  =YES;
        _imageV.layer.cornerRadius = (kScreenWidth - 45 * 2) / 2.0;
        _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        _animation.duration = 10;
        _animation.repeatCount = MAXFLOAT;
        
        [_plyerTableView addSubview:_imageV];
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenWidth - 45*2 + 62, kScreenWidth, 26)];
        _nameL.textAlignment = NSTextAlignmentCenter;
        [_plyerTableView addSubview:_nameL];
        _heartBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _heartBtn.frame = CGRectMake(100, kScreenWidth -45*2+62+13+30, 20, 20);
        [_heartBtn setBackgroundImage:[UIImage imageNamed:@"hearts"] forState:(UIControlStateNormal)];
        [_plyerTableView addSubview:_heartBtn];
        _commentBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _commentBtn.frame = CGRectMake(kScreenWidth -100 -20, kScreenWidth -45*2+62+13+30, 20, 20);
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"SMS_filled"] forState:(UIControlStateNormal)];
        [_plyerTableView addSubview:_commentBtn];
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _downLoadBtn.frame = CGRectMake(50, kScreenWidth -45*2+62+13+30+35+5, 40, 20);
        [_downLoadBtn addTarget:self action:@selector(downLoadBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_downLoadBtn setTintColor:PKCOLOR(255, 255, 255)];
        [_downLoadBtn setImage:[UIImage imageNamed:@"downloading_updates"] forState:(UIControlStateNormal)];
        [_plyerTableView addSubview:_downLoadBtn];
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(90, kScreenWidth -45*2+62+13+30+35+10, kScreenWidth - 200, 10)];
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:(UIControlEventValueChanged)];
        [_slider setThumbImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [_plyerTableView addSubview:_slider];
        _allTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 85, kScreenWidth -45*2+62+13+30+35+5, 40, 20)];
        _allTimeL.font = [UIFont systemFontOfSize:13];
        [_plyerTableView addSubview:_allTimeL];
    }
    return _plyerTableView;
}





// 播放列表
- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 69 - 75) style:(UITableViewStylePlain)];
        [_listTableView registerNib:[UINib nibWithNibName:@"DetailListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _listTableView.rowHeight = 60;
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
    }
    return _listTableView;
}



//歌词
- (UIView *)LyricsTableView{
    if (!_LyricsTableView) {
        _LyricsTableView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 69)];
        self.webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 75)];
        self.webV.backgroundColor = [UIColor clearColor];
        _LyricsTableView.backgroundColor = [UIColor clearColor];
        [self loadWebView];
        
        [_LyricsTableView addSubview:self.webV];
    }
    return _LyricsTableView;
}


// 加载歌词界面
- (void)loadWebView{
    NSInteger index = [MyPlayerManager defaultManager].index;
    DetailModel *model = [MyPlayerManager defaultManager].musicLists[index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.webview_url]];
    [self.webV loadRequest:request];
}


#pragma mark --- button
- (void)roundBtnAction:(UIButton *)btn{
    NSString *playType = [[NSUserDefaults standardUserDefaults] objectForKey:@"playType"];
    if ([playType isEqualToString:@"repeat"] || playType == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"refresh" forKey:@"playType"];
        [MyPlayerManager defaultManager].playType = ListPlay;
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:(UIControlStateNormal)];
    } else if ([playType isEqualToString:@"refresh"]){
        [MyPlayerManager defaultManager].playType = RandomPlay;
        [[NSUserDefaults standardUserDefaults] setObject:@"shuffle" forKey:@"playType"];
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"shuffle"] forState:(UIControlStateNormal)];
    } else if ([playType isEqualToString:@"shuffle"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"repeat" forKey:@"playType"];
        [MyPlayerManager defaultManager].playType = SignlePlay;
        [self.roundBtn setBackgroundImage:[UIImage imageNamed:@"repeat"] forState:(UIControlStateNormal)];
    }
}
- (void)collectionBtnAction:(UIButton *)btn{
}
- (void)shareBtnAction:(UIButton *)btn{
    
    NSInteger index = [MyPlayerManager defaultManager].index;
    DetailModel *model = [MyPlayerManager defaultManager].musicLists[index];
    
    //1、创建分享参数
    NSArray* imageArray = @[model.coverimg];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:model.uname images:imageArray url:[NSURL URLWithString:model.musicUrl] title:model.title type:SSDKContentTypeAuto];
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
- (void)downLoadBtnAction:(UIButton *)btn{
    // 监听
    NSInteger index = [MyPlayerManager defaultManager].index;
    static DetailModel *model = nil;
    if (index == btn.tag - 1000) {
        model = [MyPlayerManager defaultManager].musicLists[index];
    }else{
        model = [MyPlayerManager defaultManager].musicLists[btn.tag - 1000];
    }
    [self.downloadArray addObject:model];
    DownloadManager *dManager = [DownloadManager defaultManager];
    Download *task = [dManager createDownload:model.musicUrl];
    if (model.downloadType == Downloadimg) {
        model.downloadType = DownloadPause;
        [self.listTableView reloadData];
        [task stop];
    } else if (model.downloadType == DownloadPause){
        [task start];
        model.downloadType = Downloadimg;
        [self.listTableView reloadData];
    } else if(model.downloadType == DiDdwonload ) {
        return;
    } else if (model.downloadType == UnDownload){
        model.downloadType = Downloadimg;
        [self.listTableView reloadData];
        self.downLoadBtn.tintColor = [UIColor greenColor];
        [task start];
    }
    [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
        
//        NSLog(@"%ld",progress);
    } DidDownload:^(NSString *savePath, NSString *url) {
//        NSLog(@"file ===== %@",savePath);
        // 保存数据
        MusicDownloadTable *table = [[MusicDownloadTable alloc] init];
        for (DetailModel *flagModel in self.downloadArray) {
            if([flagModel.musicUrl isEqualToString:url]){
                flagModel.downloadType = DiDdwonload;
                [table createTable];
                [table insertIntoTable:@[flagModel.title,flagModel.musicUrl,flagModel.coverimg,savePath,flagModel.webview_url]];
            }
        }
        [self reloadViewWithIndex:[MyPlayerManager defaultManager].index];
        [self.listTableView reloadData];
    }];
}



// 加载播放界面
- (void)reloadViewWithIndex:(NSInteger)index{
    for (int i = 0; i < [MyPlayerManager defaultManager].musicLists.count; i++) {
        DetailModel *model = [MyPlayerManager defaultManager].musicLists[i];
        if (model.isPlay) {
            if (i != index) {
                model.isPlay = NO;
            }
        }
    }
    DetailModel *model = [MyPlayerManager defaultManager].musicLists[index];
    if (model.isPlay == NO) {
        model.isPlay = YES;
        [[MyPlayerManager defaultManager] changeMusicWith:index];
    } else{
        [[MyPlayerManager defaultManager] play];
    }
    [self.listTableView reloadData];
    [self loadWebView];
    if (model.downloadType == Downloadimg || model.downloadType == DownloadPause) {
        self.downLoadBtn.tintColor = [UIColor greenColor];
    } else if (model.downloadType == DiDdwonload){
        self.downLoadBtn.tintColor = [UIColor redColor];
    }else{
        self.downLoadBtn.tintColor = PKCOLOR(255, 255, 255);
    }
    self.downLoadBtn.tag = 1000 + [MyPlayerManager defaultManager].index;
    [self.blurView setBlurViewImage:model.coverimg];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.nameL.text = model.title;
    [self.imageV.layer addAnimation:self.animation forKey:nil];
}



// 定时器
-(void)timerAction{
    CGFloat total = [[MyPlayerManager defaultManager] totalTime];
    CGFloat current = [[MyPlayerManager defaultManager] currentTime];
    if (total == 0 || current == 0) {
        return;
    }
    self.slider.maximumValue = total;
    self.slider.value = current;
    CGFloat remain = total - current;
    self.allTimeL.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(NSInteger)remain/60,(NSInteger)remain % 60];
    if (current >= total) {
        [[MyPlayerManager defaultManager] playerDidFinish];
        [self reloadViewWithIndex:[MyPlayerManager defaultManager].index];
        [self.listTableView reloadData];
    }
}





//slider 滑动条
- (void)sliderAction:(UISlider *)slider{
    [[MyPlayerManager defaultManager] seekToSecondsWith:slider.value];
    [[MyPlayerManager defaultManager] play];
    [self.playAndPause setBackgroundImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    self.play = NO;
}




#pragma mark --- 上下首歌曲，和暂停-----
- (void)lastBtnAction:(UIButton *)btn{
    [[MyPlayerManager defaultManager] lastMusic];
    [self reloadViewWithIndex:[MyPlayerManager defaultManager].index];
}
- (void)playAndPauseBtnAction:(UIButton *)btn{
    if (self.play == NO) {
        [self.imageV.layer removeAllAnimations];
        [[MyPlayerManager defaultManager] pause];
        [self.playAndPause setBackgroundImage:[UIImage imageNamed:@"music_icon_play_highlighted"] forState:(UIControlStateNormal)];
    }else{
        [self.imageV.layer addAnimation:self.animation forKey:nil];
        [[MyPlayerManager defaultManager] play];
        [self.playAndPause setBackgroundImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    }
    self.play = !self.play;
}
- (void)nextBtnAction:(UIButton *)btn{
    
    [[MyPlayerManager defaultManager] nextMusic];
    [self reloadViewWithIndex:[MyPlayerManager defaultManager].index];
    
    
}





#pragma mark ----tableView 代理方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MyPlayerManager defaultManager].musicLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DetailModel *model = [MyPlayerManager defaultManager].musicLists[indexPath.row];
    [cell cellConfigureModel:model];
    cell.backgroundColor = [UIColor clearColor];
    cell.downLoadBtn.tag = 1000 + indexPath.row;
    [cell.downLoadBtn addTarget:self action:@selector(downLoadBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadViewWithIndex:indexPath.row];
    [self loadWebView];
}




// 滑动界面触发方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.bassScrollView.contentOffset.x == 0 && self.scroll == NO) {
        self.scroll = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[MyPlayerManager defaultManager].index inSection:0];
        [self.listTableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        self.pagOne.backgroundColor = [UIColor greenColor];
        self.pagTwo.backgroundColor = [UIColor lightGrayColor];
        self.pagThree.backgroundColor = [UIColor lightGrayColor];
    } else if (self.bassScrollView.contentOffset.x == kScreenWidth){
        self.scroll = NO;
        self.pagOne.backgroundColor = [UIColor lightGrayColor];
        self.pagTwo.backgroundColor = [UIColor greenColor];
        self.pagThree.backgroundColor = [UIColor lightGrayColor];
    } else if (self.bassScrollView.contentOffset.x == kScreenWidth *2){
        self.scroll = NO;
        self.pagOne.backgroundColor = [UIColor lightGrayColor];
        self.pagTwo.backgroundColor = [UIColor lightGrayColor];
        self.pagThree.backgroundColor = [UIColor greenColor];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
