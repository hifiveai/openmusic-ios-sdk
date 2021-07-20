//
//  HIFParseLyricTool.h
//  HIFPlayer
//
//  Created by 郭亮 on 2020/11/9.
//

#import <Foundation/Foundation.h>

@interface HIFParseLyricTool : NSObject
//time
@property (nonatomic,strong) NSMutableArray *timeArray;
//song word
@property (nonatomic,strong) NSMutableArray *wordArray;

+(NSArray *) parseStaticLrc:(NSString *)lrc;

//parse song word
-(void) parsedynamicLrc:(NSString *)lrc;

//remove headData
-(void)removeHeadItems;

//remove allData
-(void)removeAllData;

//calculate songword playduration
-(float)calculateSongwordPlayDuration:(NSInteger)currentIndex total:(float) totalDuration;

@end


