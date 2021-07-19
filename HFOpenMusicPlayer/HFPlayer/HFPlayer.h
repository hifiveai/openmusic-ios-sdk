//
//  HFPlayer.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HFPlayerConfiguration.h"


@protocol HFPlayerDelegate <NSObject>

@optional
-(void)previousClick;
-(void)nextClick;
-(void)headerClick;
-(void)playerPlayToEnd;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
@end

@interface HFPlayer : UIView

@property(nonatomic ,weak)id <HFPlayerDelegate>                        delegate;
@property(nonatomic ,strong)HFPlayerConfiguration                      *config;



-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config;
-(void)addPlayerView;
-(void)removePlayerView;
-(void)play;
-(void)pause;
-(void)unfoldPlayerBar;
-(void)shrinkPlayerBar;
@end
