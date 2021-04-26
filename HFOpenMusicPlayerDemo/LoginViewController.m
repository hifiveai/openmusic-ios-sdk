//
//  LoginViewController.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/8.
//

#import "LoginViewController.h"
#import <HFOpenMusicPlayer/HFOpenMusicPlayer.h>
#import "TestConfigViewController.h"

@interface LoginViewController ()

@property(nonatomic ,strong)UITextField *filed1;
@property(nonatomic ,strong)UITextField *filed2;
@property(nonatomic ,strong)UITextField *filed3;
@property(nonatomic ,strong)UITextField *filed4;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

-(void)configUI {
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 50)];
    label1.text = @"AppId";
    label1.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label1];
    UITextField *filed1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 105, 250, 40)];
    filed1.text = @"300a44d050c942eebeae8765a878b0ee";
    //filed1.text = @"e8cb57f7d6134832b6ebfdc231ed2f57";
    filed1.layer.borderColor = UIColor.blackColor.CGColor;
    filed1.layer.borderWidth = 1;
    filed1.layer.cornerRadius = 10;
    [self.view addSubview:filed1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 50)];
    label2.text = @"ServerCode";
    label2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label2];
    UITextField *filed2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 205, 250, 40)];
    filed2.text = @"0e31fe11b31247fca8";
    //filed2.text = @"68dc9aa2580146caaf";
    filed2.layer.borderColor = UIColor.blackColor.CGColor;
    filed2.layer.borderWidth = 1;
    filed2.layer.cornerRadius = 10;
    [self.view addSubview:filed2];
    
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 80, 50)];
    label3.text = @"ClientId";
    label3.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label3];
    UITextField *filed3 = [[UITextField alloc] initWithFrame:CGRectMake(100, 305, 250, 40)];
    filed3.text = @"hf7no8v6o7t2ve3r90";
    filed3.layer.borderColor = UIColor.blackColor.CGColor;
    filed3.layer.borderWidth = 1;
    filed3.layer.cornerRadius = 10;
    [self.view addSubview:filed3];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 80, 50)];
    label4.text = @"Version";
    label4.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label4];
    UITextField *filed4 = [[UITextField alloc] initWithFrame:CGRectMake(100, 405, 250, 40)];
    filed4.text = @"V4.0.1";
    filed4.layer.borderColor = UIColor.blackColor.CGColor;
    filed4.layer.borderWidth = 1;
    filed4.layer.cornerRadius = 10;
    [self.view addSubview:filed4];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, self.view.frame.size.width-40, 50)];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:UIColor.grayColor];
    loginBtn.layer.cornerRadius = 10;
    [loginBtn setTitle:@"LogIn" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    self.filed1 = filed1;
    self.filed2 = filed2;
    self.filed3 = filed3;
    self.filed4 = filed4;
    self.view.backgroundColor = UIColor.whiteColor;
}

-(void)login {
    //注册
    //300a44d050c942eebeae8765a878b0ee
    //0e31fe11b31247fca8
    //hf7no8v6o7t2ve3r90
    //V4.0.1
    [[HFOpenApiManager shared] registerAppWithAppId:_filed1.text serverCode:_filed2.text clientId:_filed3.text version:_filed4.text success:^(id  _Nullable response) {
        NSLog(@"注册成功");
    } fail:^(NSError * _Nullable error) {
        NSLog(@"注册失败");
    }];
    
    
    [self.navigationController pushViewController:[TestConfigViewController new] animated:true];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.filed1 resignFirstResponder];
    [self.filed2 resignFirstResponder];
    [self.filed3 resignFirstResponder];
    [self.filed4 resignFirstResponder];
}

@end
