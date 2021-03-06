//
//  ViewController.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/6.
//

#import "ViewController.h"
#import "HFOpenMusicPlayer.h"
#import <Masonry/Masonry.h>

@interface ViewController () <HFOpenMusicDelegate ,HFPlayerStatusProtocol>
@property(nonatomic ,strong)HFOpenMusicPlayer                       *playerListView;
@property(nonatomic ,strong)HFPlayer                                *playerView;
@property(nonatomic ,strong)HFOpenMusic                             *listView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"bkg.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    
    self.networkAbilityEable = true;
    self.cacheEnable =true;
    self.bufferCacheSize =500;
    self.topLimit = 0;
    self.bottomLimit = 0;
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testBtnClick];
      
    });
    
}

-(void)testBtnClick {
    
 [[HFOpenApiManager shared] registerAppWithAppId:@"3faeec81030444e98acf6af9ba32752a" serverCode:@"59b1aff189b3474398" clientId:@"hifive-testdemo" version:@"V4.1.2" success:^(id  _Nullable response) {
     NSLog(@"注册成功");
     //静默登录
     [[HFOpenApiManager shared] baseLoginWithNickname:@"风车车" gender:nil birthday:nil location:nil education:nil profession:nil isOrganization:false reserve:nil favoriteSinger:nil favoriteGenre:nil success:^(id  _Nullable response) {
         NSLog(@"登录成功");
         [self configUiType0];
     } fail:^(NSError * _Nullable error) {
         NSLog(@"!!!");
     }];
    
     
 } fail:^(NSError * _Nullable error) {
     NSLog(@"注册失败");
     [self showAlert:error.localizedDescription];
 }];
}

//播放器+列表
-(void)configUiType0 {
    HFOpenMusicPlayerConfiguration *config = [HFOpenMusicPlayerConfiguration defaultConfiguration];
    config.networkAbilityEable = self.networkAbilityEable;
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize;
    config.panTopLimit = self.topLimit;
    config.panBottomLimit = self.bottomLimit;
    HFOpenMusicPlayer *playerView = [[HFOpenMusicPlayer alloc] initWithListenType:TYPE_K config:config];
    //显示
    [playerView addMusicPlayerView];
    _playerListView = playerView;
    [playerView.listView showMusicSegmentView];
   
    
}

-(void)showAlert:(NSString *)message {
    UIAlertController *alertVC = [[UIAlertController alloc] init];
    alertVC.title = @"提示";
    alertVC.message = message;
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 列表SDK Delegate
-(void)currentPlayChangedMusic:(HFOpenMusicModel *)musicModel detail:(HFOpenMusicDetailInfoModel *)detailModel canCutSong:(BOOL)canCutSong {
    NSMutableString *message = [NSMutableString stringWithCapacity:0];
    if (musicModel.musicName && musicModel.musicName.length>0) {
        [message appendString:musicModel.musicName];
    }
    if (detailModel.fileUrl && detailModel.fileUrl.length>0) {
        [message appendString:@"\n"];
        [message appendString:detailModel.fileUrl];
    }
    [self showAlert:message];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.playerListView) {
        [self.playerListView removeFromSuperview];
    }
    if (self.playerView) {
        [self.playerView removeFromSuperview];
    }
    if (self.listView) {
        [self.listView removeFromSuperview];
    }
}



@end
