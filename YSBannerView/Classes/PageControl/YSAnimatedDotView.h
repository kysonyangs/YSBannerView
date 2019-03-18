//
//  YSAnimatedDotView.h
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/7.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSAbstractDotView.h"

@interface YSAnimatedDotView : YSAbstractDotView

@property (nonatomic, strong) UIColor *dotColor;
@property (nonatomic, strong) UIColor *currentDotColor;
@property (nonatomic, assign) CGFloat resizeScale; /**< 调整比例 */

@end
