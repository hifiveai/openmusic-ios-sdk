//
//  ChooseSdkUIViewController.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/14.
//

#import "ChooseSdkUIViewController.h"
#import "ViewController.h"

@interface ChooseSdkUIViewController ()

@property(nonatomic ,assign)NSUInteger uiType;

@end

@implementation ChooseSdkUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)configUI {
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 50)];
    [allBtn setBackgroundColor:UIColor.grayColor];
    [allBtn setTitle:@"播放器+列表" forState:UIControlStateNormal];
    allBtn.layer.cornerRadius = 10;
    [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    UIButton *playerBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 50)];
    [playerBtn setBackgroundColor:UIColor.grayColor];
    [playerBtn setTitle:@"播放器" forState:UIControlStateNormal];
    playerBtn.layer.cornerRadius = 10;
    [playerBtn addTarget:self action:@selector(playerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playerBtn];
    
    UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, self.view.frame.size.width-100, 50)];
    [listBtn setBackgroundColor:UIColor.grayColor];
    [listBtn setTitle:@"列表" forState:UIControlStateNormal];
    listBtn.layer.cornerRadius = 10;
    [listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
}

-(void)allBtnClick:(UIButton *)btn {
    _uiType = 0;
    [self jump];
}

-(void)playerBtnClick:(UIButton *)btn {
    _uiType = 1;
    [self jump];
}

-(void)listBtnClick:(UIButton *)btn {
    _uiType = 2;
    [self jump];
}

-(void)jump {
    ViewController *vc = [ViewController new];
    vc.networkAbilityEable = self.networkAbilityEable;
    vc.cacheEnable = self.cacheEnable;
    vc.bufferCacheSize = self.bufferCacheSize;
    vc.topLimit = self.topLimit;
    vc.bottomLimit = self.bottomLimit;
    vc.musicType = self.musicType;
    vc.uiType = _uiType;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
