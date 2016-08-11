//
//  ProductTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *titleL;
@property (strong, nonatomic) IBOutlet UIButton *butBtn;


- (void)cellWithModel:(ProductModel *)model;


@end
