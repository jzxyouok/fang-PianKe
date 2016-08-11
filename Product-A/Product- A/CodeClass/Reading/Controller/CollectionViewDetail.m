//
//  CollectionViewDetail.m
//  Product- A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectionViewDetail.h"
#import "CollectionVIewModel.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface CollectionViewDetail ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)UITableView *hotTableV;
@property(nonatomic,strong)UIScrollView *bassScrollView;
@property(nonatomic,strong)UIView *indicateView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableArray *hotListModelArray;
@property(nonatomic,strong)UIButton *newsBtn;
@property(nonatomic,strong)UIButton *hotBtn;
@property(nonatomic,assign)BOOL sortType;
@property(nonatomic,assign)BOOL isHot;
@property(nonatomic,assign)NSInteger startNew;
@property(nonatomic,assign)NSInteger startHot;
@end

@implementation CollectionViewDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bassScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 70)];
    self.bassScrollView.contentSize = CGSizeMake(kScreenWidth * 2, CGRectGetHeight(_bassScrollView.frame));
    self.bassScrollView.delegate = self;
    self.bassScrollView.pagingEnabled = YES;
    [self.view addSubview:self.bassScrollView];
    [self.bassScrollView addSubview:self.tableV];
    [self.bassScrollView addSubview:self.hotTableV];
    
    
    [self.view addSubview:self.indicateView];
    [self.view addSubview:self.newsBtn];
    [self.view addSubview:self.hotBtn];
        
    __weak CollectionViewDetail *weakSelf = self;
    _isHot = NO;
    //new
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.modelArray removeAllObjects];
        _sortType = YES;
        _startNew = 0;
        [weakSelf requestDataWithSort:@"addtime" start:_startNew];
    }];
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _sortType = YES;
        _startNew += 10;
        [weakSelf requestDataWithSort:@"addtime" start:_startNew];
    }];
    // hot
    self.hotTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.hotListModelArray removeAllObjects];
        _sortType = NO;
        _startNew = 0;
        _isHot = YES;
        [weakSelf requestDataWithSort:@"hot" start:_startNew];
    }];
    self.hotTableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _sortType = NO;
        _startNew += 10;
        [weakSelf requestDataWithSort:@"hot" start:_startNew];
    }];
    [self.tableV.mj_header beginRefreshing];
}



#pragma mark --------- 属性 ---------
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)hotListModelArray{
    if (!_hotListModelArray) {
        _hotListModelArray = [NSMutableArray array];
    }
    return _hotListModelArray;
}


- (UIButton *)newsBtn{
    if (!_newsBtn) {
        _newsBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _newsBtn.frame = CGRectMake(kScreenWidth/2.0 + 30, 35, 40, 20);
        [_newsBtn setTitle:@"NEW" forState:(UIControlStateNormal)];
        _newsBtn.backgroundColor = [UIColor blackColor];
        [_newsBtn setTintColor:[UIColor whiteColor]];
        [_newsBtn addTarget:self action:@selector(newsBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _newsBtn;
}


- (UIButton *)hotBtn{
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _hotBtn.frame = CGRectMake(kScreenWidth/2.0 + 100, 35, 40, 20);
        _hotBtn.backgroundColor = [UIColor lightGrayColor];
        [_hotBtn setTitle:@"HOT" forState:(UIControlStateNormal)];
        [_hotBtn setTintColor:[UIColor whiteColor]];
        [_hotBtn addTarget:self action:@selector(hotBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hotBtn;
}



- (UIView *)indicateView{
    if (!_indicateView) {
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0 + 30, 69, 40, 1)];
        _indicateView.backgroundColor = [UIColor blackColor];
    }
    return _indicateView;
}



- (UITableView *)hotTableV{
    if (!_hotTableV) {
        _hotTableV = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 70) style:(UITableViewStylePlain)];
        _hotTableV.delegate = self;
        _hotTableV.dataSource = self;
        _hotTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_hotTableV registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _hotTableV;
}


- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 70) style:(UITableViewStylePlain)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableV registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableV;
}



- (void)requestDataWithSort:(NSString *)sort start:(NSInteger )start{
    NSMutableDictionary *parDic = [@{@"limit":@"10",@"start":[NSString stringWithFormat:@"%ld",(long)start],@"sort":sort,@"typeid":[NSString stringWithFormat:@"%@",self.type]} mutableCopy];
    [RequestManager requestWithUrlString:kReadCollection parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSMutableArray *array = [CollectionVIewModel modelWithJSONDic:dict];
        for (CollectionVIewModel *model in array) {
            if (_sortType == YES) {
                [self.modelArray addObject:model];
            }else if (_sortType == NO) {
                [self.hotListModelArray addObject:model];
            }
        }
        if (_sortType == YES) {
            [self.tableV reloadData];
        } else if (_sortType == NO){
            [self.hotTableV reloadData];
        }
        [self.hotTableV.mj_footer endRefreshing];
        [self.hotTableV.mj_header endRefreshing];
        [self.tableV.mj_footer endRefreshing];
        [self.tableV.mj_header endRefreshing];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sortType == YES ? self.modelArray.count : self.hotListModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CollectionVIewModel *model = nil;
    if (_sortType == YES) {
        model = self.modelArray[indexPath.row];
    } else if (_sortType == NO){
        model = self.hotListModelArray[indexPath.row];
    }
    [cell cellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionVIewModel *model = nil;
    if (_sortType == YES) {
        model = self.modelArray[indexPath.row];
    } else if (_sortType == NO){
        model = self.hotListModelArray[indexPath.row];
    }
    CGFloat h = [AutoAdjustHeight adjustHeightByString:model.title width:kScreenWidth - 60 font:20];
    return h + 130;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionVIewModel *model = nil;
    if (_sortType == YES) {
        model = self.modelArray[indexPath.row];
    } else if (_sortType == NO){
        model = self.hotListModelArray[indexPath.row];
    }
    DetailViewController *articleDetail = [[DetailViewController alloc] init];
    articleDetail.contendid = model.contentId;
    articleDetail.covimg = model.coverimg;
    [self.navigationController pushViewController:articleDetail animated:YES];
}










- (void)newsBtnAction:(UIButton *)btn {
    _newsBtn.backgroundColor = [UIColor blackColor];
    _hotBtn.backgroundColor = [UIColor lightGrayColor];
    [_bassScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)hotBtnAction:(UIButton *)btn{
    _newsBtn.backgroundColor = [UIColor lightGrayColor];
    _hotBtn.backgroundColor = [UIColor blackColor];
    [_bassScrollView setContentOffset:CGPointMake(_bassScrollView.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
        if (scrollView.contentOffset.x == scrollView.width && _isHot == NO) {
            [self.hotTableV.mj_header beginRefreshing];
        }
        CGPoint newCenter = _indicateView.center;
        if (scrollView.contentOffset.x == 0) {
            _newsBtn.backgroundColor = [UIColor blackColor];
            _hotBtn.backgroundColor = [UIColor lightGrayColor];
            newCenter.x = _newsBtn.center.x;
        }else if (scrollView.contentOffset.x == scrollView.width){
            _newsBtn.backgroundColor = [UIColor lightGrayColor];
            _hotBtn.backgroundColor = [UIColor blackColor];
            newCenter.x = _hotBtn.center.x;
        }

        CGFloat distance = _hotBtn.center.x - _newsBtn.center.x;
        CGFloat scale = scrollView.contentOffset.x/scrollView.width;
        _indicateView.center = CGPointMake(_newsBtn.center.x + distance * scale, _indicateView.center.y);
    }
}








@end
