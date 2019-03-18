//
//  YSBannerViewCell.m
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/1.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSBannerViewCell.h"

@interface YSBannerViewCell ()

/// 显示图片
@property (nonatomic, strong, readwrite) UIImageView *showImageView;
/// 标题头
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
/// 标题背景
@property (nonatomic, strong, readwrite) UIView *titleLabelBgView;

@end

@implementation YSBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _ys_setupUI];
    }
    return self;
}

- (void)_ys_setupUI {
    [self.contentView addSubview:self.showImageView];
    [self.contentView addSubview:self.titleLabelBgView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.showImageView.frame = self.bounds;
    
    CGFloat titleBgViewH = self.titleHeight;
    CGFloat titleBgViewX = 0.0;
    CGFloat titleBgViewY = self.bounds.size.height - titleBgViewH;
    CGFloat titleBgViewW = self.bounds.size.width - 2 * titleBgViewX;
    self.titleLabelBgView.frame = CGRectMake(titleBgViewX, titleBgViewY, titleBgViewW, titleBgViewH);
    
    CGFloat titleLabelH = self.titleHeight;
    CGFloat titleLabelX = self.titleEdgeMargin;
    CGFloat titleLabelY = self.bounds.size.height - titleLabelH;
    CGFloat titleLabelW = self.bounds.size.width - 2 * titleLabelX;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}

#pragma mark - # Getter
- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
    }
    return _showImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.hidden = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIView *)titleLabelBgView {
    if (!_titleLabelBgView) {
        _titleLabelBgView = [[UIView alloc] init];
        _titleLabelBgView.hidden = YES;
    }
    return _titleLabelBgView;
}

@end
