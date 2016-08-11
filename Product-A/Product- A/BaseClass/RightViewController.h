//
//  RightViewController.h
//  Product- A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MOVETYPE){
    MOVETYPELEFT,
    MOVETYPERIGHT
};

@interface RightViewController : UIViewController

@property(nonatomic,assign)BOOL flag;

@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UILabel *titleLabel;

// hide or show
- (void)ChangeFrameWithType:(MOVETYPE)type;

@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property(nonatomic,strong)UIScreenEdgePanGestureRecognizer *screenEdgePan;

@end
