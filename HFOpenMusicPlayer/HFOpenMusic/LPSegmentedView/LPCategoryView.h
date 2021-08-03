//
//  LPCategoryView.h
//  HFVMusicKit
//
//  Created by Pan on 2020/11/3.
//


#import <UIKit/UIKit.h>

static const CGFloat LPCategoryViewDefaultHeight = 50.0;

@interface LPCategoryCollectionCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *underline;
@end;

@interface LPCategoryView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// 分割线
@property (nonatomic, strong, readonly) UIView *separator;
@property (nonatomic, strong) UIFont *titleNomalFont;
@property (nonatomic, strong) UIFont *titleSelectedFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic) NSInteger originalIndex;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat underlineHeight;
@property (nonatomic) CGFloat cellSpacing;
@property (nonatomic) CGFloat leftAndRightMargin; // default = cellSpacing
@property (nonatomic) CGFloat rightMargin; // default = leftAndRightMargin


@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;

@end
