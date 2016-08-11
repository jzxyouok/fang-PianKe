//
//  BlurView.h
//  Product-A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 tongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : UIView

@property (nonatomic , strong) UIImageView *imageV;

-(instancetype)initWithFrame:(CGRect)frame Image:(NSString *)img;

-(void)setBlurViewImage:(NSString *)img;

@end
