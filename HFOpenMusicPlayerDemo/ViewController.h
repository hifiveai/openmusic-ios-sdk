//
//  ViewController.h
//  HFOpenMusicPlayerDemo
//
//  Created by 郭亮 on 2021/4/6.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic ,assign)BOOL                                         networkAbilityEable;
@property(nonatomic ,assign)BOOL                                         cacheEnable;
@property(nonatomic ,assign)NSUInteger                                   bufferCacheSize;
@property(nonatomic ,assign)NSUInteger                                   topLimit;
@property(nonatomic ,assign)NSUInteger                                   bottomLimit;
@property(nonatomic ,assign)NSUInteger                                   musicType;
@end

