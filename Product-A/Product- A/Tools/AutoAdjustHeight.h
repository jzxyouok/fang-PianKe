//
//  AutoAdjustHeight.h
//  UI11_UITableViewContronller
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 lanou. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface AutoAdjustHeight : NSObject
+ (CGFloat)adjustHeightByString:(NSString *)text width:(CGFloat)width font:(CGFloat)font;

@end
