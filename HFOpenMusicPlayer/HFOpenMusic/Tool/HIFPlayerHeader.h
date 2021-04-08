//
//  Header.h
//  HIFPlayer
//
//  Created by 郭亮 on 2020/11/10.
//

#ifndef Header_h
#define Header_h

#import <Masonry.h>

typedef NS_ENUM(NSInteger, HIFLyricsProgressViewStates) {
    HIFLyricsProgressViewStatesShow = 0,
    HIFLyricsProgressViewStatesStart = 1,
    HIFLyricsProgressViewStatesPlaying = 2,
    HIFLyricsProgressViewStatesPasue = 3,
    HIFLyricsProgressViewStatesResume = 4,
    HIFLyricsProgressViewStatesReset = 5,
    HIFLyricsProgressViewStatesHidden = 6
};

typedef NS_ENUM(NSInteger, HIFPlayerBarViewStates) {
    HIFPlayerBarViewStatesPlaying = 0,
    HIFPlayerBarViewStatesPasue = 1,
    HIFPlayerBarViewStatesReplay = 2,
    HIFPlayerBarViewStatesReset = 3,
};

typedef NS_ENUM(NSInteger, HIFPlayLyricType) {
    HIFPlayLyricTypeNone = 0,
    HIFPlayLyricTypeDynamic = 1,
    HIFPlayLyricTypeStatic = 2
};

typedef NS_ENUM(NSInteger, HIFPlayerStates) {
    HIFPlayerStatesInit = 0,
    HIFPlayerStatesUnknow = 1,
    HIFPlayerStatesLoading = 2,
    HIFPlayerStatesReadyToPlay = 3,
    HIFPlayerStatesResumePlay = 4,
    HIFPlayerStatesPasue = 5,
    HIFPlayerStatesBufferEmpty = 6,
    HIFPlayerStatesBufferKeepUp = 7,
    HIFPlayerStatesFailed = 8,
    HIFPlayerStatesFinished = 9,
    HIFPlayerStatesStoped = 10,
  //  HIFPlayerStatesSecondDownloading = 11
//    HIFPlayerStatesSecondDownloading = 10,
//    HIFPlayerStatesSecondDownComplete = 11,
};
typedef NS_ENUM(NSInteger, HIFPlayerSecondStates) {
    HIFPlayerSecondStatesDownloading = 1,
    HIFPlayerSecondStatesDownloadComplete = 2,
    HIFPlayerSecondStatesDownNormol = 3
};

#define HIFUpdateDataCacheKey @"hfvmusicdata"

#endif /* Header_h */
