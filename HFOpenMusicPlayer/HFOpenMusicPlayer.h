//
//  HFOpenMusicPlayer.h
//  HFOpenMusicPlayer
//
//  Created by 郭亮 on 2021/4/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <HFOpenMusicPlayer/HFPlayerApiConfiguration.h>
//#import <HFOpenMusicPlayer/HFPlayerApi.h>
//#import <HFOpenMusicPlayer/HFOpenApiManager.h>
#import <HFOpenMusicPlayer/HFPlayer.h>



//! Project version number for HFOpenMusicPlayer.
FOUNDATION_EXPORT double HFOpenMusicPlayerVersionNumber;

//! Project version string for HFOpenMusicPlayer.
FOUNDATION_EXPORT const unsigned char HFOpenMusicPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HFOpenMusicPlayer/PublicHeader.h>


@interface HFOpenMusicPlayer : UIView

@property(nonatomic ,strong)HFPlayerConfiguration                                *config;

-(instancetype)initWithListenType:(NSUInteger)type config:(HFPlayerConfiguration *)config;

@end
