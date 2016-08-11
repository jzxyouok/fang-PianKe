//
//  TopicDetailViewController.m
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "topicComment.h"
#import "TopicCommentTableViewCell.h"

@interface TopicDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,assign)NSInteger start;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.view addSubview:self.commentBtn];
    [self.view addSubview:self.likeBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.tableView];
    [self setAuther];
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


#pragma mark ----- 属性 ------
- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _commentBtn.frame = CGRectMake(kScreenWidth - 200, 30, 40, 30);
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"u76"] forState:(UIControlStateNormal)];
        _commentBtn.tintColor = [UIColor whiteColor];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _commentBtn;
}
- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _likeBtn.frame = CGRectMake(kScreenWidth - 140, 30, 40, 30);
        _likeBtn.tintColor = [UIColor whiteColor];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"u80"] forState:(UIControlStateNormal)];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _likeBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _shareBtn.frame = CGRectMake(kScreenWidth - 60, 30, 30, 30);
        _shareBtn.tintColor = PKCOLOR(180, 180, 180);
        [_shareBtn setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
    }
    return _shareBtn;
}

- (UIView *)headView{
    if (!_headView) {
        CGFloat titleH = [AutoAdjustHeight adjustHeightByString:self.model.title width:kScreenWidth - 20-20 font:20];
        CGFloat contentH = [AutoAdjustHeight adjustHeightByString:self.model.content width:kScreenWidth - 20*2 font:15];
        if ([self.model.coverimg isEqualToString:@""]) {
            _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, titleH + contentH + 35 + 20 + 40 + 45 + 46 + 50)];
        }else{
            _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, titleH + contentH + 35 + 20 + 40 + 45 + 46 + 50  + 40 + kScreenWidth - 15 - 15)];
        }
    }
    return _headView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69, kScreenWidth, kScreenHeight - 69) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"TopicCommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}




#pragma mark -------- 数据解析 ----------
- (void)loadData{
    NSDictionary *parDic = @{@"contentid":self.model.contentid,@"start":[NSString stringWithFormat:@"%ld",self.start],@"limit":@"10"};
    [RequestManager requestWithUrlString:kTopicDetail parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        UILabel *timeL = [self.headView viewWithTag:100];
        timeL.text = dic[@"data"][@"postsinfo"][@"addtime_f"];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"data"][@"postsinfo"][@"counterList"][@"comment"]] forState:(UIControlStateNormal)];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"data"][@"postsinfo"][@"counterList"][@"like"]] forState:(UIControlStateNormal)];
        NSArray *array = [topicComment modelConfigureJsonDic:dic];
        for (topicComment *model in array) {
            [self.modelArray addObject:model];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
    
}


#pragma mark -------- 布置作者板块 -------
- (void)setAuther{
    CGFloat titleH =[AutoAdjustHeight adjustHeightByString:self.model.title width:kScreenWidth - 30 font:20];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, kScreenWidth - 20 -20, titleH)];
    titleL.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleL.text = self.model.title;
    titleL.numberOfLines = 0;
    [self.headView addSubview:titleL];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, titleL.bottom + 20, 46, 46)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 23;
    [icon sd_setImageWithURL:[NSURL URLWithString:self.model.icon]];
    [self.headView addSubview:icon];
    
    UILabel *auther = [[UILabel alloc] initWithFrame:CGRectMake(20+40+10, icon.centerY - 5, 0, 10)];
    auther.font = [UIFont systemFontOfSize:14];
    auther.textColor = [UIColor lightGrayColor];
    auther.text = self.model.uname;
    [auther sizeToFit];
    [self.headView addSubview:auther];
    
    UILabel *louzhu = [[UILabel alloc] initWithFrame:CGRectMake(auther.right + 3, auther.top + 2, 30, 14)];
    louzhu.font = [UIFont systemFontOfSize:12];
    louzhu.textColor = [UIColor lightGrayColor];
    louzhu.text = @"楼主";
    louzhu.textAlignment = NSTextAlignmentCenter;
    louzhu.layer.masksToBounds = YES;
    louzhu.layer.cornerRadius = 5;
    [louzhu.layer setBorderWidth:1];
    [self.headView addSubview:louzhu];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 90, auther.top, 80, 20)];
    timeL.font = [UIFont systemFontOfSize:12];
    timeL.textColor = [UIColor lightGrayColor];
    timeL.tag = 100;
    [self.headView addSubview:timeL];
    
    UILabel *contentL = [[UILabel alloc] init];
    CGFloat contentH =[AutoAdjustHeight adjustHeightByString:self.model.content width:kScreenWidth - 30 font:17];
    contentL.text = self.model.content;
    contentL.textColor = [UIColor grayColor];
    contentL.numberOfLines = 0;
    if ([self.model.coverimg isEqualToString:@""]) {
        contentL.frame = CGRectMake(15, auther.bottom + 40, kScreenWidth - 15 -10, contentH);
    } else{
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, auther.bottom + 40, kScreenWidth - 30, kScreenWidth - 30)];
        imageV.backgroundColor = [UIColor cyanColor];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg]];
        [self.headView addSubview:imageV];
        contentL.frame = CGRectMake(15, auther.bottom + 40 + 40 + kScreenWidth - 15 - 15,kScreenWidth - 15 -10,contentH);
    }
    [self.headView addSubview:contentL];
    
    
}



#pragma mark ---------tableView 代理方法 -----------
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    topicComment *model = self.modelArray[indexPath.row];
    [cell cellConfigureModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    topicComment *model = self.modelArray[indexPath.row];
    CGFloat contentH = [AutoAdjustHeight adjustHeightByString:model.content width:kScreenWidth - 40 font:16];
    return contentH + 10 + 15 +15 + 40;
    
}



- (void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showVC{
    
}



@end
