//
//  LoginViewController.h
//  Product- A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLOCK)(NSString *name);

@interface LoginViewController : UIViewController

@property(nonatomic,copy)BLOCK resultBlock;

@end
