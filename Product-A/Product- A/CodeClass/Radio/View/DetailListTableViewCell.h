//
//  DetailListTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface DetailListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *unameL;
@property (strong, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (strong, nonatomic) IBOutlet UIView *flag;
@property (assign, nonatomic) BOOL isFirst;

- (void)cellConfigureModel:(DetailModel *)model;


@end
