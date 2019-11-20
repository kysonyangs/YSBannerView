//
//  YSBannerView.m
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/1.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSBannerView.h"
#import "YSBannerViewCell.h"
#import "YSHollowPageControl.h"
@class YSBannerFlowLayout;

static NSInteger const kTotalCount = 100;
#define kPageControlDotDefaultSize CGSizeMake(8, 8)
NSString * const YSBannerViewCellID = @"YSBannerViewCellID";

@interface YSBannerFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat zoomFactor; // default 0.f
@end

@interface YSBannerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _totalItemsCount;
    CGPoint _lastPoint;
    NSInteger _dragDirection;
}
@property (nonatomic, strong) UIImageView *backgroundImageView; // 无数据展示
@property (nonatomic, strong) YSBannerFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIControl *pageControl;
@property (nonatomic, weak  ) NSTimer *timer;

@end

@implementation YSBannerView

#pragma mark - # life cycle
+ (instancetype)bannerViewWithFrame:(CGRect)frame {
    YSBannerView *bannerView = [[self alloc] initWithFrame:frame];
    return bannerView;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray {
    YSBannerView *bannerView = [[self alloc] initWithFrame:frame];
    bannerView.imageArray = imageArray;
    return bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _ys_initializer];
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _ys_initializer];
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.collectionView];
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self _ys_initializer];
//    
//    [self addSubview:self.backgroundImageView];
//    [self addSubview:self.collectionView];
//}

- (void)_ys_initializer {
    self.backgroundColor = [UIColor whiteColor];
    
    _itemSize = self.bounds.size;
    _itemSpacing = 0;
    _itemZoomFactor = 0;
    
    _scrollDirection = YSBannerViewDirectionLeft;
    _autoScrollTimeInterval = 2.0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _imageContentMode = UIViewContentModeScaleAspectFill;
    _onlyDisplayText = NO;

    _hidesForSinglePage = YES;
    _showPageControl = YES;
    _pageControlStyle = YSPageControlSystem;
    _pageControlAliment = YSPageControlAlimentCenter;
    _pageDotSize = kPageControlDotDefaultSize;
    _pageControlBottomMargin = 10.0;
    _pageControlHorizontalMargin = 10.0;
    _pageControlPadding = 5.0;
    _pageDotColor = [UIColor lightGrayColor];
    _currentPageDotColor = [UIColor whiteColor];
    
    _titleFont            = [UIFont systemFontOfSize:14.0];
    _titleColor           = [UIColor whiteColor];
    _titleAlignment       = NSTextAlignmentLeft;
    _titleBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _titleHeight          = 30.0;
    _titleEdgeMargin      = 10.0;
}

- (void)layoutSubviews {
    self.delegate = self.delegate;
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    self.collectionView.frame = self.bounds;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        self.flowLayout.itemSize = CGSizeMake(self.itemSize.width, self.bounds.size.height);
        self.flowLayout.minimumLineSpacing = self.itemSpacing;
        self.flowLayout.headerReferenceSize = CGSizeMake(self.itemSpacing, self.bounds.size.height);
        self.flowLayout.footerReferenceSize = CGSizeMake(self.itemSpacing, self.bounds.size.height);
    } else {
        self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.itemSize.height);
        self.flowLayout.minimumInteritemSpacing = self.itemSpacing;
        self.flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, self.itemSpacing);
        self.flowLayout.footerReferenceSize = CGSizeMake(self.bounds.size.width, self.itemSpacing);
    }
    
    if ((self.collectionView.contentOffset.x == 0 || self.collectionView.contentOffset.y == 0) && _totalItemsCount > 0) {
        NSInteger targetIndex = self.infiniteLoop ? (_totalItemsCount * 0.5) : 0;
        [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        _lastPoint = self.collectionView.contentOffset;
        NSLog(@"%f - %f", _lastPoint.x, _lastPoint.y);
    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(kPageControlDotDefaultSize, self.pageDotSize))) {
            pageControl.dotSize = self.pageDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.imageArray.count];
    } else {
        size = CGSizeMake(self.imageArray.count * self.pageDotSize.width * 1.5, self.pageDotSize.height);
    }
    
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    if (self.pageControlAliment == YSPageControlAlimentLeft) {
        x = 0.0f;
    } else if (self.pageControlAliment == YSPageControlAlimentRight) {
        x = self.bounds.size.width - size.width;
    }
    
    CGFloat y = self.bounds.size.height - size.height;
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    if (self.pageControlAliment == YSPageControlAlimentLeft) {
        pageControlFrame.origin.x += self.pageControlHorizontalMargin;
    } else if (self.pageControlAliment == YSPageControlAlimentRight){
        pageControlFrame.origin.x -= self.pageControlHorizontalMargin;
    }
    pageControlFrame.origin.y -= self.pageControlBottomMargin;
    self.pageControl.frame = pageControlFrame;
    
    self.pageControl.hidden = self.pageControlStyle == YSPageControlNone;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self _ys_invalidateTimer];
    }
}

#pragma mark - # Public Method

- (void)adjustBannerViewScrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.imageArray.count == 0) { return; }
    if (index >= 0 && index < self.imageArray.count) {
        if (self.autoScroll) { [self _ys_invalidateTimer]; }
        
        [self _ys_scrollToIndex:((int)(_totalItemsCount * 0.5 + index)) animated:animated];
        
        if (self.autoScroll) { [self _ys_setupTimer]; }
    }
}

- (void)disableScrollGesture {
    self.collectionView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.collectionView removeGestureRecognizer:gesture];
        }
    }
}

#pragma mark - Private Helper
- (void)_ys_automaticScrollAction {
    if (_totalItemsCount == 0) return;
    NSInteger currentIndex = [self _ys_currentPageIndex];
    if (self.scrollDirection == YSBannerViewDirectionLeft || self.scrollDirection == YSBannerViewDirectionTop) {
        [self _ys_scrollToIndex:(currentIndex + 1) animated:YES];
    } else if (self.scrollDirection == YSBannerViewDirectionRight || self.scrollDirection == YSBannerViewDirectionBottom) {
        if ((currentIndex - 1) < 0) { // 小于零
            currentIndex = self.infiniteLoop?(_totalItemsCount * 0.5):(0);
            [self _ys_scrollBannerViewToSpecifiedPositionIndex:(currentIndex - 1) animated:NO];
        } else {
            [self _ys_scrollToIndex:(currentIndex - 1) animated:YES];
        }
    }
}

- (void)_ys_setupTimer {
    [self _ys_invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(_ys_automaticScrollAction) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)_ys_invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)_ys_invalidateTimerWhenAutoScroll {
    if (self.autoScroll) {
        [self _ys_invalidateTimer];
    }
}

- (void)_ys_startTimerWhenAutoScroll{
    if (self.autoScroll) {
        [self _ys_setupTimer];
    }
}

- (void)_ys_setupPageControl {
    if (_pageControl) [_pageControl removeFromSuperview];
    if (self.imageArray.count == 0 || self.onlyDisplayText ||
        (self.imageArray.count == 1 && self.hidesForSinglePage)) return;
    
    NSInteger indexOnPageControl = [self _ys_getRealIndexFromCurrentCellIndex:[self _ys_currentPageIndex]];
    
    switch (self.pageControlStyle) {
            case YSPageControlSystem: {
                UIPageControl *pageControl = [[UIPageControl alloc] init];
                pageControl.numberOfPages = self.imageArray.count;
                pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
                pageControl.pageIndicatorTintColor = self.pageDotColor;
                pageControl.userInteractionEnabled = NO;
                pageControl.currentPage = indexOnPageControl;
                [self addSubview:pageControl];
                self.pageControl = pageControl;
                break;
            }
            case YSPageControlHollow: {
                YSHollowPageControl *pageControl = [[YSHollowPageControl alloc] init];
                pageControl.numberOfPages = self.imageArray.count;
                pageControl.dotNormalColor = self.pageDotColor;
                pageControl.dotCurrentColor = self.currentPageDotColor;
                pageControl.userInteractionEnabled = NO;
                pageControl.resizeScale = 1.0;
                pageControl.spacing = self.pageControlPadding;
                pageControl.currentPage = indexOnPageControl;
                [self addSubview:pageControl];
                self.pageControl = pageControl;
                break;
            }
        default:
            break;
    }
    
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
    
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
}

- (NSInteger)_ys_currentPageIndex {
    if (self.collectionView.bounds.size.width == 0 || self.collectionView.bounds.size.height == 0) { return 0; }
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
    } else {
        index = (self.collectionView.contentOffset.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing) * 0.5) / (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing);
    }
    return MAX(0, index);
}

- (NSInteger)_ys_getRealIndexFromCurrentCellIndex:(NSInteger)cellIndex {
    return cellIndex % self.imageArray.count;
}

- (void)_ys_scrollToIndex:(NSInteger)targetIndex animated:(BOOL)animated {
    if (targetIndex >= _totalItemsCount) {  // 超过最大
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }
        [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        return;
    } else if (targetIndex < 0) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5 - 1;
        }
        [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        return;
    } else {
        [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:animated];
    }
}

/// 滚动到指定 Index
- (void)_ys_scrollBannerViewToSpecifiedPositionIndex:(NSInteger)targetIndex animated:(BOOL)animated {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    if (targetIndex < itemCount) {
        UICollectionViewScrollPosition position = UICollectionViewScrollPositionCenteredVertically;;
        if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            position = UICollectionViewScrollPositionCenteredHorizontally;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:position animated:animated];
    }
}

#pragma mark - # UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YSBannerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YSBannerViewCellID forIndexPath:indexPath];
    
    NSInteger itemIndex = [self _ys_getRealIndexFromCurrentCellIndex:indexPath.item];
    
    // CustomCell
    if ([self.delegate respondsToSelector:@selector(bannerViewRegistCustomCellClass:)] &&
        [self.delegate bannerViewRegistCustomCellClass:self] &&
        [self.delegate respondsToSelector:@selector(bannerView:setupCell:index:)]) {
        [self.delegate bannerView:self setupCell:cell index:itemIndex];
        return cell;
    } else if ([self.delegate respondsToSelector:@selector(bannerViewRegistCustomCellNib:)] &&
               [self.delegate bannerViewRegistCustomCellNib:self] &&
               [self.delegate respondsToSelector:@selector(bannerView:setupCell:index:)]) {
        [self.delegate bannerView:self setupCell:cell index:itemIndex];
        return cell;
    }
    
    NSString *imagePath = (itemIndex < self.imageArray.count)?self.imageArray[itemIndex]:nil;
    NSString *title     = (itemIndex < self.titleArray.count)?self.titleArray[itemIndex]:nil;
    
    if (!cell.isConfigured) {
        cell.titleLabelBgView.backgroundColor = self.titleBackgroundColor;
        cell.titleLabel.textColor = self.titleColor;
        cell.titleLabel.font = self.titleFont;
        cell.titleLabel.textAlignment = self.titleAlignment;
        cell.titleEdgeMargin = self.titleEdgeMargin;
        cell.titleHeight = self.onlyDisplayText ? self.bounds.size.height : self.titleHeight;
        cell.showImageView.contentMode = self.imageContentMode;
        cell.clipsToBounds = YES;
        cell.isConfigured = YES;
    }
    
    // 设置Cell内容
    cell.titleLabel.hidden = title.length == 0;
    cell.titleLabelBgView.hidden = title.length == 0;
    cell.titleLabel.text = title;
    
    cell.showImageView.hidden = imagePath.length == 0;
    if (imagePath) {
        if ([imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) { // 网络图片
                if (self.downloadImageBlock) {
                    self.downloadImageBlock(cell.showImageView, [NSURL URLWithString:imagePath], self.placeholderImage);
                }
            } else { // 本地文件
                if (imagePath.length > 0) {
                    UIImage *image = [UIImage imageNamed:imagePath];
                    if (!image) {
                        image = [UIImage imageWithContentsOfFile:imagePath];
                    }
                    if (!image) {
                        image = self.placeholderImage;
                    }
                    cell.showImageView.image = image;
                }
            }
        } else if ([imagePath isKindOfClass:[UIImage class]]) {
            cell.showImageView.image = (UIImage *)imagePath;
        } else {
            cell.showImageView.image = self.placeholderImage;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:[self _ys_getRealIndexFromCurrentCellIndex:indexPath.item]];
    }
}

#pragma mark - # UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imageArray.count) return; // 解决清除timer时偶尔会出现的问题
    
    NSInteger itemIndex = [self _ys_currentPageIndex];
    // 手动退拽时左右两端
    if (scrollView == self.collectionView && scrollView.isDragging && self.infiniteLoop) {
        NSInteger targetIndex = _totalItemsCount * 0.5;
        if (itemIndex == 0) { // top
            [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        } else if (itemIndex == (_totalItemsCount - 1)) { // bottom
            targetIndex -= 1;
            [self _ys_scrollBannerViewToSpecifiedPositionIndex:targetIndex animated:NO];
        }
    }
    
    NSInteger indexOnPageControl = [self _ys_getRealIndexFromCurrentCellIndex:itemIndex];
    // pageControl
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didScrollToIndex:)]) {
        [self.delegate bannerView:self didScrollToIndex:indexOnPageControl];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastPoint = scrollView.contentOffset;
    [self _ys_invalidateTimerWhenAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self _ys_startTimerWhenAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imageArray.count) return;
}

// 手离开屏幕的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!self.imageArray.count || !self.infiniteLoop) return;
    
    NSInteger itemIndex = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        float currentX = scrollView.contentOffset.x;
        float moveWidth = currentX - _lastPoint.x;
        int shouldPage = moveWidth / (self.flowLayout.itemSize.width * 0.33); // 移动距离超一半
        
        if (shouldPage < -1) {
            // TODO: 如果超出不想立即滚动的话得判断滑动距离中心点是否超出 未超出 _dragDirection = 0
            _dragDirection = 1;
        } else if (shouldPage > 1) {
            // TODO: 如果超出不想立即滚动的话得判断滑动距离中心点是否超出 未超出 _dragDirection = 0
            _dragDirection = -1;
        } else {
            if (velocity.x > 0 || shouldPage > 0) {
                _dragDirection = 1;
            } else if (velocity.x < 0 || shouldPage < 0) {
                _dragDirection = -1;
            } else {
                _dragDirection = 0;
            }
        }
        
        itemIndex = (_lastPoint.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
    } else {
        float currentY = scrollView.contentOffset.y;
        float moveHeight = currentY - _lastPoint.y;
        int shouldPage = moveHeight / (self.flowLayout.itemSize.height * 0.33); // 移动距离超一半
        if (shouldPage < -1) {
            _dragDirection = 1;
        } else if (shouldPage > 1) {
            _dragDirection = -1;
        } else {
            if (velocity.y > 0 || shouldPage > 0) {
                _dragDirection = 1;
            } else if (velocity.y < 0 || shouldPage < 0) {
                _dragDirection = -1;
            } else {
                _dragDirection = 0;
            }
        }
        
        itemIndex = (_lastPoint.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing) * 0.5) / (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing);
    }
    
    NSLog(@"----------");
    NSLog(@"_lastPoint: %f, contentOffset:%f, velocity:%f", _lastPoint.y, scrollView.contentOffset.y, velocity.y);
    NSLog(@"-1-itemIndex: %zd, _dragDirection:%zd", itemIndex,  _dragDirection);
    
    [self _ys_scrollToIndex:itemIndex + _dragDirection animated:YES];
}


// 开始减速的时候
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (!self.imageArray.count || !self.infiniteLoop) return;
    // 松开手指滑动开始减速的时候，设置滑动动画
    NSInteger itemIndex = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        itemIndex = (_lastPoint.x + (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing) * 0.5) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
    } else {
        itemIndex = (_lastPoint.y + (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing) * 0.5) / (self.flowLayout.itemSize.height + self.flowLayout.minimumInteritemSpacing);
    }
    
    NSLog(@"##########");
    NSLog(@"-2-itemIndex: %zd, _dragDirection:%zd", itemIndex,  _dragDirection);

    [self _ys_scrollToIndex:itemIndex + _dragDirection animated:YES];
}

#pragma mark - # Setter
- (void)setDelegate:(id<YSBannerViewDelegate>)delegate {
    _delegate = delegate;
    
    if ([delegate respondsToSelector:@selector(bannerViewRegistCustomCellClass:)] &&
        [delegate bannerViewRegistCustomCellClass:self]) {
        [self.collectionView registerClass:[delegate bannerViewRegistCustomCellClass:self] forCellWithReuseIdentifier:YSBannerViewCellID];
    } else if ([delegate respondsToSelector:@selector(bannerViewRegistCustomCellNib:)] &&
               [delegate bannerViewRegistCustomCellNib:self]) {
        [self.collectionView registerNib:[self.delegate bannerViewRegistCustomCellNib:self] forCellWithReuseIdentifier:YSBannerViewCellID];
    }
}

- (void)setImageArray:(NSArray *)imageArray {
    [self _ys_invalidateTimer];
    _imageArray = imageArray;
    
    _totalItemsCount = self.infiniteLoop ? imageArray.count * kTotalCount : imageArray.count;
    
    if (imageArray.count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.collectionView.scrollEnabled = NO;
        [self _ys_invalidateTimer];
    }
    
    [self _ys_setupPageControl];
    [self.collectionView reloadData];
    self.backgroundImageView.hidden = imageArray.count > 0;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titleArray.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageArray = [temp copy];
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    self.collectionView.pagingEnabled = !infiniteLoop;
    if (self.imageArray.count) {
        self.imageArray = self.imageArray;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self _ys_invalidateTimer];
    if (autoScroll) {
        [self _ys_setupTimer];
    }
}

- (void)setScrollDirection:(YSBannerViewDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    if (scrollDirection == YSBannerViewDirectionLeft || scrollDirection == YSBannerViewDirectionRight) {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    } else {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        self.flowLayout.itemSize = CGSizeMake(itemSize.width, self.bounds.size.height);
    } else {
        self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width, itemSize.height);
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        self.flowLayout.minimumLineSpacing = itemSpacing;
    } else {
        self.flowLayout.minimumInteritemSpacing = itemSpacing;
    }
}

- (void)setItemZoomFactor:(CGFloat)itemZoomFactor {
    _itemZoomFactor = itemZoomFactor;
    self.flowLayout.zoomFactor = itemZoomFactor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    self.backgroundImageView.contentMode = imageContentMode;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (!self.emptyImage) {
        self.emptyImage = placeholderImage;
    }
}

- (void)setEmptyImage:(UIImage *)emptyImage {
    if (emptyImage) {
        _emptyImage = emptyImage;
        self.backgroundImageView.image = emptyImage;
    }
}

- (void)setPageControlStyle:(YSPageControlStyle)pageControlStyle {
    _pageControlStyle = pageControlStyle;
    [self _ys_setupPageControl];
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

- (void)setPageDotSize:(CGSize)pageDotSize {
    _pageDotSize = pageDotSize;
    [self _ys_setupPageControl];
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageContol = (YSHollowPageControl *)_pageControl;
        pageContol.dotSize = pageDotSize;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor {
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        pageControl.dotNormalColor = pageDotColor;
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor {
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        pageControl.dotCurrentColor = currentPageDotColor;
    } else if ([self.pageControl isKindOfClass:[UIPageControl class]]){
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotImage:(UIImage *)pageDotImage {
    _pageDotImage = pageDotImage;
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage {
    _currentPageDotImage = currentPageDotImage;
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot {
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[YSHollowPageControl class]]) {
        YSHollowPageControl *pageControl = (YSHollowPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.dotCurrentImage = image;
        } else {
            pageControl.dotNormalImage = image;
        }
    }
}

#pragma mark - # 懒加载
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = self.imageContentMode;
    }
    return _backgroundImageView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[YSBannerFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[YSBannerViewCell class] forCellWithReuseIdentifier:YSBannerViewCellID];
    }
    return _collectionView;
}

@end

#pragma mark - YSBannerFlowLayout

@implementation YSBannerFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    if (self.zoomFactor < 0.00000001) { return attributes; }
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.size.height * 0.5;
            
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat distance = ABS(attr.center.y - centerY);
                CGFloat scale = 1 / (1 + distance * self.zoomFactor);
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
        default: {
            CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
            
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat distance = ABS(attr.center.x - centerX);
                // 距离越大，缩放比越小，距离越小，缩放比越大
                CGFloat scale = 1 / (1 + distance * self.zoomFactor);
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
    }
    
    return attributes;
}

/*!
*  多次调用 只要滑出范围就会 调用
*  当CollectionView的显示范围发生改变的时候，是否重新发生布局
*  一旦重新刷新 布局，就会重新调用
*  1.layoutAttributesForElementsInRect：方法
*  2.preparelayout方法
*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

@end
