//
//  CommentViewController.m
//  Product- A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,assign)NSInteger start;
@property(nonatomic,strong)UIButton *addComment;
@property(nonatomic,strong)UIView *CommentView;
@property(nonatomic,strong)UITextField *CommentTF;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"评论";
    
    [self loadData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addComment];
    [self.view addSubview:self.CommentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];
        self.start = 0;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.start += 10;
            [self loadData];
        }];
        self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            [self.modelArray removeAllObjects];
            self.start = 0;
            [self loadData];
        }];
    }
    return _tableView;
}


- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (UIButton *)addComment{
    if (!_addComment) {
        _addComment = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _addComment.frame = CGRectMake(kScreenWidth - 51, 28, 35, 35);
        [_addComment setTitle:@"评论" forState:(UIControlStateNormal)];
        _addComment.backgroundColor = PKCOLOR(180, 180, 180);
        _addComment.tintColor = PKCOLOR(255, 255, 255);
        [_addComment addTarget:self action:@selector(addCommentAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addComment;
}

- (UIView *)CommentView{
    if (!_CommentView) {
        _CommentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 10, kScreenWidth, 0)];
        _CommentView.backgroundColor = PKCOLOR(200, 200, 200);
        _CommentTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 30)];
        _CommentTF.tag = 100;
        _CommentTF.clearButtonMode = UITextFieldViewModeAlways;
        _CommentTF.borderStyle = UITextBorderStyleRoundedRect;
        _CommentTF.backgroundColor = [UIColor whiteColor];
        _CommentTF.delegate = self;
        _CommentTF.returnKeyType = UIReturnKeySend;
        [_CommentView addSubview:_CommentTF];
    }
    return _CommentView;
}


#pragma mark ------ Button方法------

- (void)addCommentAction{
        [UIView animateWithDuration:0.5 animations:^{
            self.CommentView.frame = CGRectMake(0, kScreenHeight - 45 , kScreenWidth, 35);
            UITextField *commentTF = [self.CommentView viewWithTag:100];
            [commentTF becomeFirstResponder];
        } completion:nil];
}


#pragma mark --- 添加评论 --- -
- (void)addCommentText{
    NSDictionary *parDic = @{@"auth":[UserInfoManager getUserAuth],@"client":@"1",@"content":self.CommentTF.text,@"contentid":self.contentid};
    [RequestManager requestWithUrlString:kAddComment parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        [self.modelArray removeAllObjects];
        [self loadData];
    } error:^(NSError *error) {
    }];
}


#pragma mark --- 删除评论 ----
- (void)deleteCommentText:(CommentModel *)model{
    NSDictionary *parDic = @{@"auth":[UserInfoManager getUserAuth],@"commentid":model.contentid,@"contentid":self.contentid};
    [RequestManager requestWithUrlString:kDelete parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"%@",dic[@"data"][@"msg"]);
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}



- (void)loadData{
    NSDictionary *parDic = @{@"auth":[UserInfoManager getUserAuth],@"client":@"1",@"contentid":self.contentid,@"start":[NSString stringWithFormat:@"%ld",self.start],@"version":@"3.0.6"};
    [RequestManager requestWithUrlString:kComment parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"%@",dic);
        NSArray *arr = [CommentModel modelConfigureJson:dic];
        for (CommentModel *model  in arr) {
            [self.modelArray addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}





#pragma mark ---- tableView 代理方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    CommentModel *model = self.modelArray[indexPath.row];
    [cell cellConfigureModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.modelArray[indexPath.row];
    CGFloat h = [AutoAdjustHeight adjustHeightByString:model.content width:kScreenWidth - 28 - 28 font:15];
    return h + 70;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.CommentTF resignFirstResponder];
    [self hiddenKeyBoard];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CommentModel *model = self.modelArray[indexPath.row];
        if (model.isdel) {
            [self.modelArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self deleteCommentText:model];
        }
    }
}


#pragma mark ----- 添加弹出键盘的通知 ----
- (void)keyBoardShow:(NSNotification *)nsnotification{
    NSDictionary *dic = nsnotification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize size = [value CGRectValue].size;
    CGRect frame = self.view.frame;
    frame.origin.y = kScreenHeight - size.height - 40;
    self.CommentView.frame = frame;
}
- (void)keyBoardHide:(NSNotification *)nsnotification{
    CGRect frame = self.view.frame;
    frame.origin.y = kScreenHeight - 45;
    self.CommentView.frame = frame;
}





#pragma mark  ------- 点击键盘发送消息  回收键盘 ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hiddenKeyBoard];
    [textField resignFirstResponder];
    [self addCommentText];
    textField.text = @"";
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *commentTF = [self.CommentView viewWithTag:100];
    [commentTF resignFirstResponder];
    [self hiddenKeyBoard];
}

-(void)hiddenKeyBoard{
    [UIView animateWithDuration:0.5 animations:^{
        UITextField *commentTF = [self.CommentView viewWithTag:100];
        [commentTF resignFirstResponder];
        self.CommentView.frame = CGRectMake(5, kScreenHeight+10, kScreenWidth - 10, 0);
    } completion:nil];
}





@end
