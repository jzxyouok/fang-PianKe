//
//  AutoAdjustHeight.m
//  UI11_UITableViewContronller
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 lanou. All rights reserved.
//
#import "AutoAdjustHeight.h"

@implementation AutoAdjustHeight


+ (CGFloat)adjustHeightByString:(NSString *)text width:(CGFloat)width font:(CGFloat)font
{
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGFloat h = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return h;
}








@end
