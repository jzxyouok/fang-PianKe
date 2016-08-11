//
//  TopicCommentTableViewCell.h
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "topicComment.h"

@interface TopicCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *unameL;
@property (strong, nonatomic) IBOutlet UILabel *timeL;
@property (strong, nonatomic) IBOutlet UILabel *likeL;
@property (strong, nonatomic) IBOutlet UILabel *contentL;

- (void)cellConfigureModel:(topicComment *)model;

@end
