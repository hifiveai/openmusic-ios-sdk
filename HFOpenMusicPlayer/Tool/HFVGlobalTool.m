//
//  HFVGlobalTool.m
//  HFVMusicKit
//
//  Created by 郭亮 on 2020/12/1.
//

#import "HFVGlobalTool.h"

@implementation HFVGlobalTool

+(instancetype)shareTool {
    static HFVGlobalTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!tool) {
            tool = [[HFVGlobalTool alloc] init];
            [tool defaultConfig];
        }
    });
    return tool;
}

-(void)defaultConfig {
    self.HFVPanTopLimit = 0;
    self.HFVPanBottomLimit = [UIScreen mainScreen].bounds.size.height;
    self.songListHeight = KScale(440);
    self.isSongListShow = NO;
}

@end
