//
//  TopicTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "TopicTableViewCell2.h"

@implementation TopicTableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellConfigureModel:(TopicModel *)model{
    if ([model.coverimg isEqualToString:@""]) {
        CGFloat titleH = [AutoAdjustHeight adjustHeightByString:model.title width:kScreenWidth - 20-20 font:20];
        CGFloat contentH = [AutoAdjustHeight adjustHeightByString:model.content width:kScreenWidth - 20*2 font:17];
        self.contentL.frame = CGRectMake(20, titleH + 20 + 20, kScreenWidth - 20*2, contentH);
    }
    self.titleL.text = model.title;
    self.contentL.text = model.content;
    self.addtimeL.text = model.addtime_f;
    self.commentL.text = [NSString stringWithFormat:@"%@",model.comment];
}



@end
