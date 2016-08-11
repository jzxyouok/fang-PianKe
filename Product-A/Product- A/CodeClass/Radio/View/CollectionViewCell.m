//
//  CollectionViewCell.m
//  diantai
//
//  Created by lanou on 16/6/17.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.imageV];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.label.text = @"精选";
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}









@end
