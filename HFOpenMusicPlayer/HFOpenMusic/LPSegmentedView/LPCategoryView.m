//
//  LPCategoryView.m
//  HFVMusicKit
//
//  Created by Pan on 2020/11/3.
//


#import "LPCategoryView.h"
#import "Masonry.h"
#import "HFVCategoryFlowLayout.h"

@interface LPCategoryCollectionCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@end;

@implementation LPCategoryCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface LPCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *underline;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL selectedCellExist;
@property (nonatomic, strong) HFVCategoryFlowLayout *flowLayout;
@end

static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";

@implementation LPCategoryView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = self.originalIndex;
        _height = LPCategoryViewDefaultHeight;
        _underlineHeight = 1.8;
        _cellSpacing = KScale(10);
        _leftAndRightMargin = _cellSpacing;
        self.backgroundColor = KColorHex(0x282828);
        self.titleNormalColor = KColorHex(0x8E8E93);
        self.titleSelectedColor = KColorHex(0xD52222);
        self.titleNomalFont = [UIFont systemFontOfSize:18];
        self.titleSelectedFont = [UIFont systemFontOfSize:20];
        [self setupSubViews];
        self.underline.backgroundColor = self.titleSelectedColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.originalIndex > 0) {
        self.selectedIndex = self.originalIndex;
    } else {
        _selectedIndex = 0;
        [self setupMoveLineDefaultLocation];
    }
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (self.selectedIndex == targetIndex) {
        return;
    }
    LPCategoryCollectionCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        selectedCell.titleLabel.textColor = self.titleNormalColor;
        selectedCell.titleLabel.font = self.titleNomalFont;
    }
    LPCategoryCollectionCell *targetCell = [self getCell:targetIndex];
    if (targetCell) {
        targetCell.titleLabel.textColor = self.titleSelectedColor;
        targetCell.titleLabel.font = self.titleSelectedFont;
    }
    self.selectedIndex = targetIndex;
    self.originalIndex = targetIndex;
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.underline];
    [self addSubview:self.separator];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.height - HFV_ONE_PIXEL);
    }];
    [self.underline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.underlineHeight - HFV_ONE_PIXEL);
        make.height.mas_equalTo(self.underlineHeight);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HFV_ONE_PIXEL);
    }];
}

- (LPCategoryCollectionCell *)getCell:(NSUInteger)index {
    return (LPCategoryCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedItemHelper) {
        self.selectedItemHelper(self.selectedIndex);
    }
    
    LPCategoryCollectionCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateMoveLineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateMoveLineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupMoveLineDefaultLocation {
    CGFloat cellWidth = [self getWidthWithContent:self.titles[0]];
    [self.underline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(cellWidth);
        make.left.mas_equalTo(self.leftAndRightMargin);
    }];
}

- (void)updateMoveLineLocation {
    LPCategoryCollectionCell *cell = [self getCell:self.selectedIndex];
    [UIView animateWithDuration:0.15 animations:^{
        [self.underline mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.height - self.underlineHeight - HFV_ONE_PIXEL);
            make.height.mas_equalTo(self.underlineHeight);
            make.width.centerX.equalTo(cell.titleLabel);
        }];
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height - HFV_ONE_PIXEL)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:self.titleSelectedFont}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = [self getWidthWithContent:self.titles[indexPath.row]];
    if (indexPath.row>0) {
        CGFloat lastWidth = [self getWidthWithContent:self.titles[indexPath.row-1]];
        if (itemWidth == lastWidth) {
            itemWidth -= 0.05;
        }
    }
    return CGSizeMake(itemWidth, self.collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.cellSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.leftAndRightMargin, 0, self.rightMargin ? self.rightMargin : self.leftAndRightMargin);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.titleLabel.textColor = self.selectedIndex == indexPath.row ? self.titleSelectedColor : self.titleNormalColor;
    cell.titleLabel.font = self.selectedIndex == indexPath.row ? self.titleSelectedFont : self.titleNomalFont;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateMoveLineLocation];
    }
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (self.titles.count == 0) {
        return;
    }
    if (selectedIndex >= self.titles.count) {
        _selectedIndex = self.titles.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    [self layoutAndScrollToSelectedItem];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles.copy;
}

- (void)setHeight:(CGFloat)categoryViewHeight {
    _height = categoryViewHeight;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(categoryViewHeight - HFV_ONE_PIXEL);
    }];
    [self.underline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(categoryViewHeight - self.underlineHeight - HFV_ONE_PIXEL);
    }];
}

- (void)setUnderlineHeight:(CGFloat)underlineHeight {
    _underlineHeight = underlineHeight;
    [self.underline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.underlineHeight - HFV_ONE_PIXEL);
    }];
}

- (void)setCellSpacing:(CGFloat)cellSpacing {
    _cellSpacing = cellSpacing;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)setLeftAndRightMargin:(CGFloat)leftAndRightMargin {
    _leftAndRightMargin = leftAndRightMargin;
    self.flowLayout.leftMargin = leftAndRightMargin;
    [self.collectionView.collectionViewLayout invalidateLayout];
}
- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       self.flowLayout = [[HFVCategoryFlowLayout alloc] init];
        _flowLayout.leftMargin = self.leftAndRightMargin;
         _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = KColorHex(0x282828);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[LPCategoryCollectionCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)underline {
    if (!_underline) {
        _underline = [[UIView alloc] init];
    }
    return _underline;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor lightGrayColor];
    }
    return _separator;
}

@end
