//
//  RegisterViewController.m
//  Product- A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,assign)NSInteger gender;
@property (strong, nonatomic) IBOutlet UIButton *icon;
@property (strong, nonatomic) IBOutlet UITextField *nanBtn;
@property (strong, nonatomic) IBOutlet UITextField *nvBtn;
@property (strong, nonatomic) IBOutlet UITextField *unameTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;

@property(nonatomic,strong)UIImage *updataImage;

@end

@implementation RegisterViewController

// 设置最上面的状态栏（信号、电量、时间所在的栏）
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}


#pragma mark ----- 调用系统相册选取头像 ------
- (IBAction)iconAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:0 handler:^(UIAlertAction * _Nonnull action) {
       // camera
        [self alertActionWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:0 handler:^(UIAlertAction * _Nonnull action) {
       // album
        [self alertActionWithSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:1 handler:nil];
    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertActionWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    pic.sourceType = sourceType;
    pic.delegate = self;
    pic.allowsEditing = YES;
    [self presentViewController:pic animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.updataImage = info[@"UIImagePickerControllerEditedImage"];
    [self.icon setImage:info[@"UIImagePickerControllerEditedImage"] forState:(UIControlStateNormal)];
}


#pragma mark --- select gender
- (IBAction)nan:(id)sender {
    self.nanBtn.userInteractionEnabled = NO;
    self.nanBtn.backgroundColor = [UIColor grayColor];
    self.nvBtn.backgroundColor = PKCOLOR(210, 210, 210);
    self.gender = 0;
}
- (IBAction)nv:(id)sender {
    self.nvBtn.userInteractionEnabled = NO;
    self.nvBtn.backgroundColor = [UIColor grayColor];
    self.nanBtn.backgroundColor = PKCOLOR(210, 210, 210);
    self.gender = 1;
}



#pragma mark ---- 注册 ----
- (IBAction)registAction:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 具体出现的content —type类型错误，返回信息更全面
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-javascript"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:kRegistUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.updataImage) name:@"iconfile" fileName:@"uploadheadimage.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[_emailTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%ld",_gender] dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
        [formData appendPartWithFormData:[_pwdTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"passwd"];
        [formData appendPartWithFormData:[_unameTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"uname"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        if ([dic[@"result"] integerValue] == 1) {
            [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
            [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
            [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
            [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
            // 调用 block
            self.resultBlock([UserInfoManager getUserIcon]);
            
            [self.navigationController popViewControllerAnimated:YES];
        } else{
//            NSLog(@"%@",dic[@"data"][@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
    }];
    
}


#pragma mark  ----- 弹出键盘自适应高度 ------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardShow:(NSNotification *)nsnotification{
    NSDictionary *dic = nsnotification.userInfo;
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize size = [value CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0 - size.height - self.pwdTF.frame.size.height - 20 + (kScreenHeight - self.pwdTF.frame.origin.y);
    self.view.frame = frame;
}
- (void)keyBoardHide:(NSNotification *)nsnotification{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

#pragma mark ----- 回收键盘 ----
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
