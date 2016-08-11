//
//  RadioDetailViewController.m
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "DetailModel.h"
#import "detailTableViewCell.h"
#import "musicViewController.h"

@interface RadioDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, nonnull,strong)NSMutableArray *modelArray;
@property(nonatomic,assign)NSInteger strat;
@property(nonatomic,strong)UIView *headView;
@end

@implementation RadioDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.view removeGestureRecognizer:self.tap];
    
    
    [self.view addSubview:self.tableView];
    [self.headView addSubview:self.imageV];
    [self.headView addSubview:self.icon];
    [self.headView addSubview:self.uname];
    [self.headView addSubview:self.desc];
    [self.headView addSubview:self.count];
    [self.headView addSubview:self.wifi];
    [self loadData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.strat += 10;
        [self loadMoreData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.strat = 0;
        [self loadMoreData];
    }];
}





- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69)style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"detailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 100.0;
    }
    return _tableView;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    }
    return _imageV;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 180, 30, 30)];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 15.0;
    }
    return _icon;
}
- (UILabel *)uname{
    if (!_uname) {
        _uname = [[UILabel alloc] initWithFrame:CGRectMake(65, 188, 150, 20)];
        _uname.font = [UIFont systemFontOfSize:15];
        _uname.textColor = PKCOLOR(166, 179, 194);
    }
    return _uname;
}

- (UIImageView *)wifi{
    if (!_wifi) {
        _wifi = [[UIImageView alloc] initWithFrame:CGRectMake(self.count.left - 15, self.count.top, 15, 20)];
        _wifi.image = [UIImage imageNamed:@"WiFi"];
    }
    return _wifi;
}

-(UILabel *)desc{
    if (!_desc) {
        _desc = [[UILabel alloc] initWithFrame:CGRectMake(25, 230, kScreenWidth - 50, 20)];
        _desc.font = [UIFont systemFontOfSize:14];
        _desc.textColor = [UIColor grayColor];
    }
    return _desc;
}

- (UILabel *)count{
    if (!_count) {
        _count = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 180, 80, 20)];
        _count.font = [UIFont systemFontOfSize:12];
        _count.textColor = PKCOLOR(200, 200, 200);
    }
    return _count;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}




-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    }
    return _headView;
}





- (void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)showRootVC:(UIButton *)btn{
}


- (void)loadData{
    NSDictionary *parDic = @{@"radioid":self.radioid};
    [RequestManager requestWithUrlString:kRadioDetailList parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        self.modelArray = [DetailModel modelWithJson:dic];
        [self.tableView reloadData];
        [self getValueWithDic:dic];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

- (void)loadMoreData{
    NSDictionary *parDic = @{@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo",@"client":@"1",@"deviceid":@"6D4DD967-5EB2-40E2-A202-37E64F3BEA31",@"limit":@"10",@"radioid":[NSString stringWithFormat:@"%@",self.radioid],@"start":[NSString stringWithFormat:@"%ld",(long)self.strat],@"version":@"3.0.6"};
    [RequestManager requestWithUrlString:kRadioDetailListMore parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSMutableArray *array = [DetailModel modelWithJson:dic];
        for (DetailModel *model in array) {
        [self.modelArray addObject:model];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}


- (void)getValueWithDic:(NSDictionary *)dic{
    self.titleLabel.text = dic[@"data"][@"radioInfo"][@"title"];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"radioInfo"][@"coverimg"]]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"radioInfo"][@"userinfo"][@"icon"]]];
    self.uname.text = dic[@"data"][@"radioInfo"][@"userinfo"][@"uname"];
    self.desc.text = dic[@"data"][@"radioInfo"][@"desc"];
    self.count.text = [NSString stringWithFormat:@"%@",dic[@"data"][@"radioInfo"][@"musicvisitnum"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DetailModel *model = self.modelArray[indexPath.row];
    [cell cellWithModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    musicViewController *music = [[musicViewController alloc] init];
    [MyPlayerManager defaultManager].index = indexPath.row;
    [MyPlayerManager defaultManager].musicLists = self.modelArray;
    [self.navigationController pushViewController:music animated:YES];
}




@end
