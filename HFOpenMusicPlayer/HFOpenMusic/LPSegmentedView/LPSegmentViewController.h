//
//  LPSegmentViewController.h
//
//  Created by Pan on 2020/11/3.
//

#import <UIKit/UIKit.h>
#import "LPCategoryView.h"

@protocol LPSegmentControllerDelegate <NSObject>
@optional
- (void)segmentedPageViewControllerWillBeginDragging;
- (void)segmentedPageViewControllerDidEndDragging;
- (void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index;
@end

@interface LPSegmentViewController  : UIViewController
@property (nonatomic, strong, readonly) LPCategoryView *categoryView;
@property (nonatomic, copy) NSArray<UIViewController *> *pageViewControllers;
@property (nonatomic, strong, readonly) UIViewController *currentPageViewController;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id<LPSegmentControllerDelegate> delegate;

@end

