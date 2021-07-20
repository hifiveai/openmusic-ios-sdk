//
//  HFVGlobalTool.h
//  HFVMusicKit
//
//  Created by 郭亮 on 2020/12/1.
//

#import <Foundation/Foundation.h>

@interface HFVGlobalTool : NSObject

//拖拽上限
@property(nonatomic ,assign) NSUInteger HFVPanTopLimit;
//拖拽下限
@property(nonatomic ,assign) NSUInteger HFVPanBottomLimit;
//弹出歌曲菜单栏高度
@property(nonatomic ,assign) NSInteger songListHeight;
//歌曲菜单栏是否展开
@property(nonatomic ,assign) BOOL isSongListShow;

/**
 单例
 */
+(instancetype)shareTool;

@end


