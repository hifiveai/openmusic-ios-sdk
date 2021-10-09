//
//  HFVMusicListPlaceholder.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol placeholderViewDelegate <NSObject>
@optional
-(void)addMusic;                    //
@end

@interface HFVMusicListPlaceholder : UIView

@property (nonatomic, weak) id<placeholderViewDelegate>  delegate;


@end

NS_ASSUME_NONNULL_END
