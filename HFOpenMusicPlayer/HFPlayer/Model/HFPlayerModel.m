//
//  HFPlayerModel.m
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/25.
//

#import "HFPlayerModel.h"

@implementation HFPlayerModel

@end


@implementation HFPlayerMusicModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        
        @"author" : @"HFPlayerMusicAuthorModel",
        @"composer": @"HFPlayerMusicComposerModel",
        @"arranger": @"HFPlayerMusicArrangerModel",
        @"cover": @"HFPlayerMusicCoverModel",
        @"tag": @"HFPlayerChannelSheetTagModel",
        @"version": @"HFPlayerMusicVersionModel",
        @"artist" : @"HFPlayerMusicArtistModel",
    };
}

@end


@implementation HFPlayerMusicArtistModel

@end


@implementation HFPlayerMusicAuthorModel

@end


@implementation HFPlayerMusicComposerModel

@end


@implementation HFPlayerMusicArrangerModel

@end


@implementation HFPlayerMusicCoverModel

@end


@implementation HFPlayerMusicVersionModel

@end

@implementation HFPlayerMusicDetailInfoModel

@end
