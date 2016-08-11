//
//  PridectViewController.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "PridectViewController.h"
#import "ProductModel.h"
#import "ProductTableViewCell.h"
#import "ProductDetailViewController.h"

@interface PridectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,assign)NSInteger start;

@end

@implementation PridectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    [self loadData];
    self.start = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.modelArray removeAllObjects];
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.start += 10;
        [self loadData];
    }];
}

#pragma mark ----- 属性 ----
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = (kScreenHeight - 69 - 80)/2;
        [_tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"productCell"];
    }
    return _tableView;
}


- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}


- (void)loadData{
    NSDictionary *parDic = @{@"start":[NSString stringWithFormat:@"%ld",self.start],@"limit":@"10"};
    [RequestManager requestWithUrlString:kProduct parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSArray *arr = [ProductModel modelWithConfigure:dic];
        for (ProductModel *model in arr) {
            [self.modelArray addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}





#pragma mark --- --tableView 代理方法 ------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    [cell.butBtn addTarget:self action:@selector(buyAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.butBtn.tag = 1000 + indexPath.row;
    ProductModel *model = self.modelArray[indexPath.row];
    [cell cellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    ProductModel *model = self.modelArray[indexPath.row];
    detailVC.contentid = model.contentid;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark --------- 购买 --------
- (void)buyAction:(UIButton *)btn{
    ProductModel *model = self.modelArray[btn.tag - 1000];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.buyurl]];
    //这个方法可以直接跳转到浏览器。良品的界面只有这么一个方法。
}


@end
