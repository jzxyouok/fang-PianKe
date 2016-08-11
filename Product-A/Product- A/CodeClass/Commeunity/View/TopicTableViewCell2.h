//
//  TopicTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@interface TopicTableViewCell2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *contentL;
@property (strong, nonatomic) IBOutlet UILabel *addtimeL;
@property (strong, nonatomic) IBOutlet UILabel *commentL;

- (void)cellConfigureModel:(TopicModel *)model;


@end
