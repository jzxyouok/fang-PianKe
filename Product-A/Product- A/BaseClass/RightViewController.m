//
//  RightViewController.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//
#import "RightViewController.h"

@interface RightViewController ()<UIGestureRecognizerDelegate>

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.button];
    [self.view addGestureRecognizer:self.tap];
    [self.view addGestureRecognizer:self.pan];
    
    UIView *vertical = [[UIView alloc]initWithFrame:CGRectMake(49, 20, 1, KNaviH)];
    vertical.backgroundColor = PKCOLOR(100, 100, 100);
    [self.view addSubview:vertical];
    
    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 19 + KNaviH, kScreenWidth, 1)];
    horizontal.backgroundColor = PKCOLOR(10, 10, 10);
    [self.view addSubview:horizontal];
    
    self.screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithFinger:)];
    self.screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.screenEdgePan];
    
    self.tap.delegate=self;
}


#pragma mark ---属性
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _button.frame = CGRectMake(5, 20 + 5, 40, 40);
        [_button  setImage:[UIImage imageNamed:@"navigation_icon"]  forState:(UIControlStateNormal)];
        [_button setTintColor:PKCOLOR(40, 40, 40)];
        [_button addTarget:self action:@selector(showRootVC:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20 + 15, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = PKCOLOR(25, 25, 25);
    }
    return _titleLabel;
}

// 轻拍手势
- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRootVC:)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panShowRootVC:)];
        _pan.enabled = NO;
    }
    return _pan;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
        
    }
    if ([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}


#pragma mark --- 抽屉
- (void)showRootVC:(UIButton *)button{
    [self ChangeFrameWithType:MOVETYPERIGHT];
}

- (void)hideRootVC:(UITapGestureRecognizer *)tap{
    [self ChangeFrameWithType:MOVETYPELEFT];
}



- (void)panShowRootVC:(UIPanGestureRecognizer *)pan{
    [self gestureRecognizer:pan];
}
// 屏幕边缘移手势
- (void)panWithFinger:(UIScreenEdgePanGestureRecognizer *)sender{
    [self gestureRecognizer:sender];
}


- (void)gestureRecognizer:(UIGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.navigationController.view.superview];
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.origin.x = point.x;
    if (newFrame.origin.x >= kScreenWidth - kMoveDistance) {
        newFrame.origin.x = kScreenWidth - kMoveDistance;
    }else if (newFrame.origin.x <= 0){
        newFrame.origin.x = 0;
    }
    self.navigationController.view.frame = newFrame;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (point.x > kScreenWidth / 2.0) {
            [self ChangeFrameWithType:MOVETYPERIGHT];
        } else{
            [self ChangeFrameWithType:MOVETYPELEFT];
        }
    }
}



- (void)ChangeFrameWithType:(MOVETYPE)type{
    CGRect newFrame = self.navigationController.view.frame;
    if (type == MOVETYPELEFT) {
        newFrame.origin.x = 0;
        self.tap.enabled = NO;
        self.button.enabled = YES;
        self.pan.enabled = NO;
        self.flag = NO;
    } else if (type == MOVETYPERIGHT ) {
        newFrame.origin.x = kScreenWidth - kMoveDistance;
        // 给动画0.5s
        self.tap.enabled = YES;
        self.button.enabled = NO;
        self.pan.enabled = YES;
        self.flag = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.frame = newFrame;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
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
