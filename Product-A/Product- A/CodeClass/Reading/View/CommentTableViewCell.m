//
//  CommentTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellConfigureModel:(CommentModel *)model{
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 20;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.unameL.text = model.uname;
    self.addtimeL.text = model.addtime_f;
    self.contentL.text = model.content;
}

@end
