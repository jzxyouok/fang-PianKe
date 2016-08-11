//
//  downloadListViewController.m
//  Product- A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "downloadListViewController.h"
#import "MusicDownloadTable.h"
#import "DetailModel.h"
#import "musicViewController.h"
#import "downloadTableViewCell.h"
#import "bottomView.h"

@interface downloadListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)bottomView *bottomView;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,assign)BOOL isAllSelect;
@property(nonatomic,strong)UIButton *editBtn;
@end

@implementation downloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view removeGestureRecognizer:self.pan];
    [self.view removeGestureRecognizer:self.screenEdgePan];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.tableView];
    MusicDownloadTable *dTable = [[MusicDownloadTable alloc] init];
    NSArray *array = [dTable selectAll];
    for (NSArray* arr in array) {
        DetailModel *model = [[DetailModel alloc ] init];
        model.coverimg = arr[2];
        model.title = arr[0];
        model.webview_url = arr[4];
        model.savePath = arr[3];
        model.downloadType = DiDdwonload;
        [self.modelArray addObject:model];
    }
    [self.button setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.editBtn];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerNib:[UINib nibWithNibName:@"downloadTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _editBtn.frame = CGRectMake(kScreenWidth - 50, 30, 30, 30);
        [_editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        _editBtn.tintColor = [UIColor blackColor];
        [_editBtn addTarget:self action:@selector(editAction1) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editBtn;
}



- (bottomView *)bottomView{
    if (!_bottomView) {
        _bottomView =[[bottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 52, kScreenWidth, 52)];
        _bottomView.backgroundColor = [UIColor grayColor];
        _bottomView.hidden = YES;
        [_bottomView.allSelectBtn addTarget:self action:@selector(seleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_bottomView.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bottomView;
}


 
- (void)editAction1{
    if ([self.editBtn.titleLabel.text isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        self.bottomView.hidden = NO;
        [self.editBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    } else {
        [self.tableView setEditing:NO animated:YES];
        self.bottomView.hidden = YES;
        for (DetailModel *model in self.modelArray) {
            model.isSelect = NO;
        }
        [self.bottomView.allSelectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        self.isAllSelect = NO;
        [self.editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];

    }
    self.isEdit = !self.isEdit;
    
}


- (void)seleteAction:(UIButton *)btn{
    if (!self.isAllSelect) {
        for (DetailModel *model in self.modelArray) {
            model.isSelect = YES;
        }
        for (downloadTableViewCell *cell in self.tableView.visibleCells) {
            cell.selected = YES;
        }
        [self.bottomView.allSelectBtn setTitle:@"取消全选" forState:(UIControlStateNormal)];
    } else {
        for (downloadTableViewCell *cell in self.tableView.visibleCells) {
            cell.selected = NO;
        }
        for (DetailModel *model in self.modelArray) {
            model.isSelect = NO;
        }
        [self.bottomView.allSelectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
    }
    self.isAllSelect = !self.isAllSelect;
}


- (void)deleteAction:(UIButton *)btn{
//    NSLog(@"%@",NSHomeDirectory());
    for (NSInteger i = self.modelArray.count - 1; i >= 0; i--) {
        DetailModel *model = self.modelArray[i];
        if (model.isSelect) {
            [self.modelArray removeObject:model];
            MusicDownloadTable *dTable = [[MusicDownloadTable alloc] init];
            [dTable deleteDataWithTableNameforMyID:model.title];
            NSFileManager *maneger = [NSFileManager defaultManager];
            [maneger removeItemAtPath:model.savePath error:nil];
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}







#pragma mark  ------- tableView 代理方法 ---------
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    downloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DetailModel *model = self.modelArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    cell.titleL.text = model.title;
    if (model.isSelect) {
        cell.selected = YES;
    } else{
        cell.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEdit) {
        DetailModel *model = self.modelArray[indexPath.row];
        model.isSelect = !model.isSelect;
        NSInteger count = 0;
        for (DetailModel *model in self.modelArray) {
            if (model.isSelect) {
                count++;
            }
        }
        if (count == self.modelArray.count) {
            [self.bottomView.allSelectBtn setTitle:@"取消全选" forState:(UIControlStateNormal)];
            self.isAllSelect = YES;
        } else{
            [self.bottomView.allSelectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
            self.isAllSelect = NO;
        }
    } else {
        [MyPlayerManager defaultManager].index = indexPath.row;
        [MyPlayerManager defaultManager].musicLists = self.modelArray;
        musicViewController *musicV = [[musicViewController alloc] init];
        [UIView transitionFromView:self.view toView:musicV.view duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        [self.navigationController pushViewController:musicV animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEdit) {
        DetailModel *model = self.modelArray[indexPath.row];
        model.isSelect = !model.isSelect;
        NSInteger count = 0;
        for (DetailModel *model in self.modelArray) {
            if (model.isSelect) {
                count++;
            }
        }
        if (count == self.modelArray.count) {
            [self.bottomView.allSelectBtn setTitle:@"取消全选" forState:(UIControlStateNormal)];
            self.isAllSelect = YES;
        } else{
            [self.bottomView.allSelectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
            self.isAllSelect = NO;
        }
}
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1|2;
}



- (void)buttonAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
