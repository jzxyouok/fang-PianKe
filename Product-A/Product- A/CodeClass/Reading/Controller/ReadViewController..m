//
//  ReadViewController.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadModel.h"
#import "ReadCollectionViewCell.h"
#import "DetailViewController.h"
#import "CollectionViewDetail.h"

@interface ReadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableArray *collectionViewArr;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation ReadViewController

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (NSMutableArray *)collectionViewArr{
    if (!_collectionViewArr) {
        _collectionViewArr = [NSMutableArray array];
    }
    return _collectionViewArr;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAnalysis];
    [self getCollectionView];
}


- (void)getAnalysis{
    [RequestManager requestWithUrlString:kReadList parDic:nil requestType:RequestGET finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        self.modelArray = [ReadModel stringArrayWithDic:dic];
        [self getCarouselView];
        self.collectionViewArr = [ReadModel modelConfigureDic:dic];
        [self.collectionView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}

- (void)getCarouselView{
    NSMutableArray *array = [NSMutableArray array];
    for (ReadModel *model in self.modelArray) {
        [array addObject:model.img];
    }
    CarouselView *carouseView = [[CarouselView alloc] initWithFrame:CGRectMake(0 , 69, kScreenWidth, kScreenHeight - kScreenWidth - 69) imageURLs:array];
    carouseView.imageClick = ^(NSInteger index) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        ReadModel *model = self.modelArray[index];
        detailVC.covimg = model.img;
        detailVC.url = model.url;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    
 
    
    [self.view addSubview:carouseView];
}



- (void)getCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake((kScreenWidth - 30)/3.0,(kScreenWidth - 30)/3.0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kScreenWidth, kScreenWidth, kScreenWidth + 10) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ReadCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}


- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    animation.cumulative = YES;
    animation.repeatCount = 2;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1.0, 0)];
    [cell.layer addAnimation:animation forKey:nil];

    ReadModel *model = self.collectionViewArr[indexPath.row];
    [cell cellConfigureModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewDetail *collectionVC = [[CollectionViewDetail alloc] init];
    ReadModel *model = self.collectionViewArr[indexPath.row];
    collectionVC.titleLabel.text = model.name;
    collectionVC.type = model.type;
    [self.navigationController pushViewController:collectionVC animated:YES];
    
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
