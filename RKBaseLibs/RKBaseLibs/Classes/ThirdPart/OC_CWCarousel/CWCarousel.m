//
//  CWCarousel.m
//  CWCarousel
//
//  Created by WangChen on 2018/4/3.
//  Copyright © 2018年 ChenWang. All rights reserved.
//

#import "CWCarousel.h"

@interface CWCarousel ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICollectionView *carouselView;
@property (nonatomic, assign) NSInteger        numbers;
@property (nonatomic, assign) NSInteger        currentIndex;
@property (nonatomic, assign) NSInteger        infactIndex;
@property (nonatomic, assign) CGFloat          addHeight;
/**
 自动播放是否暂停
 */
@property (nonatomic, assign) BOOL             isPause;

/**
 当前展示在中间的cell下标
 */
@property (nonatomic, strong) NSIndexPath      *currentIndexPath;

@end
@implementation CWCarousel
@synthesize carouselView = _carouselView;
@synthesize timeInterval = _timeInterval;


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<CWCarouselDelegate>)delegate datasource:(id<CWCarouselDatasource>)datasource flowLayout:(CWFlowLayout *)flowLayout {
    CGFloat addHeight = 0;
    if(flowLayout.style == CWCarouselStyle_H_3) {
        /* 如果是CWCarouselStyle_H_3, 因为中间一张图片放大的原因,需要扩充一下frame的高度,所以会和实际的传入的frame
         的高度有部分偏差
         */
        addHeight = (flowLayout.maxScale - 1) * CGRectGetHeight(frame);
    }
    frame.size.height += addHeight;
    self.addHeight = addHeight;
    if(self = [super initWithFrame:frame]) {
        _flowLayout = flowLayout;
        self.delegate = delegate;
        self.datasource = datasource;
        self.isAuto = NO;
        [self configureView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    newSuperview.clipsToBounds = NO;
    if(self.customPageControl == nil && self.pageControl.superview == nil) {
        [self addSubview:self.pageControl];
    }else if(self.customPageControl) {
        [self addSubview:self.customPageControl];
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)registerViewClass:(Class)viewClass identifier:(NSString *)identifier {
    [self.carouselView registerClass:viewClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNibView:(NSString *)nibName identifier:(NSString *)identifier {
    [self.carouselView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:identifier];
}

- (void)freshCarousel {
    if([self numbers] <= 0) {
        return;
    }
    [self.carouselView reloadData];
    [self.carouselView scrollToItemAtIndexPath:[self originIndexPath] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.carouselView.userInteractionEnabled = YES;
    if (self.isAuto) {
        [self play];
    }
}
#pragma mark - < Scroll Delegate >
/// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 防止拖动加速度太大,一次跳过多张图片,这里设置一下
    scrollView.pagingEnabled = YES;
    if (self.isAuto) {
        [self stop];
    }
}

/// 将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(velocity.x > 0) {
        //左滑,下一张
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:self.currentIndexPath.section];
    }else if (velocity.x < 0) {
        //右滑,上一张
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row - 1 inSection:self.currentIndexPath.section];
    }else if (velocity.x == 0) {
        //还有一种情况,当滑动后手指按住不放,然后松开,此时的加速度其实是为0的
        NSArray <NSIndexPath *> *indexPaths = [self.carouselView indexPathsForVisibleItems];
        NSMutableArray <UICollectionViewLayoutAttributes *> *attriArr = [NSMutableArray arrayWithCapacity:indexPaths.count];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UICollectionViewLayoutAttributes *attri = [self.carouselView layoutAttributesForItemAtIndexPath:obj];
            [attriArr addObject:attri];
        }];
        CGFloat centerX = scrollView.contentOffset.x + CGRectGetWidth(self.carouselView.frame) * 0.5;
        __block CGFloat minSpace = MAXFLOAT;
        [attriArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.zIndex = 0;
            if(ABS(minSpace) > ABS(obj.center.x - centerX)) {
                minSpace = obj.center.x - centerX;
                self.currentIndexPath = obj.indexPath;
            }
        }];
    }
}

/// 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(self.currentIndexPath != nil &&
       self.currentIndexPath.row < [self infactNumbers] &&
       self.currentIndexPath.row >= 0) {
        // 中间一张轮播,居中显示
        [self.carouselView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

/// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 打开交互
    scrollView.pagingEnabled = NO;
    if(self.isAuto) {
        [self play];
    }
}

/// 滚动动画完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 滚动完成,打开交互,关掉pagingEnabled
    // 为什么要关掉pagingEnabled呢,因为切换控制器的时候会有系统级bug,不信你试试.
    scrollView.userInteractionEnabled = YES;
    scrollView.pagingEnabled = NO;
    if(self.isAuto) {
        [self play];
    }
    [self checkOutofBounds];
}

// 滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 滚动过程中关闭交互
//    scrollView.userInteractionEnabled = NO;
}
#pragma mark - < Logic Helper >
- (NSIndexPath *)originIndexPath {
    NSInteger centerIndex = [self infactNumbers] / [self numbers];
    if(centerIndex <= 1) {
        self.currentIndexPath = [NSIndexPath indexPathForRow:self.numbers inSection:0];
    }else {
        self.currentIndexPath = [NSIndexPath indexPathForRow:centerIndex / 2 * [self numbers] inSection:0];
    }
    return self.currentIndexPath;
}

- (void)checkOutofBounds {
    // 越界检查
    if(self.currentIndexPath.row == [self infactNumbers] - 1) {
        //最后一张
        NSIndexPath *origin = [self originIndexPath];
        NSInteger index = [self caculateIndex:self.currentIndexPath.row] - 1;
        self.currentIndexPath = [NSIndexPath indexPathForRow:origin.row + index inSection:origin.section];
        [self.carouselView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.carouselView.userInteractionEnabled = YES;
    }else if(self.currentIndexPath.row == 0) {
        //第一张
        NSIndexPath *origin = [self originIndexPath];
        NSInteger index = [self caculateIndex:self.currentIndexPath.row];
        self.currentIndexPath = [NSIndexPath indexPathForRow:origin.row + index inSection:origin.section];
        [self.carouselView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.carouselView.userInteractionEnabled = YES;
    }
}

- (void)pageControlClick:(UIPageControl *)sender {
    if (![sender isKindOfClass:[UIPageControl class]]) {
        return;
    }
    NSInteger page = sender.currentPage;
    NSInteger prePage = [self caculateIndex:self.currentIndexPath.row];
    if(page == prePage) {
        return;
    }
    NSIndexPath *indexPath = nil;
    if(prePage - page == [self numbers] - 1) {
        //最后一张跳到第一张
        indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
    }else if(page - prePage == [self numbers] - 1) {
        //第一张跳到最后一张
        indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row - 1 inSection:0];
    }else {
        indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + page - prePage inSection:0];
    }
    [self.carouselView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.currentIndexPath = indexPath;
}

/**
 实际下标转换成业务需求下标

 @param factIndex 实际下标
 @return 业务需求下标
 */
- (NSInteger)caculateIndex:(NSInteger)factIndex {
    if (self.numbers <= 0) {
        return 0;
    }
    NSInteger row = factIndex % [self numbers];
    return row;
}

- (void)play {
    
    [self stop];
    if(self.isPause) {
        return;
    }
    [self addTimer];
}

- (void)nextCell {
    if([self numbers] <= 0) {
        return;
    }
    if(self.currentIndexPath.row < [self infactNumbers] - 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:self.currentIndexPath.section];
        [self.carouselView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.currentIndexPath = indexPath;
    }
//    [self performSelector:@selector(nextCell) withObject:nil afterDelay:self.autoTimInterval];
}

- (void)stop {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextCell) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeTimer];
}

- (void)resumePlay {
    self.isPause = NO;
    [self play];
}

- (void)pause {
    self.isPause = YES;
    [self stop];
}

- (void)releaseTimer {
    [self stop];
}

#pragma mark - 定时器 autoScroll
- (void)handleTimerAction:(NSTimer *)timer {
//    [self.loopScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.loopScrollView.frame) * 2, 0)) animated:YES];
    [self nextCell];
}

- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self removeTimer];
}

#pragma mark - < Configure View>
- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    self.carouselView.showsVerticalScrollIndicator = NO;
    self.carouselView.showsHorizontalScrollIndicator = NO;
    self.carouselView.decelerationRate = 0;
}

#pragma mark - < Delegate, Datasource >
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(viewForCarousel:indexPath:index:)]) {
        return [self.datasource viewForCarousel:self indexPath:indexPath index:[self caculateIndex:indexPath.row]];
    }
    return nil;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self numbers] > 0)
        return [self infactNumbers];
    else
        return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(CWCarousel:didSelectedAtIndex:)]) {
        [self.delegate CWCarousel:self didSelectedAtIndex:[self caculateIndex:indexPath.row]];
    }
}
#pragma mark - <setter>
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.carouselView.backgroundColor = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}
- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    _currentIndexPath = currentIndexPath;
    if(self.customPageControl == nil)
        self.pageControl.currentPage = [self caculateIndex:currentIndexPath.row];
    else
        self.customPageControl.currentPage = [self caculateIndex:currentIndexPath.row];
}

// NSTimer的timeInterval是只读的,这里先移除定时器,在重新创建
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (self.timer) {
        [self removeTimer];
        [self addTimer];
    }
}

#pragma mark - < getter >
- (NSTimeInterval)timeInterval {
    if (!_timeInterval) {
        _timeInterval = 3.0;
    }
    return _timeInterval;
}

- (UICollectionView *)carouselView {
    if(!_carouselView) {
        self.carouselView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.addHeight * 0.5, self.frame.size.width, self.frame.size.height - self.addHeight) collectionViewLayout:self.flowLayout];
        _carouselView.clipsToBounds = NO;
        _carouselView.delegate = self;
        _carouselView.dataSource = self;
        [self addSubview:_carouselView];
    }
    return _carouselView;
}


/**
 Description

 @return 业务需求需要展示轮播图个数
 */
- (NSInteger)numbers {
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(numbersForCarousel)]) {
        self.pageControl.numberOfPages = [self.datasource numbersForCarousel];
        return self.pageControl.numberOfPages;
    }
    return 0;
}

/**
 轮播图实际加载视图个数

 @return 轮播图实际加载视图个数
 */
- (NSInteger)infactNumbers {
    return 1000000;
}

- (UIPageControl *)pageControl {
    if(!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        CGPoint center = self.center;
        center.y = CGRectGetHeight(self.frame) - 30 * 0.5;
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventTouchUpInside];
        _pageControl.center = center;
    }
    return _pageControl;
}
@end


