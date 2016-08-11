//
//  ViewController.m
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "RadioViewController.h"
#import "carouselModel.h"
#import "ColloctionModel.h"
#import "CollectionViewCell.h"
#import "tabelViewModel.h"
#import "MyTableViewCell.h"
#import "RadioDetailViewController.h"
#import "DetailModel.h"

@interface RadioViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *carouselAarray;
@property(nonatomic,strong)NSMutableArray *colloctionViewArray;
@property(nonatomic,strong)UICollectionView *collectoonView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *tabelArray;
@property(nonatomic,assign)NSInteger start;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *headView;
@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self carsoureAndColloctionJson];
    [self setColloctionView];
    [self setTabelView];
//    [self.view removeGestureRecognizer:self.tap];
}


#pragma mark --- 属性 ----------
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 30) / 3.0 + 230)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenWidth - 30) / 3.0 +15+160+10, 200, 30)];
        label.text = @"全部电台  ALL Radios";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [_headView addSubview:label];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(150, (kScreenWidth - 30) / 3.0 +15+160+25, 300, 1)];
        view1.backgroundColor = [UIColor grayColor];
        [_headView addSubview:view1];
    }
    return _headView;
}


- (NSMutableArray *)carouselAarray{
    if (_carouselAarray == nil) {
        _carouselAarray = [NSMutableArray array];
    }
    return _carouselAarray;
}

- (NSMutableArray *)colloctionViewArray{
    if (_colloctionViewArray == nil) {
        _colloctionViewArray = [NSMutableArray array];
    }
    return _colloctionViewArray;
}

- (NSMutableArray *)tabelArray{
    if (_tabelArray == nil) {
        _tabelArray = [NSMutableArray array];
    }
    return _tabelArray;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 2);
        _scrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _scrollView;
}




#pragma mark ------- 轮播图 ----------
- (void)carsoureAndColloctionJson{
    [RequestManager requestWithUrlString:kURL1 parDic:nil requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        self.carouselAarray = [carouselModel carouselModelConfigureJson:dic];
        [self carousel];
        
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

- (void)carousel{
    NSMutableArray *array = [NSMutableArray array];
    for (carouselModel *model  in self.carouselAarray) {
        [array addObject:model.img];
    }
    CarouselView *carousel = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160) imageURLs:array];
    carousel.imageClick = ^(NSInteger index){
        carouselModel *model = self.carouselAarray[index];
        RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
        radioDetailVC.radioid = model.radioid;
        [self.navigationController pushViewController:radioDetailVC animated:YES];
    };
    [self.headView addSubview:carousel];
}


#pragma mark -------- collectionView ------
- (void)setColloctionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth - 30) / 3.0, (kScreenWidth - 30) / 3.0);
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectoonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 160, kScreenWidth, (kScreenWidth - 30) / 3.0 +15) collectionViewLayout:layout];
    self.collectoonView.delegate = self;
    self.collectoonView.dataSource = self;
    self.collectoonView.backgroundColor = [UIColor whiteColor];
    [self.collectoonView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.headView addSubview:self.collectoonView];
    
    [RequestManager requestWithUrlString:kURL1 parDic:nil requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        self.colloctionViewArray = [ColloctionModel modelConfigureJsonDic:dic];
        [self.collectoonView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}



#pragma mark - - - -----tabeleView - -- - -- --
- (void)setTabelView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"123"];
    self.tableView.rowHeight = 110;
    self.start = 0;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.start += 10;
        [self loadMoreData];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [self.tabelArray removeAllObjects];
        self.start = 0;
        [self loadMoreData];
    }];
    [self loadData];
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    
}

- (void)loadData{
    [RequestManager requestWithUrlString:kURL1 parDic:nil requestType:RequestGET finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        self.tabelArray = [tabelViewModel modelConfigureJsonDic:dic];
        [self.tableView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}


#pragma mark -------- 上拉加载更多 ----------
- (void)loadMoreData{
    NSDictionary *parDic = @{@"auth":@"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo",@"client":@"1",@"deviceid":@"6D4DD967-5EB2-40E2- A202-37E64F3BEA31",@"limit":@"10",@"start":[NSString stringWithFormat:@"%ld",(long)self.start],@"version":@"3.0.6"};
    [RequestManager requestWithUrlString:kURL2 parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSArray *array = [tabelViewModel modelConfigureJsonDicMore:dic];
        for (tabelViewModel *model in array) {
            [self.tabelArray addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];

}





//colletionView 的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colloctionViewArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ColloctionModel *model = self.colloctionViewArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ColloctionModel *model = self.colloctionViewArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.radioid = model.radioid;
    [self.navigationController pushViewController:radioDetailVC animated:YES];
}


//tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] init];
    }
    tabelViewModel *model = self.tabelArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.unameL.text = [NSString stringWithFormat:@"by:%@",model.uname];
    cell.nameL.text = model.title;
    cell.descL.text = model.desc;
    cell.count.text = [NSString stringWithFormat:@"%@",model.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tabelViewModel *model = self.tabelArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.radioid = model.radioid;
    [self.navigationController pushViewController:radioDetailVC animated:YES];
}




@end
