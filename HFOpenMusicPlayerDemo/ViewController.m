//
//  ViewController.m
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/6.
//

#import "ViewController.h"
#import <HFOpenMusicPlayer/HFOpenMusicPlayer.h>
#import <HFOpenMusicPlayer/HFPlayerApi.h>
#import <HFOpenMusicPlayer/HFOpenApiManager.h>
#import <HFOpenMusicPlayer/HFPlayer.h>
#import <HFOpenMusicPlayer/HFOpenMusic.h>



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
    [self.view addSubview:imageView];
    
    switch (_uiType) {
        case 0:
        {
            [self configUiType0];
        }
            break;
        case 1:
        {
            [self configUiType1];
        }
            break;
        case 2:
        {
            [self configUiType2];
        }
            break;
        default:
            break;
    }
}

//播放器+列表
-(void)configUiType0 {
    HFOpenMusicPlayerConfiguration *config = [HFOpenMusicPlayerConfiguration defaultConfiguration];
    config.networkAbilityEable = self.networkAbilityEable;
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize;
    config.panTopLimit = self.topLimit;
    config.panBottomLimit = self.bottomLimit;
    HFOpenMusicPlayer *playerListView = [[HFOpenMusicPlayer alloc] initWithListenType:TYPE_TRAFFIC config:config];
    //显示
    [playerListView addMusicPlayerView];
    _playerListView = playerListView;
}

//播放器
-(void)configUiType1 {
    HFPlayerConfiguration *config = [HFPlayerConfiguration defaultConfiguration];
    config.networkAbilityEable = self.networkAbilityEable;
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize;
    config.panTopLimit = self.topLimit;
    config.panBottomLimit = self.bottomLimit;
    //https://img.zhugexuetang.com/lleXB2SNF5UFp1LfNpPI0hsyQjNs
    //http://music.163.com/song/media/outer/url?id=64634.mp3
    //ijkio:cache:ffio:
    config.urlString = @"http://music.163.com/song/media/outer/url?id=64634.mp3";
    config.songName = @"一丝不挂";
    HFPlayer *playerView = [[HFPlayer alloc] initWithConfiguration:config];
    playerView.delegate = self;
    [playerView addPlayerView];
    _playerView = playerView;
    //开始播放
    [_playerView play];
}

//列表
-(void)configUiType2 {
    HFOpenMusic *listView = [[HFOpenMusic alloc] initMusicListViewWithListenType:self.musicType showControlbtn:true];
    listView.delegate = self;
    [listView addMusicListView];
    _listView = listView;
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
