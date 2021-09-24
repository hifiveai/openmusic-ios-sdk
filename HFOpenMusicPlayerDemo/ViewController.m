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

//创建会员歌单  ,获取会员歌单,增加会员歌曲,获取歌曲,移除歌曲/清除歌曲,获取歌曲,删除歌单
- (void)testApi{
    HFOpenApiManager*m =   [HFOpenApiManager shared];
    //创建会员歌单
    [m createMemberWithSheetName:@"两只老虎爱跳舞7" success:^(id  _Nullable response) {
        NSLog(@"createMemberWithSheetName--%@",response);
        //获取会员歌单
        [m fetchMemberSheetListWithMemberOutId:@"2333" page:nil pageSize:nil success:^(id  _Nullable response) {
            //获取sheetId
            NSLog(@"fetchMemberSheetListWithMemberOutId--%@",response);
            //增加会员歌曲,
            NSString *sheetId = @"37460";
            [m addSheetMusicWithSheetId:sheetId musicId:@"CD4390C52C51" success:^(id  _Nullable response) {
                NSLog(@"addSheetMusicWithSheetId--%@",response);
                //获取歌曲
                [m fetchMemberSheetMusicWithSheetId:sheetId page:nil pageSize:nil success:^(id  _Nullable response) {
                    NSLog(@"fetchMemberSheetMusicWithSheetId--%@",response);
                    
                    //移除歌曲
                    [m clearSheetMusicWithSheetId:sheetId success:^(id  _Nullable response) {
            
//                    [m removeSheetMusicWithSheetId:sheetId musicId:@"2F0864DEC7" success:^(id  _Nullable response) {
                        NSLog(@"removeSheetMusicWithSheetId--%@",response);
                        //获取歌曲
                        [m fetchMemberSheetMusicWithSheetId:sheetId page:nil pageSize:nil success:^(id  _Nullable response) {
                            NSLog(@"fetchMemberSheetMusicWithSheetId--%@",response);
                            //删除歌单
                            [m deleteMemberWithSheetId:sheetId success:^(id  _Nullable response) {
                                NSLog(@"deleteMemberWithSheetId--%@",response);
                            } fail:^(NSError * _Nullable error) {
                                NSLog(@"🪲deleteMemberWithSheetId--%@",error);
                            }];
                        } fail:^(NSError * _Nullable error) {
                            NSLog(@"🪲fetchMemberSheetMusicWithSheetId--%@",error);
                        }];
                    } fail:^(NSError * _Nullable error) {
                        NSLog(@"🪲removeSheetMusicWithSheetId--%@",error);
                    }];
                    
                  
                } fail:^(NSError * _Nullable error) {
                    NSLog(@"🪲fetchMemberSheetMusicWithSheetId--%@",error);
                }];
            } fail:^(NSError * _Nullable error) {
                NSLog(@"🪲addSheetMusicWithSheetId--%@",error);
            }];
        } fail:^(NSError * _Nullable error) {
            NSLog(@"🪲fetchMemberSheetListWithMemberOutId--%@",error);
        }];
        
        
        
    } fail:^(NSError * _Nullable error) {
        NSLog(@"🪲createMemberWithSheetName--%@",error);
    }];
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
