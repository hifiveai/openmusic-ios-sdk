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



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"bkg.jpg"];
    [self.view addSubview:imageView];
    
    HFOpenMusicPlayerConfiguration *config = [HFOpenMusicPlayerConfiguration defaultConfiguration];
    config.networkAbilityEable = self.networkAbilityEable;
    config.cacheEnable = self.cacheEnable;
    config.bufferCacheSize = self.bufferCacheSize*1024;
    config.panTopLimit = self.topLimit;
    config.panBottomLimit = self.bottomLimit;
    HFOpenMusicPlayer *playerView = [[HFOpenMusicPlayer alloc] initWithListenType:self.musicType config:config];
    
    [self.view addSubview:playerView];

}


@end
