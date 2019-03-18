//
//  YSAnimatedDotView.m
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/7.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSAnimatedDotView.h"

static CGFloat const kAnimateDuration = 0;

@implementation YSAnimatedDotView

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.layer.borderColor = dotColor.CGColor;
}

- (void)setCurrentDotColor:(UIColor *)currentDotColor {
    _currentDotColor = currentDotColor;
    self.backgroundColor = [UIColor clearColor];
}

- (void)initialization {
    _dotColor = [UIColor whiteColor];
    _currentDotColor = [UIColor whiteColor];
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
    self.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.layer.borderWidth  = 1.5;
    self.resizeScale = 1.4f;
}

- (void)changeActivityState:(BOOL)active {
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}

- (void)animateToActiveState {
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self.currentDotColor;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.transform = CGAffineTransformMakeScale(self.resizeScale, self.resizeScale);
    } completion:nil];
}

- (void)animateToDeactiveState {
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = self.dotColor.CGColor;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
