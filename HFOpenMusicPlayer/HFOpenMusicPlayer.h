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

// In this header, you should import all the public headers of your framework using statements like #import <HFOpenMusicPlayer/PublicHeader.h>
#import <HFOpenMusicPlayer/HFOpenMusicPlayerConfiguration.h>
#import <HFOpenMusicPlayer/HFPlayer.h>
#import <HFOpenMusicPlayer/HFPlayerApi.h>
#import <HFOpenMusicPlayer/HFOpenMusic.h>
#import <HFOpenMusicPlayer/HFOpenApiManager.h>
#import <HFOpenMusicPlayer/HFOpenEnumHeader.h>


@interface HFOpenMusicPlayer : UIView

@property(nonatomic ,strong)HFOpenMusicPlayerConfiguration                                *config;

-(instancetype)initWithListenType:(HFOpenMusicListenType)type config:(HFOpenMusicPlayerConfiguration *_Nonnull)config;
-(void)addMusicPlayerView;
-(void)removeMusicPlayerView;
@end
