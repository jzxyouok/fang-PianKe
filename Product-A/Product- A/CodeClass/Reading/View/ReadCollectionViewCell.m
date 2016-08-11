//
//  ReadCollectionViewCell.m
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "ReadCollectionViewCell.h"

@implementation ReadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageV];
        self.nameL = [[UILabel alloc] init];
        self.ennameL = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.ennameL];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.nameL.frame = CGRectMake(0, self.contentView.frame.size.height *4/5.0, 0, self.contentView.frame.size.height/5.0);
    self.nameL.textColor = [UIColor whiteColor];
    self.nameL.font = [UIFont systemFontOfSize:15];
    [self.nameL sizeToFit];
    self.ennameL.frame = CGRectMake(self.nameL.frame.size.width+2, self.contentView.frame.size.height*4/5.0+3, 0, self.contentView.frame.size.height/5.0);
    self.ennameL.textColor = [UIColor whiteColor];
    self.ennameL.font = [UIFont systemFontOfSize:12];
    [self.ennameL sizeToFit];
}






- (void)cellConfigureModel:(ReadModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.nameL.text = model.name;
    self.ennameL.text = model.enname;
}








@end
