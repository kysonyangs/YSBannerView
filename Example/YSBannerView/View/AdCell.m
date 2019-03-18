//
//  AdCell.m
//  YSBannerView
//
//  Created by kysonyangs on 02/28/2019.
//  Copyright (c) 2019 kysonyangs. All rights reserved.
//

#import "AdCell.h"

@interface AdCell ()

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AdCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.headTagLabel];
    [self.contentView addSubview:self.contentLabel];
}

- (void)cellWithHeadHotLineCellData:(NSString *)string{
    self.contentLabel.text = string;
}

#pragma mark - Lazy
- (UILabel *)headTagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont boldSystemFontOfSize:12];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.backgroundColor = [UIColor orangeColor];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.text = @"促销";
        [_tagLabel.layer setCornerRadius:8.0f];
        _tagLabel.layer.masksToBounds = YES;
    }
    return _tagLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.headTagLabel.frame = CGRectMake(0, 10, 40, 20);
    
    self.contentLabel.frame = CGRectMake(45, 0, self.bounds.size.width - 50, 40);
}

@end
