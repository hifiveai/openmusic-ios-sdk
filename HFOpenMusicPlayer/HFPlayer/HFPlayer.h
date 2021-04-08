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

@protocol HFPlayerDele <NSObject>

@optional
-(void)previousPlay;
-(void)nextPlay;
-(void)playerPlayToEnd;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
-(void)headerClick;
@end

@interface HFPlayer : UIView

@property(nonatomic ,weak)id <HFPlayerDele>                        delegate;
@property(nonatomic ,strong)HFPlayerConfiguration                  *config;



-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config;

@end
