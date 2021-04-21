//
//  HFPlayer.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <HFPlayer/HFPlayerConfiguration.h>
#import "HFPlayerConfiguration.h"

//! Project version number for HFPlayer.
FOUNDATION_EXPORT double HFPlayerVersionNumber;

//! Project version string for HFPlayer.
FOUNDATION_EXPORT const unsigned char HFPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HFPlayer/PublicHeader.h>

@protocol HFPlayerDelegate <NSObject>

@optional
-(void)previousClick;
-(void)nextClick;
-(void)headerClick;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
@end

@interface HFPlayer : UIView

@property(nonatomic ,weak)id <HFPlayerDelegate>                        delegate;
@property(nonatomic ,strong)HFPlayerConfiguration                      *config;



-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config;
-(void)showPlayerView;
-(void)removePlayerView;
-(void)play;
-(void)pause;
-(void)unfoldPlayerBar;
-(void)shrinkPlayerBar;
@end
