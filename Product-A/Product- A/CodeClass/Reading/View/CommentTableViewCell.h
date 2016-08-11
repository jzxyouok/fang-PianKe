//
//  CommentTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *unameL;
@property (strong, nonatomic) IBOutlet UILabel *addtimeL;
@property (strong, nonatomic) IBOutlet UILabel *contentL;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;



- (void)cellConfigureModel:(CommentModel *)model;




@end
