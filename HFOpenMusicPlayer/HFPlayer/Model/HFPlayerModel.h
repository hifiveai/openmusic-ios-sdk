//
//  HFPlayerModel.h
//  HFPlayer
//
//  Created by 郭亮 on 2021/3/25.
//

#import <Foundation/Foundation.h>
@class HFPlayerMusicAuthorModel,HFPlayerMusicComposerModel,HFPlayerMusicArrangerModel,HFPlayerMusicCoverModel,HFPlayerChannelSheetTagModel,HFPlayerMusicVersionModel,HFPlayerMusicArtistModel;

@interface HFPlayerModel : NSObject

@end

@interface HFPlayerMusicModel : NSObject

@property(nonatomic ,copy)                                NSString *musicId;//音乐id
@property(nonatomic ,copy)                                NSString *musicName;//音乐名
@property(nonatomic ,copy)                                NSString *albumId;//专辑id
@property(nonatomic ,copy)                                NSString *albumName;//专辑名
@property(nonatomic ,copy)                                NSString *duration;//时长（秒），此字段可能和播放器读取时长有一定误差
@property(nonatomic ,copy)                                NSString *auditionBegin;//推荐试听开始时间
@property(nonatomic ,copy)                                NSString *auditionEnd;//推荐试听结束时间
@property(nonatomic ,copy)                                NSString *bpm;//每分钟节拍
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicAuthorModel *>*author;//作词者
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicComposerModel *>*composer;//作曲者
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicArrangerModel *>*arranger;//编曲者
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicCoverModel *>*cover;//封面
@property(nonatomic ,copy)                                NSArray <HFPlayerChannelSheetTagModel *>*tag;//标签数组
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicVersionModel *>*version;//版本信息
@property(nonatomic ,copy)                                NSArray <HFPlayerMusicArtistModel *>*artist;//表演者

@end

@interface HFPlayerMusicArtistModel : NSObject

@property(nonatomic ,copy)                                NSString *name;//表演者
@property(nonatomic ,copy)                                NSString *code;//表演者编号
@property(nonatomic ,copy)                                NSString *avatar;//表演者头像

@end


@interface HFPlayerMusicAuthorModel : NSObject

@property(nonatomic ,copy)                                NSString *name;//作词者
@property(nonatomic ,copy)                                NSString *code;//作词者编号
@property(nonatomic ,copy)                                NSString *avatar;//作词者头像

@end



@interface HFPlayerMusicComposerModel : NSObject

@property(nonatomic ,copy)                                NSString *name;//作曲者
@property(nonatomic ,copy)                                NSString *code;//作曲者编号
@property(nonatomic ,copy)                                NSString *avatar;//作曲者头像

@end


@interface HFPlayerMusicArrangerModel : NSObject

@property(nonatomic ,copy)                                NSString *name;//编曲者
@property(nonatomic ,copy)                                NSString *code;//编曲者编号
@property(nonatomic ,copy)                                NSString *avatar;//编曲者头像

@end



@interface HFPlayerMusicCoverModel : NSObject

@property(nonatomic ,copy)                                NSString *url;//封面
@property(nonatomic ,copy)                                NSString *size;//封面尺寸，该字段可能为""，代表没有设置尺寸

@end



@interface HFPlayerMusicVersionModel : NSObject

@property(nonatomic ,copy)                                NSString *musicId;
@property(nonatomic ,copy)                                NSString *name;
@property(nonatomic ,copy)                                NSString *majorVersion;
@property(nonatomic ,copy)                                NSString *free;
@property(nonatomic ,copy)                                NSString *price;
@property(nonatomic ,copy)                                NSString *duration;
@property(nonatomic ,copy)                                NSString *auditionBegin;
@property(nonatomic ,copy)                                NSString *auditionEnd;

@end


@interface HFPlayerMusicDetailInfoModel : NSObject

@property(nonatomic ,copy)                                NSString *musicId;
@property(nonatomic ,copy)                                NSString *expires;
@property(nonatomic ,copy)                                NSString *fileUrl;
@property(nonatomic ,copy)                                NSString *fileSize;
@property(nonatomic ,copy)                                NSString *waveUrl;

@end

