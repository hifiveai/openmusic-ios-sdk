//
//  LPMJGifHeader.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/12.
//

#import "LPMJGifHeader.h"

@implementation LPMJGifHeader

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    //GIF数据
    NSArray * idleImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:30];
    NSArray * refreshingImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:30];
    //普通状态
    [self setImages:idleImages duration:1.2 forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:refreshingImages duration:1.2 forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages duration:1.2 forState:MJRefreshStateRefreshing];
}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage * image =  [UIImage imageNamed:[NSString stringWithFormat:@"HFOpenMusic.bundle/reloading-%ld.png", i]];
        CGSize newSize = CGSizeMake(KScale(30), KScale(30));
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (newImage) {
            [imageArray addObject:newImage];
        }
    }
    return imageArray;
}

#pragma mark - 实现父类的方法
- (void)placeSubviews {
    [super placeSubviews];
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
}



@end
