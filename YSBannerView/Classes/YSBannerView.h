//
//  YSBannerView.h
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/1.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 指示器位置 */
typedef NS_ENUM(NSUInteger, YSPageControlAliment) {
    YSPageControlAlimentLeft = 0,     // 居左
    YSPageControlAlimentCenter,       // 居中
    YSPageControlAlimentRight,        // 居右
};

/** 指示器样式 */
typedef NS_ENUM(NSInteger, YSPageControlStyle) {
    YSPageControlNone = 0,            // 无
    YSPageControlSystem,              // 系统自带
    YSPageControlHollow,              // 空心的
};

/** 滚动方向   */
typedef NS_ENUM(NSInteger, YSBannerViewDirection) {
    YSBannerViewDirectionLeft = 0,    // 向左
    YSBannerViewDirectionRight,       // 向右
    YSBannerViewDirectionTop,         // 向上
    YSBannerViewDirectionBottom       // 向下
};

@protocol YSBannerViewDataSource, YSBannerViewDelegate;

@interface YSBannerView : UIView

@property (nonatomic, weak) IBOutlet id<YSBannerViewDelegate> delegate;

@property (nonatomic, assign) YSBannerViewDirection scrollDirection;    ///< 滚动方向 默认: YSBannerViewDirectionLeft
@property (nonatomic, assign) YSPageControlStyle    pageControlStyle;   ///< 指示器样式 默认: YSPageControlStyleSystem
@property (nonatomic, assign) YSPageControlAliment  pageControlAliment; ///< 指示器位置 默认: YSPageControlAlimentCenter
@property (nonatomic, assign) UIViewContentMode     imageContentMode;   ///< 填充样式 默认: ScaleAspectFill
@property (nonatomic, assign) BOOL    autoScroll;                       ///< 是否自动滚动 默认: YES
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;           ///< 滚动时间间隔 默认: 3s
@property (nonatomic, assign) BOOL    infiniteLoop;                     ///< 是否循环滚动 默认: YES
@property (nonatomic, strong) UIImage *emptyImage;                      ///< 空数据图片
@property (nonatomic, strong) UIImage *placeholderImage;                ///< 占位图，用于网络未加载到图片时
@property (nonatomic, assign) BOOL    onlyDisplayText;                  ///< 只展示文字轮播
@property (nonatomic, assign) BOOL    hidesForSinglePage;               ///< 是否在只有一张图时隐藏pagecontrol，默认: YES
@property (nonatomic, assign) BOOL    showPageControl;                  ///< 是否展示分页控件
@property (nonatomic, assign) CGFloat pageControlBottomMargin;          ///< 分页控件距离底部间距 默认: 10
@property (nonatomic, assign) CGFloat pageControlHorizontalMargin;      ///< 分页控件水平边缘间距 默认: 10
@property (nonatomic, assign) CGFloat pageControlPadding;               ///< 分页控件上间距,系统样式无效 默认: 5
@property (nonatomic, assign) CGSize  pageDotSize;                      ///< 分页控件圆标大小 默认: 8*8
@property (nonatomic, strong) UIColor *pageDotColor;                    ///< 分页控件小圆标正常颜色
@property (nonatomic, strong) UIColor *currentPageDotColor;             ///< 当前分页控件小圆标颜色
@property (nonatomic, strong) UIImage *pageDotImage;                    ///< 分页控件小圆标正常图片
@property (nonatomic, strong) UIImage *currentPageDotImage;             ///< 当前分页控件小圆标图片

@property (nonatomic, strong) UIFont  *titleFont;                       ///< 文字大小 默认: 14.0f
@property (nonatomic, strong) UIColor *titleColor;                      ///< 文字颜色 默认: whiteColor
@property (nonatomic, strong) UIColor *titleBackgroundColor;            ///< 文字背景颜色 默认: 黑0.5
@property (nonatomic, assign) CGFloat titleHeight;                      ///< 文字高度 默认: 30
@property (nonatomic, assign) CGFloat titleEdgeMargin;                  ///< 文字边缘间距 默认: 10
@property (nonatomic, assign) NSTextAlignment titleAlignment;           ///< 文字对齐方式 默认: Left

/// 自定义设置网络和默认图片的方法
@property (nonatomic, copy) void(^downloadImageBlock)(UIImageView *imageView, NSURL *url, UIImage *placeholderImage);
@property (nonatomic, copy) void(^didScrollToIndexBlock)(NSInteger index);
@property (nonatomic, copy) void(^didSelectItemAtIndexBlock)(NSInteger index);

+ (instancetype)bannerViewWithFrame:(CGRect)frame;
+ (instancetype)bannerViewWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

/// 展示图片数组
@property (nonatomic, strong) NSArray *imageArray;
/// 展示文字数组
@property (nonatomic, strong) NSArray *titleArray;

/// 调整滚动到指定位置
- (void)adjustBannerViewScrollToIndex:(NSInteger)index animated:(BOOL)animated;

/// 禁用滑动手势
- (void)disableScrollGesture;

@end

@protocol YSBannerViewDelegate <NSObject>

@optional

/// 自定义Cell的样式 返回自定义 Cell 的 Class
- (Class)bannerViewRegistCustomCellClass:(YSBannerView *)bannerView;
/// 自定义Cell的样式 返回自定义 Cell 的 Nib
- (UINib *)bannerViewRegistCustomCellNib:(YSBannerView *)bannerView;
/// 自定义 Cell 刷新数据或者其他配置
- (void)bannerView:(YSBannerView *)bannerView setupCell:(UICollectionViewCell *)cell index:(NSInteger)index;

/// 滚动到 index
- (void)bannerView:(YSBannerView *)bannerView didScrollToIndex:(NSInteger)index;
/// 点击回调
- (void)bannerView:(YSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end
