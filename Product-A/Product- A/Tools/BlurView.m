//
//  BlurView.m
//  Product-A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 tongwei. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView

-(instancetype)initWithFrame:(CGRect)frame Image:(NSString *)img{
    self = [self initWithFrame:frame];
    if (img) {
        if ([img containsString:@"http://"]) {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:img]];
        } else {
            self.imageV.image = [UIImage imageNamed:img];
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageV];
        UIVisualEffectView *visuallEffetView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visuallEffetView.frame = _imageV.frame;
        [_imageV addSubview:visuallEffetView];
    }
    return self;
}

-(void)setBlurViewImage:(NSString *)img{
    if ([img containsString:@"http://"]) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:img]];
    } else {
        self.imageV.image = [UIImage imageNamed:img];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
