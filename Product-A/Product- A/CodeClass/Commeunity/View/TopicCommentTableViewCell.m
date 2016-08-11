//
//  TopicCommentTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "TopicCommentTableViewCell.h"

@implementation TopicCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigureModel:(topicComment *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.unameL.text = model.uname;
    self.contentL.text = model.content;
    self.timeL.text = model.addtime_f;
    self.likeL.text = [NSString stringWithFormat:@"%@",model.likenum];
}


@end
