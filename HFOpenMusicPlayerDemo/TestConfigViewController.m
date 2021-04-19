//
//  TestConfigViewController.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/7.
//

#import "TestConfigViewController.h"
#import "CheckBoxView.h"
#import "HFInputView.h"
#import "Masonry.h"
#import "ViewController.h"
#import "ChooseSdkUIViewController.h"

@interface TestConfigViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic ,strong)UITableView *myTableView;
@property(nonatomic ,strong)NSArray *dataArray;



@property(nonatomic ,strong)CheckBoxView *check1;
@property(nonatomic ,strong)CheckBoxView *check2;
@property(nonatomic ,strong)CheckBoxView *check3;
@property(nonatomic ,strong)HFInputView *inpitView1;
@property(nonatomic ,strong)HFInputView *inpitView2;
@property(nonatomic ,strong)HFInputView *inpitView3;



@end

@implementation TestConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.check1 = [[CheckBoxView alloc] initWithTitle:@"是否断线重连" dataArray:@[@"开启",@"关闭"]];
    
    [self.view addSubview:_check1];
    [_check1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.view).offset(84);
    }];
    
    self.check2 = [[CheckBoxView alloc] initWithTitle:@"是否开启缓存" dataArray:@[@"开启",@"关闭"]];
    [self.view addSubview:_check2];
    [_check2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(_check1.mas_bottom).offset(25);
    }];
    
    self.inpitView1 = [[HFInputView alloc] initWithTitle:@"缓冲区(kb)"];
    self.inpitView1.field.text = @"500";
    [self.view addSubview:_inpitView1];
    [_inpitView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(_check2.mas_bottom).offset(25);
    }];
    
    self.inpitView2 = [[HFInputView alloc] initWithTitle:@"拖拽上限"];
    self.inpitView2.field.text = @"0";
    [self.view addSubview:_inpitView2];
    [_inpitView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(_inpitView1.mas_bottom).offset(25);
    }];
    
    self.inpitView3 = [[HFInputView alloc] initWithTitle:@"拖拽下限"];
    self.inpitView3.field.text = @"0";
    [self.view addSubview:_inpitView3];
    [_inpitView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(_inpitView2.mas_bottom).offset(25);
    }];
    
    self.check3 = [[CheckBoxView alloc] initWithTitle:@"授权类型" dataArray:@[@"bgm",@"ugc",@"K歌"]];
    [self.view addSubview:_check3];
    [_check3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(_inpitView3.mas_bottom).offset(25);
    }];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [submitBtn setBackgroundColor:UIColor.grayColor];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 10;
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.view.backgroundColor = UIColor.whiteColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inpitView1.field resignFirstResponder];
    [self.inpitView2.field resignFirstResponder];
    [self.inpitView3.field resignFirstResponder];
}

-(void)submit:(UIButton *)sender {
    NSLog(@"%@",_inpitView1.field.text);
    
    
    ChooseSdkUIViewController *vc = [ChooseSdkUIViewController new];
    if ([_check1 getResult] == 0) {
        vc.networkAbilityEable = true;
    } else if ([_check1 getResult] == 1) {
        vc.networkAbilityEable = false;
    }
    if ([_check2 getResult] == 0) {
        vc.cacheEnable = true;
    } else if ([_check1 getResult] == 1) {
        vc.cacheEnable = false;
    }
    if ([_check3 getResult] == -1) {
        vc.musicType = 0;
    } else {
        vc.musicType = [_check3 getResult];
    }
    vc.bufferCacheSize = [_inpitView1.field.text integerValue];
    vc.topLimit = [_inpitView2.field.text integerValue];
    vc.bottomLimit = [_inpitView3.field.text integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
