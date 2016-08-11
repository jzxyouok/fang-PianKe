//
//  LoginViewController.m
//  Product- A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation LoginViewController
// 设置最上面的状态栏（信号、电量、时间所在的栏）
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager getUserIcon]]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark --- button
- (IBAction)login:(id)sender {
    NSDictionary *parDic = @{@"email":self.emailTF.text,@"passwd":[self.pwdTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    [RequestManager requestWithUrlString:kLoginUrl parDic:parDic requestType:RequestPOST finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"dic === %@", dic);
        if ([dic[@"result"] integerValue] == 1 ) {
            
            NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *key in userInfo) {
                [dict setObject:userInfo[key] forKey:key];
            }
            [dict setObject:self.pwdTF.text forKey:self.emailTF.text];
            NSDictionary *resultDic = dict;
            [[NSUserDefaults standardUserDefaults] setObject:resultDic forKey:@"userInfo"];
            
            self.resultBlock(dic[@"data"][@"uname"]);
            [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
            [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
            [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
            [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else{
//            NSLog(@"%@",dic[@"data"][@"msg"]);
        }
    } error:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    // register 的 block 回调
    regist.resultBlock = ^(NSString *icon){
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:icon]];
    };
    [self.navigationController pushViewController:regist animated:YES];
}
#pragma mark --- 第三方登录
- (IBAction)wechatAction:(id)sender {
    [self connectShareSDKWithType:SSDKPlatformTypeWechat];
    
}

- (void)connectShareSDKWithType:(SSDKPlatformType )type{
    
    [SSEThirdPartyLoginHelper loginByPlatform:type onUserSync:^(SSDKUser *user,SSEUserAssociateHandler associateHandler) {
        //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
        //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
        associateHandler (user.uid, user, user);
//        NSLog(@"dd%@",user.rawData);
//        NSLog(@"dd%@",user.credential);
    }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    if (state == SSDKResponseStateSuccess) {
//                                        NSLog(@"登陆成功");
                                    } else {
//                                        NSLog(@"登陆失败");
                                    }
                                }];
}

#pragma mark ----------- 弹出键盘 更改fram ---------
- (void)keyBoardShow:(NSNotification *)nsnotification{
//    NSLog(@"键盘弹出");
    NSDictionary *dic = nsnotification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize size = [value CGRectValue].size;
    CGRect frame = self.view.frame;
    frame.origin.y = 0 - size.height + (kScreenHeight - self.pwdTF.frame.origin.y) - self.pwdTF.frame.size.height - 20;
    self.view.frame = frame;
}
- (void)keyBoardHide:(NSNotification *)nsnotification{
//    NSLog(@"键盘回收");
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

#pragma mark   -- -- - 回收键盘 --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}



@end
