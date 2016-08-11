//
//  SecondViewController.m
//  A段
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 tongwei. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    
    // Do any additional setup after loading the view.
}


-(void)initNavigationBar{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [button setTitleColor:PKCOLOR(40, 40, 40) forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(popVC:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(KNaviH, 20, 1, KNaviH)];
    verticalLine.backgroundColor = PKCOLOR(200, 200, 200);
    [self.view addSubview:verticalLine];
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, KNaviH + 19, kScreenWidth, 1)];
    horizontalLine.backgroundColor = PKCOLOR(200, 200, 200);
    [self.view addSubview:horizontalLine];
    [self.view addSubview:self.titleLabel];
}

-(void)popVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + 10, 20 + 20, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = PKCOLOR(25, 25, 25);
    }
    return _titleLabel;
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
