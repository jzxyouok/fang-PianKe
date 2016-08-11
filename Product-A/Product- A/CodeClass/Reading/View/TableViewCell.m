//
//  TableViewCell.m
//  Product- A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleL = [[UILabel alloc] init];
        self.titleL.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        self.titleL.numberOfLines = 0;
        [self.contentView addSubview:self.titleL];
        self.contentL = [[UILabel alloc] init];
        self.contentL.numberOfLines = 0;
        self.contentL.font = [UIFont systemFontOfSize:16];
        self.contentL.textColor = PKCOLOR(100, 100, 100);
        [self.contentView addSubview:self.contentL];
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageV];
    }
    return self;
}


- (void)cellWithModel:(CollectionVIewModel *)model{
    self.titleL.text = model.title;
    self.contentL.text = model.content;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat h = [AutoAdjustHeight adjustHeightByString:self.titleL.text width:kScreenWidth - 40 font:22];
    self.titleL.frame = CGRectMake(20, 20, kScreenWidth - 40, h );
    self.imageV.frame = CGRectMake(20, h + 40, 140, 60);
    self.contentL.frame = CGRectMake(165, h + 40 + 10 , kScreenWidth - 160 - 20, 45);
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
