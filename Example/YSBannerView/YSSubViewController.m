//
//  YSSubViewController.m
//  YSBannerView_Example
//
//  Created by Kyson on 2019/3/15.
//  Copyright © 2019 kysonyangs. All rights reserved.
//

#import "YSSubViewController.h"
#import "YSBannerView.h"
#import <UIImageView+WebCache.h>
#define kYJSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)

@interface YSSubViewController ()
@property (nonatomic, strong) YSBannerView *bannerView;
@end

@implementation YSSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, 100, kYJSCREEN_WIDTH, 200)];
    _bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    _bannerView.autoScrollTimeInterval = 2;
    _bannerView.titleFont = [UIFont systemFontOfSize:15];
    _bannerView.infiniteLoop = NO;
    _bannerView.scrollDirection = YSBannerViewDirectionRight;
    
    _bannerView.downloadImageBlock = ^(UIImageView *imageView, NSURL *url, UIImage *placeholderImage) {
        [imageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    };
    NSArray *imageArray = @[@"http://img.zcool.cn/community/01430a572eaaf76ac7255f9ca95d2b.jpg",
                            @"http://img.zcool.cn/community/0137e656cc5df16ac7252ce6828afb.jpg",
                            @"http://img.zcool.cn/community/01e5445654513e32f87512f6f748f0.png@900w_1l_2o_100sh.jpg",
                            @"http://www.aykj.net/front/images/subBanner/baiduV2.jpg"
                            ];
    _bannerView.imageArray = imageArray;
    [self.view addSubview:_bannerView];
}

@end
