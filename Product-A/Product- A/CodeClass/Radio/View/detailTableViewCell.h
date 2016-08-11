//
//  detailTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface detailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UILabel *countL;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;


- (void)cellWithModel:(DetailModel *)model;


@end
