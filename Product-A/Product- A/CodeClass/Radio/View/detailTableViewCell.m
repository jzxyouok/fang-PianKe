//
//  detailTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "detailTableViewCell.h"

@implementation detailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithModel:(DetailModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.titleL.text = model.title;
    self.countL.text = model.musicVisit;
}



@end
