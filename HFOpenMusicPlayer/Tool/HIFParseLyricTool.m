//
//  HIFParseLyricTool.m
//  HIFPlayer
//
//  Created by 郭亮 on 2020/11/9.
//

#import "HIFParseLyricTool.h"

@implementation HIFParseLyricTool

-(instancetype) init{
    if(self=[super init]){
        self.timeArray=[[NSMutableArray alloc] init];
        self.wordArray=[[NSMutableArray alloc] init];
    }
    return self;
}

+(NSArray *)parseStaticLrc:(NSString *)lrc {
    if (lrc && lrc.length>0) {
        return [lrc componentsSeparatedByString:@"\n"];
    } else {
        //[SVProgressHUD showErrorWithStatus:@"歌词数据错误"];
        //[HFVProgressHud showErrorWithStatus:@"歌词数据错误"];
        return nil;
    }
}

-(void)parsedynamicLrc:(NSString *)lrc{
    [self removeAllData];
    if(lrc && lrc.length>0){
        NSArray *sepArray=[lrc componentsSeparatedByString:@"["];
        NSArray *lineArray=[[NSArray alloc] init];
        for(int i=0;i<sepArray.count;i++){
            if([sepArray[i] length]>0){
                lineArray=[sepArray[i] componentsSeparatedByString:@"]"];
                if(![lineArray[0] isEqualToString:@"\n"]){
                    [self.timeArray addObject:lineArray[0]];
                    [self.wordArray addObject:lineArray.count>1?lineArray[1]:@""];
                }
            }
        }
    } else {
        //[SVProgressHUD showErrorWithStatus:@"歌词数据错误"];
        //[HFVProgressHud showErrorWithStatus:@"歌词数据错误"];
    }
}

-(void)removeHeadItems {
    NSMutableArray *tempTimeArray = [self.timeArray mutableCopy];
    for (int i=0; i<tempTimeArray.count; i++ ) {
        NSString *string = tempTimeArray[i];
        if ([string hasPrefix:@"00:"]) {
            //包含
            break;
        } else {
            //不包含
            [self.timeArray removeObjectAtIndex:0];
            [self.wordArray removeObjectAtIndex:0];
        }
    }
}

-(void)removeAllData {
    if (self.timeArray) {
        [self.timeArray removeAllObjects];
    }
    if (self.wordArray) {
        [self.wordArray removeAllObjects];
    }
}

-(float)calculateSongwordPlayDuration:(NSInteger)currentIndex total:(float)totalDuration{
    if (currentIndex<self.timeArray.count) {
        NSString *currentStr = self.timeArray[currentIndex];
        NSArray *currentArray=[currentStr componentsSeparatedByString:@":"];
        float currentTime=[currentArray[0] intValue]*60+[currentArray[1] floatValue];
        if (currentIndex+1<self.timeArray.count) {
            NSString *nextStr = self.timeArray[currentIndex+1];
            NSArray *nextArray=[nextStr componentsSeparatedByString:@":"];
            float nextTime=[nextArray[0] intValue]*60+[nextArray[1] floatValue];
            float duration = nextTime - currentTime;
            return duration;
        } else {
            return totalDuration - currentTime;
        }
    } else {
        return 0;
    }
}

@end
