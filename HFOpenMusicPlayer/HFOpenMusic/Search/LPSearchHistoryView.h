//
//  LPSearchHistoryView.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol searchHistoryDelegate <NSObject>

@optional
-(void)historySelectedTag:(NSString *)searchString;
@end

@interface LPSearchHistoryView : UIView

@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, weak) id<searchHistoryDelegate>  delegate;


-(void)addSearchText:(NSString *)searchString;
-(void)requestHistoryData;

@end

NS_ASSUME_NONNULL_END
