//
//  YSHollowPageControl.h
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/7.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAbstractDotView.h"

@class YSHollowPageControl;
@protocol YSHollowPageControlDelegate <NSObject>

@optional
- (void)hollowPageControl:(YSHollowPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

@interface YSHollowPageControl : UIControl

@property (nonatomic, assign) CGSize dotSize;           /**< 圆点大小 默认8*8 */
@property (nonatomic, strong) UIImage *dotNormalImage;  /**< 普通样式 */
@property (nonatomic, strong) UIImage *dotCurrentImage; /**< 选中样式 */

@property (nonatomic, strong) UIColor *dotNormalColor;  /**< 点色 */
@property (nonatomic, strong) UIColor *dotCurrentColor; /**< 当前圆点的颜色 */

@property (nonatomic, strong) Class dotViewClass;       /**< 圆点类 */
@property (nonatomic, weak) id<YSHollowPageControlDelegate> delegate; /**< 代理 */
@property (nonatomic, assign) CGFloat spacing;          /**< 间距 默认 8 */
@property (nonatomic, assign) NSInteger numberOfPages; /**< 数量 */
@property (nonatomic, assign) NSInteger currentPage; /**< 当前位置 */
@property (nonatomic, assign) BOOL hidesForSinglePage; /**< 单个不显示 默认NO*/
@property (nonatomic, assign) BOOL shouldResizeFromCenter; /**< 是否调整大小 */
@property (nonatomic, assign) CGFloat resizeScale; /**< 调整比例 */

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end

@interface YSDotView : YSAbstractDotView

@end
