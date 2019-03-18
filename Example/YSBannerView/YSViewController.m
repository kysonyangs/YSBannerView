//
//  YSViewController.m
//  YSBannerView
//
//  Created by kysonyangs on 02/28/2019.
//  Copyright (c) 2019 kysonyangs. All rights reserved.
//

#import "YSViewController.h"
#import "YSBannerView.h"
#import "AdCell.h"
#import <UIImageView+WebCache.h>
#import <YYWebImage/YYWebImage.h>
#import "YSSubViewController.h"

#define kYJSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)

@interface YSViewController () <YSBannerViewDelegate>
{
    NSArray *_adTitles;
}

@property (nonatomic, strong) UILabel *adLabel;
@property (nonatomic, strong) YSBannerView *emptyBannerView;
@property (nonatomic, strong) YSBannerView *leftBannerView;
@property (nonatomic, strong) YSBannerView *rightBannerView;
@property (nonatomic, strong) YSBannerView *adBannerView;
@property (nonatomic, strong) YSBannerView *topBannerView;
@property (nonatomic, strong) YSBannerView *bottomBannerView;

@end

@implementation YSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setupUI];
    [self prepareData];
}

- (void)setupUI {
    UIScrollView *containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:containerScrollView];
    
    [containerScrollView addSubview:self.emptyBannerView];
    [containerScrollView addSubview:self.leftBannerView];
    [containerScrollView addSubview:self.rightBannerView];
    [containerScrollView addSubview:self.adLabel];
    [containerScrollView addSubview:self.adBannerView];
    [containerScrollView addSubview:self.topBannerView];
    [containerScrollView addSubview:self.bottomBannerView];
    containerScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bottomBannerView.frame));    
}

- (void)prepareData {
    self.leftBannerView.downloadImageBlock =
    self.rightBannerView.downloadImageBlock = ^(UIImageView *imageView, NSURL *url, UIImage *placeholderImage) {
        [imageView sd_setImageWithURL:url placeholderImage:placeholderImage];
    };
    
    self.topBannerView.downloadImageBlock =
    self.bottomBannerView.downloadImageBlock = ^(UIImageView *imageView, NSURL *url, UIImage *placeholderImage) {
        [imageView yy_setImageWithURL:url placeholder:placeholderImage];
    };
    

    NSArray *imageArray = @[
                            @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1552895278&di=dd69d27f1f53d6d56387ef48cda1390e&src=http://img.zcool.cn/community/01b8c2588082ffa801219c771bf36b.jpg@2o.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552905366842&di=70fbc672b652c78a23913fe09b994e58&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F019026576b39b60000012e7e618718.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552905366842&di=e88b3c602028813f9f5f37cbd5c3fbe6&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01fea85739312e6ac72580ed798d33.jpg",
                           @"123",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552905366841&di=7a430f9cfa72446cc37fdd63fed82bb9&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a949581aeb9fa84a0d304fd05eeb.jpg"
                           ];
    self.leftBannerView.imageArray =
    self.rightBannerView.imageArray =
    self.topBannerView.imageArray =
    self.bottomBannerView.imageArray = imageArray;
    
    self.leftBannerView.titleArray = @[@"我是第一个标题"];
    self.rightBannerView.titleArray = @[@"One", @"Two", @"Three"];
    
    self.adBannerView.onlyDisplayText = YES;
    _adTitles = @[@"霸王防脱发，值得拥有，限时6折",
                  @"iPhoneX系列降价啦...",
                  @"二手手机换不锈钢脸盆啦..."];
    self.adBannerView.imageArray = _adTitles;
}

#pragma mark - lazy
- (YSBannerView *)emptyBannerView{
    if (!_emptyBannerView) {
        _emptyBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, 20, kYJSCREEN_WIDTH, 200)];
        _emptyBannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _emptyBannerView.emptyImage = [UIImage imageNamed:@"adempty.jpeg"];
        _emptyBannerView.delegate = self;
    }
    return _emptyBannerView;
}


- (YSBannerView *)leftBannerView{
    if (!_leftBannerView) {
        _leftBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.emptyBannerView.frame)+10, kYJSCREEN_WIDTH, 200)];
        _leftBannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        _leftBannerView.autoScrollTimeInterval = 2;
        _leftBannerView.titleFont = [UIFont systemFontOfSize:15];
        [_leftBannerView disableScrollGesture];
        _leftBannerView.delegate = self;
    }
    return _leftBannerView;
}

- (YSBannerView *)rightBannerView{
    if (!_rightBannerView) {
        _rightBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftBannerView.frame) + 15, kYJSCREEN_WIDTH, 200)];
        _rightBannerView.pageControlStyle = YSPageControlHollow;
        _rightBannerView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        _rightBannerView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        _rightBannerView.pageControlBottomMargin = 5.0f;
        _rightBannerView.scrollDirection = YSBannerViewDirectionRight;
        _rightBannerView.delegate = self;
        _rightBannerView.infiniteLoop = NO;
    }
    return _rightBannerView;
}

- (UILabel *)adLabel{
    if (!_adLabel) {
        _adLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.rightBannerView.frame) + 18, 70, 24)];
        _adLabel.font = [UIFont boldSystemFontOfSize:15];
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.backgroundColor = [UIColor clearColor];
        _adLabel.textColor = [UIColor redColor];
        _adLabel.text = @" 广告 ";
        _adLabel.layer.cornerRadius = 5.0f;
        _adLabel.layer.borderWidth = 1.0f;
        _adLabel.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _adLabel;
}

- (YSBannerView *)adBannerView{
    if (!_adBannerView) {
        _adBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(90, CGRectGetMaxY(self.rightBannerView.frame)+10, kYJSCREEN_WIDTH - 60, 40)];
        _adBannerView.backgroundColor = [UIColor clearColor];
        _adBannerView.delegate = self;
        _adBannerView.scrollDirection = YSBannerViewDirectionTop;
        _adBannerView.pageControlStyle = YSPageControlNone;
        [_adBannerView disableScrollGesture];
    }
    return _adBannerView;
}

- (YSBannerView *)topBannerView{
    if (!_topBannerView) {
        _topBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.adBannerView.frame) + 10, kYJSCREEN_WIDTH, 200)];
        _topBannerView.pageControlStyle = YSPageControlHollow;
        _topBannerView.pageControlBottomMargin = 5.0f;
        _topBannerView.scrollDirection = YSBannerViewDirectionTop;
        _topBannerView.autoScroll = NO;
        _topBannerView.delegate = self;
    }
    return _topBannerView;
}

- (YSBannerView *)bottomBannerView{
    if (!_bottomBannerView) {
        _bottomBannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBannerView.frame) + 15, kYJSCREEN_WIDTH, 200)];
        _bottomBannerView.pageControlStyle = YSPageControlHollow;
        _bottomBannerView.pageDotSize = CGSizeMake(10, 5);
        _bottomBannerView.currentPageDotImage = [UIImage imageNamed:@"pageControlN"];
        _bottomBannerView.pageDotImage = [UIImage imageNamed:@"pageControlS"];
        _bottomBannerView.pageControlPadding = 8;
        _bottomBannerView.pageControlAliment = YSPageControlAlimentRight;
        _bottomBannerView.scrollDirection = YSBannerViewDirectionBottom;
        _bottomBannerView.pageControlBottomMargin = 30;
        _bottomBannerView.pageControlHorizontalMargin = 30;
    }
    return _bottomBannerView;
}

#pragma mark - Delegate
- (Class)bannerViewRegistCustomCellClass:(YSBannerView *)bannerView {
    if (bannerView == self.adBannerView) {
        return [AdCell class];
    }
    return nil;
}

- (void)bannerView:(YSBannerView *)bannerView setupCell:(UICollectionViewCell *)customCell index:(NSInteger)index {
    if (bannerView == self.adBannerView) {
        AdCell *cell = (AdCell *)customCell;
        [cell cellWithHeadHotLineCellData:_adTitles[index]];
    }
}

- (void)bannerView:(YSBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{

    NSString *titleString = @"";
    NSString *showMessage = [NSString stringWithFormat:@"点击了第%ld个", (long)index];
    
    if (bannerView == self.leftBannerView) {
        titleString = @"BannerView";
    }
    else if (bannerView == self.adBannerView){
        titleString = @"广告";
    } else {
        [self.navigationController pushViewController:[YSSubViewController new] animated:YES];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString message:showMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


@end
