//
//  YSBannerViewCell.h
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/1.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSBannerViewCell : UICollectionViewCell

/// 显示图片
@property (nonatomic, strong, readonly) UIImageView *showImageView;
/// 标题头
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 标题背景
@property (nonatomic, strong, readonly) UIView *titleLabelBgView;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleEdgeMargin;
@property (nonatomic, assign) BOOL isConfigured;

@end
