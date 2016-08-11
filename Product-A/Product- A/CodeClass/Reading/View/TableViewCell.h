//
//  TableViewCell.h
//  Product- A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionVIewModel.h"

@interface TableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UILabel *contentL;
@property(nonatomic,strong)UIImageView *imageV;


- (void)cellWithModel:(CollectionVIewModel *)model;




@end
