//
//  MyTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UILabel *unameL;
@property (strong, nonatomic) IBOutlet UILabel *descL;
@property (strong, nonatomic) IBOutlet UILabel *count;

@end
