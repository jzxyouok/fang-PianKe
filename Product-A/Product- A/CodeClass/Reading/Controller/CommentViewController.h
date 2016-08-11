//
//  CommentViewController.h
//  Product- A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SecondViewController.h"


// 点击 tableView 回收键盘
@implementation UIScrollView (UITouchEvent)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}
@end



@interface CommentViewController : SecondViewController

@property(nonatomic,strong)NSString *contentid;

@end
