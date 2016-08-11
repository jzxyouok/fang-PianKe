//
//  RegisterViewController.h
//  Product- A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SecondViewController.h"

typedef void(^BLOCK)(NSString *name);

@interface RegisterViewController : SecondViewController

@property(nonatomic,copy)BLOCK resultBlock;

@end
