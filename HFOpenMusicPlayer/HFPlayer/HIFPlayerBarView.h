//
//  HIFPlayerView.h
//  HIFPlayer
//
//  Created by 郭亮 on 2020/11/9.
//

#import <UIKit/UIKit.h>
#import "HFPlayerConfiguration.h"

@protocol HFPlayerViewDelegate <NSObject>

@optional
-(void)previousBtnClick:(UIButton *)sender;
-(void)nextBtnClick:(UIButton *)sender;
-(void)playBtnClick:(UIButton *)sender;
-(void)playerPlayToEnd;
-(void)cutSongDuration:(float)duration musicId:(NSString *)musicId;
-(void)headerClick;
@end

@interface HIFPlayerBarView : UIView

@property(nonatomic ,weak)id <HFPlayerViewDelegate>                                 delegate;
@property(nonatomic ,assign)HIFPlayerBarViewStates                                  states;
@property(nonatomic ,strong)HFPlayerConfiguration                                   *config;

-(instancetype)initWithConfiguration:(HFPlayerConfiguration *)config;
-(void)unfoldAnimation;
-(void)shrinkAnimation;
-(void)play;
-(void)pause;
-(void)resume;
-(void)stop;

@end


