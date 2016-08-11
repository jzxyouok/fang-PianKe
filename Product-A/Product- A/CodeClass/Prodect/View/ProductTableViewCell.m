//
//  ProductTableViewCell.m
//  Product- A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithModel:(ProductModel *)model{
    [self.butBtn.layer setBorderWidth:1.0];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.titleL.text = model.title;
}



@end
