//
//  CommmeunityViewController.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommmeunityViewController.h"
#import "TopicModel.h"
#import "TopicTableViewCell.h"
#import "TopicTableViewCell2.h"
#import "TopicDetailViewController.h"

@interface CommmeunityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,assign )NSInteger start;
@property(nonatomic,strong)UISegmentedControl *seg;
@property(nonatomic,strong)NSString *sort;
@end

@implementation CommmeunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.seg];
    self.sort = @"hot";
    [self loadData];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.modelArray removeAllObjects];
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.start += 10;
        [self loadData];
    }];
}



#pragma mark - - ------ shuxing  ------
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 119, kScreenWidth, kScreenHeight - 69) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"topicCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell2" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"topicCell2"];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UISegmentedControl *)seg{
    if (!_seg) {
        NSArray *array = @[@"Hot",@"New"];
        _seg = [[UISegmentedControl alloc] initWithItems:array];
        _seg.frame = CGRectMake(kScreenWidth/2.0 - 60 , 79, 120, 30);
        _seg.tintColor = [UIColor blackColor];
        _seg.selectedSegmentIndex = 0;
        [_seg addTarget:self action:@selector(segAction:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _seg;
}

#pragma mark --------数据解析-----------
- (void)loadData{
    NSDictionary *parDic = @{@"sort":self.sort,@"start":[NSString stringWithFormat:@"%ld",self.start],@"limit":@"10"};
    [RequestManager requestWithUrlString:kTopic parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSMutableArray *array = [TopicModel modelConfigureJsonDic:dic];
        for (TopicModel *model in array) {
            [self.modelArray addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- tableView 代理方法 -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel *model = self.modelArray[indexPath.row];
    if ([model.coverimg isEqualToString:@""]) {
        TopicTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell2" forIndexPath:indexPath];
        [cell cellConfigureModel:model];
        return cell;
    } else{
        TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
        [cell cellConfigureModel:model];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel *model = self.modelArray[indexPath.row];
    if ([model.coverimg isEqualToString:@""]) {
        CGFloat titleH = [AutoAdjustHeight adjustHeightByString:model.title width:kScreenWidth - 20-20 font:20];
        CGFloat contentH = [AutoAdjustHeight adjustHeightByString:model.content width:kScreenWidth - 20*2 font:15];
        return 20 + titleH + 20 + contentH + 17 + 20 + 17;
    }
    CGFloat titleH = [AutoAdjustHeight adjustHeightByString:model.title width:kScreenWidth - 20-20 font:20];
    return 20 + titleH + 20 + 80 + 17 + 20 + 17;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicDetailViewController *topicVC = [[TopicDetailViewController alloc] init];
    topicVC.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:topicVC animated:YES];
}

#pragma mark --------- Button 的点击方法 ---------
- (void)segAction:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        self.sort = @"hot";
        [self.tableView.mj_header beginRefreshing];
    } else{
        self.sort = @"addtime";
        [self.tableView.mj_header beginRefreshing];
    }
}



@end
