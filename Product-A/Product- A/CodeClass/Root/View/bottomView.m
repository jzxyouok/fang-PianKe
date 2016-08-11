//
//  bottomView.m
//  NoteBook2
//
//  Created by lanou on 16/5/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "bottomView.h"

@implementation bottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allSelectBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.allSelectBtn setTitle:@"全选" forState:(UIControlStateNormal)];
        self.allSelectBtn.frame = CGRectMake(50, 10, 80, 40);
        [self addSubview:self.allSelectBtn];
        
        self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.deleteBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        self.deleteBtn.frame = CGRectMake(220, 10, 80, 40);
        [self addSubview:self.deleteBtn];
    }
    return self;
}


@end
