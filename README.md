# YSBannerView

使用简单、功能丰富、无依赖的 **iOS图片、文字轮播器**，基于 `UICollectionView` 实现。

### Installation
```
pod YSBannerView
```

### 使用
1. 基础使用
```
YSBannerView *bannerView = [YSBannerView bannerViewWithFrame:CGRectMake(0, 20, kScrennWidth, 150) imageArray:@[@"http://xxx",@"https://xxx",@"xxx.png"]];
bannerView.downloadImageBlock = ^(UIImageView *imageView, NSURL *url, UIImage *placeholderImage) {
    // 自定义请求图片方法
    [imageView sd_setImageWithURL:url placeholderImage:placeholderImage];
};
[self.view addSubview:bannerView];
```
2. 使用自定义Cell, 自行实现以下方法即可
```
/// 自定义Cell的样式 返回自定义 Cell 的 Class
- (Class)bannerViewRegistCustomCellClass:(YSBannerView *)bannerView;
/// 自定义Cell的样式 返回自定义 Cell 的 Nib
- (UINib *)bannerViewRegistCustomCellNib:(YSBannerView *)bannerView;
/// 自定义 Cell 刷新数据或者其他配置
- (void)bannerView:(YSBannerView *)bannerView setupCell:(UICollectionViewCell *)cell index:(NSInteger)index;
```