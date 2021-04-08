//
//  HFResourceLoaderManager.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/1/11.
//

#import <Foundation/Foundation.h>
#import "HFPlayerApiConfiguration.h"
@import AVFoundation;



@interface HFResourceLoaderManager : NSObject 

@property(nonatomic ,strong)HFPlayerApiConfiguration                            *config;

@property(nonatomic, assign)BOOL                                             seeking;
@property(nonatomic, assign)BOOL                                             requestRecord;

/// 创建playerItem
/// @params url URL
-(AVPlayerItem *)playerItemWithURL:(NSURL *)url;


-(void)cleanNotCompleteSongCache;
@end


