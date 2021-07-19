//
//  HFOpenMusicPlayer.h
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double HFOpenMusicPlayerVersionNumber;

FOUNDATION_EXPORT const unsigned char HFOpenMusicPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import "PublicHeader.h"
#import "HFOpenMusicPlayerConfiguration.h"
#import "HFPlayer.h"
#import "HFPlayerApi.h"
#import "HFOpenMusic.h"
#import "HFOpenApiManager.h"
#import "HFOpenEnumHeader.h"


@interface HFOpenMusicPlayer : UIView

@property(nonatomic ,strong)HFOpenMusicPlayerConfiguration                                * _Nullable config;

-(instancetype _Nonnull )initWithListenType:(HFOpenMusicListenType)type config:(HFOpenMusicPlayerConfiguration *_Nonnull)config;
-(void)addMusicPlayerView;
-(void)removeMusicPlayerView;
@end
