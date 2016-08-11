//
//  RootViewController.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//
#define kCAGradientLayerH (kScreenHeight/3.0)
#import "RootViewController.h"
#import "RightViewController.h"
#import "DetailModel.h"
#import "downloadListViewController.h"
#import "UserView.h"
#import "LoginViewController.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSArray *controllers;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)RightViewController *rightVC;
@property(nonatomic,strong)UINavigationController *myNaviVC;
@property(nonatomic,assign)BOOL play;
@property(nonatomic,strong)UIButton *login;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UITableView *userTableView;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,assign)BOOL userInfo;
@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBottomView];
    [self initGradientLayer];
    
//    UserView *suerV = [[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil].firstObject;
//    suerV.frame = CGRectMake(0, 20, kScreenWidth - kMoveDistance, kCAGradientLayerH);
//    [self.view addSubview:suerV];
    
    [self initHeardView];
    [self initTableView];
    [self.view addSubview:self.userTableView];
    
}

- (UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*2/5.0 - 58, 85, 200, 0) style:(UITableViewStylePlain)];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        [_userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rootCell"];
        _userTableView.rowHeight = 30;
        _userTableView.backgroundColor = [UIColor clearColor];
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.frame = CGRectMake(0, 0, 200, 30);
        [btn setTitle:@"添加其他账号" forState:(UIControlStateNormal)];
        btn.tintColor = [UIColor blackColor];
        [btn addTarget:self action:@selector(addLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:btn];
        _userTableView.tableHeaderView = view;
    }
    return _userTableView;
}



- (void)initHeardView{
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 60, 60)];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 30;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]]];
    } else{
        self.imageV.image = [UIImage imageNamed:@"navbar_icon_user_normal"];
    }
    [self.view addSubview:self.imageV];
    self.login = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.login.frame =CGRectMake(kScreenWidth*2/5.0 - 58, 55, 200, 30);
    self.login.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.login addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        [self.login setTitle:[UserInfoManager getUserName] forState:(UIControlStateNormal)];
    } else{
        [self.login setTitle:@"登入  |  注册" forState:(UIControlStateNormal)];
    }
    [self.login setTintColor:PKCOLOR(255, 255, 255)];
    [self.view addSubview:self.login];
    
    UIButton *download = [UIButton buttonWithType:(UIButtonTypeSystem)];
    download.frame =CGRectMake(kScreenWidth/2.0 - 120, 120, 22, 22);
    [download setImage:[UIImage imageNamed:@"downloading_updates"] forState:(UIControlStateNormal)];
//    download.backgroundColor = [UIColor whiteColor];
    [download addTarget:self action:@selector(downloadAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [download setTintColor:PKCOLOR(255, 255, 255)];
    [self.view addSubview:download];
    
    UIButton *heartsBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [heartsBtn setImage:[UIImage imageNamed:@"hearts"] forState:(UIControlStateNormal)];
    heartsBtn.frame = CGRectMake(kScreenWidth/2.0 - 65, 118, 25, 25);
    [heartsBtn setTintColor:PKCOLOR(255, 255, 255)];
    [self.view addSubview:heartsBtn];
    
    UIButton *comment = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [comment setImage:[UIImage imageNamed:@"SMS_filled"] forState:(UIControlStateNormal)];
    comment.frame = CGRectMake(kScreenWidth/2.0 - 10, 118, 25, 25);
    [comment setTintColor:PKCOLOR(255, 255, 255)];
    [self.view addSubview:comment];
    
    UIButton *edit = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [edit setImage:[UIImage imageNamed:@"marker_pen"] forState:(UIControlStateNormal)];
    edit.frame = CGRectMake(kScreenWidth/2.0 + 45, 120, 22, 22);
    [edit setTintColor:PKCOLOR(255, 255, 255)];
    [self.view addSubview:edit];
    
    UserView *userV = [[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil].firstObject;
    userV.textF.delegate = self;
    userV.tag = 100;
    userV.frame = CGRectMake(28, 160, kScreenWidth/2.0 + 42, 34);
    userV.backgroundColor = PKCOLOR(150, 150, 150);
    [self.view addSubview:userV];
    
    
    
}


- (void)downloadAction:(UIButton *)btn{
    downloadListViewController *downloadList = [[downloadListViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:downloadList];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)loginAction:(UIButton *)btn{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        self.userInfo = YES;
        [self.userTableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.userTableView.frame = CGRectMake(kScreenWidth*2/5.0 - 58, 85, 200, 120);
        }];
    } else{
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *naVC =[[UINavigationController alloc] initWithRootViewController:login];
        login.resultBlock = ^(NSString *name){
            [self.login setTitle:name forState:(UIControlStateNormal)];
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]]];
        };
        [self presentViewController:naVC animated:YES completion:nil];
    }
}




- (void)initGradientLayer{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = CGRectMake(0, 20, kScreenWidth, kCAGradientLayerH);
    gradientLayer.colors = @[(id)PKCOLOR(180, 180, 180).CGColor,(id)PKCOLOR(100, 90, 100).CGColor,(id)PKCOLOR(40, 40, 40).CGColor];
    [self.view.layer addSublayer:gradientLayer];
}



- (void)initTableView{
    _controllers = @[@"RadioViewController",@"ReadViewController",@"CommmeunityViewController",@"PridectViewController",@"SettingViewController"];
    _titles = @[@"电台",@"阅读",@"社区",@"良品",@"设置"];
    _images = @[@"lightning_bolt",@"folder",@"date",@"wine_glass",@"face_e"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + kCAGradientLayerH, kScreenWidth, kScreenHeight - 20 - 64 - kCAGradientLayerH) style:(UITableViewStylePlain)];
    tableView.backgroundColor = PKCOLOR(80, 80, 80);
    tableView.rowHeight = tableView.height / _titles.count;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rootCell"];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _rightVC = [[NSClassFromString(_controllers[0]) alloc] init];
    _rightVC.titleLabel.text = _titles[0];
    _myNaviVC = [[UINavigationController alloc] initWithRootViewController:_rightVC];
    _myNaviVC.navigationBar.hidden = YES;
    [self.view addSubview:_myNaviVC.view];
}

- (void)initBottomView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth * 4 / 5.0, 64)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 22;
    [view addSubview:imageV];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(64, 15, kScreenWidth*4/5.0 - 40-69, 25)];
    titleL.textColor = [UIColor whiteColor];
    [view addSubview:titleL];
    UILabel *unameL = [[UILabel alloc] initWithFrame:CGRectMake(64, 40, 80, 10)];
    unameL.font = [UIFont systemFontOfSize:13];
    unameL.textColor = [UIColor whiteColor];
    [view addSubview:unameL];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame = CGRectMake(kScreenWidth*4/5.0 - 40, 20, 30, 30);
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    [MyPlayerManager defaultManager].resultBlock = ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.duration = 10;
        animation.repeatCount = MAXFLOAT;
        [imageV.layer addAnimation:animation forKey:nil];
        NSInteger index = [MyPlayerManager defaultManager].index;
        DetailModel *model = [MyPlayerManager defaultManager].musicLists[index];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
        titleL.text = model.title;
        unameL.text = model.uname;
        [btn setBackgroundImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    };
    view.backgroundColor = PKCOLOR(40, 40, 40);
    [self.view addSubview:view];
}
- (void)btnAction:(UIButton *)btn{
    if (self.play == NO) {
        [[MyPlayerManager defaultManager] pause];
        [btn setBackgroundImage:[UIImage imageNamed:@"music_icon_play_highlighted"] forState:(UIControlStateNormal)];
    }else{
        [[MyPlayerManager defaultManager] play];
        [btn setBackgroundImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    }
    self.play = !self.play;
}






#pragma mark --- tableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.userInfo) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        return dic.count;
    } else{
        return _titles.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userInfo) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootCell" forIndexPath:indexPath];
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSArray *allkeys = [dic allKeys];
        cell.textLabel.text = allkeys[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootCell" forIndexPath:indexPath];
        cell.textLabel.text = _titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
        cell.textLabel.textColor = PKCOLOR(80, 80, 80);
        cell.textLabel.font = [UIFont systemFontOfSize:cell.height / 3.0];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        cell.backgroundColor = PKCOLOR(40, 40, 40);
        if (cell.selected == YES) {
            cell.textLabel.textColor = PKCOLOR(240, 240, 240);
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.userInfo) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSArray *allkeys = [dic allKeys];
        NSDictionary *parDic = @{@"email":allkeys[indexPath.row],@"passwd":[dic[allkeys[indexPath.row]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
        [RequestManager requestWithUrlString:kLoginUrl parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
                [self.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"icon"]]];
                [self.login setTitle:dic[@"data"][@"uname"] forState:(UIControlStateNormal)];
                [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
                [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
                [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
                [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
            [UIView animateWithDuration:0.5 animations:^{
                self.userTableView.frame = CGRectMake(kScreenWidth*2/5.0 - 58, 85, 200, 0);
            }];
            self.userInfo = NO;
        } error:^(NSError *error) {
//            NSLog(@"%@",error);
        }];
    } else{
        cell.textLabel.textColor = PKCOLOR(240, 240, 240);
        if ([_rightVC isMemberOfClass:[NSClassFromString(_controllers[indexPath.row]) class]]) {
//            NSLog(@"重复点击");
            [_rightVC ChangeFrameWithType:MOVETYPELEFT];
            return;
        }
        [_myNaviVC.view removeFromSuperview];
        _rightVC = [[NSClassFromString(_controllers[indexPath.row]) alloc] init];
   
        _rightVC.titleLabel.text = _titles[indexPath.row];
        _myNaviVC = [[UINavigationController alloc] initWithRootViewController:_rightVC];
        _myNaviVC.navigationBar.hidden = YES;
        [self.view addSubview:_myNaviVC.view];
    
        CGRect newFrame = _myNaviVC.view.frame;
        newFrame.origin.x = kScreenWidth - kMoveDistance;
        _myNaviVC.view.frame = newFrame;
        [_rightVC ChangeFrameWithType:MOVETYPELEFT];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = PKCOLOR(80, 80, 80);
    cell.backgroundColor = PKCOLOR(40, 40, 40);
}



- (void)addLoginAction:(UIButton *)btn{
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *naVC =[[UINavigationController alloc] initWithRootViewController:login];
    login.resultBlock = ^(NSString *name){
        [self.login setTitle:name forState:(UIControlStateNormal)];
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]]];
        [UIView animateWithDuration:0.5 animations:^{
            self.userTableView.frame = CGRectMake(kScreenWidth*2/5.0 - 58, 85, 200, 0);
        }];
        self.userInfo = NO;
    };
    [self presentViewController:naVC animated:YES completion:nil];
}


#pragma mark  -------- 回收键盘 ----
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UserView *view = [self.view viewWithTag:100];
    [view.textF resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.userTableView.frame = CGRectMake(kScreenWidth*2/5.0 - 58, 85, 200, 0);
    }];
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    if (point.x > kScreenWidth*2/5.0 - 58  && point.x < kScreenWidth*4/5.0 - 50 && point.y > 85 && point.y < 205 ) {
    } else{
        self.userInfo = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end