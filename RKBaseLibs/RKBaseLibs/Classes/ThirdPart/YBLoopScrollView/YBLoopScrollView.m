//
//  YBLoopScrollView.m
//  YBLoopScrollView
//
//  Created by hxcj on 16/11/30.
//  Copyright © 2016年 hxcj. All rights reserved.
//

#import "YBLoopScrollView.h"
#import "UIImageView+WebCache.h"
@interface YBLoopScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *loopScrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (assign,nonatomic) CGFloat coverBgHeight;// pageControl 右对齐的时候为30,居中的时候为 50;
@end

@implementation YBLoopScrollView
@synthesize timeInterval = _timeInterval;

- (void)dealloc {
    NSLog(@" %s --- 轮播图被销毁了!", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls titles:(NSArray<NSString *> *)titles placeholderImage:(UIImage *)placeholderImage {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.coverBgHeight = 30;
        if (titles.count && imageUrls.count) {
            NSAssert(imageUrls.count == titles.count, @"titles.count 不等于 imageUrls.count");
        }
        // initProperty
        self.imageUrls = imageUrls;
        self.titles = titles;
        self.placeholderImage = placeholderImage;
        // initSubViews
        [self initLoopScrollViewWith:frame];
        [self initImageViews];
        [self initCoverBGWith:frame];
        [self initPageControlWith:frame];
        [self initPageLabelWith:frame];
        self.pageControl.hidden = YES;
        [self initTitleViewLabelWith:frame];
        [self addTimer];
    }
    return self;
}

#pragma mark - initSubViews
- (void)initLoopScrollViewWith:(CGRect)frame {
    self.loopScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.loopScrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) * 3, CGRectGetHeight(frame));
    self.loopScrollView.contentOffset = CGPointMake(CGRectGetWidth(frame), 0);
    self.loopScrollView.showsHorizontalScrollIndicator = NO;
    self.loopScrollView.pagingEnabled = YES;
    self.loopScrollView.bounces = NO;
    self.loopScrollView.scrollsToTop = NO;
    self.loopScrollView.directionalLockEnabled = YES;
    self.loopScrollView.delegate = self;
    [self addSubview:self.loopScrollView];
    // 添加轻拍手势
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoopScrollViewAction:)];
    [self.loopScrollView addGestureRecognizer:tapScrollView];
}

- (void)initImageViews {
    CGFloat scrollViewWidth = CGRectGetWidth(self.loopScrollView.frame);
    CGFloat scrollViewHeight = CGRectGetHeight(self.loopScrollView.frame);
    self.leftImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImageView.clipsToBounds = YES;
    self.middleImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight))];
    self.middleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.middleImageView.clipsToBounds = YES;
    self.rightImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(scrollViewWidth * 2, 0, scrollViewWidth, scrollViewHeight))];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImageView.clipsToBounds = YES;
    
    [self.loopScrollView addSubview:self.leftImageView];
    [self.loopScrollView addSubview:self.middleImageView];
    [self.loopScrollView addSubview:self.rightImageView];
    if (self.imageUrls.count == 0) {
        self.leftImageView.image = self.middleImageView.image = self.rightImageView.image = self.placeholderImage;
        return;
    }
    [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:0 rightImageIndex:1];
}

- (void)initCoverBGWith:(CGRect)frame
{
    if (self.coverBg.superview) {
        [self.coverBg removeFromSuperview];
        self.coverBg = nil;
    }
    CGFloat coverBgHeight = self.coverBgHeight;
    UIView * coverBg = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - coverBgHeight, frame.size.width, coverBgHeight)];
    self.coverBg = coverBg;
    //    coverBg.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    //    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    gradientLayer.frame = coverBg.bounds;
    [coverBg.layer addSublayer:gradientLayer];
    [self insertSubview:coverBg aboveSubview:self.loopScrollView];
}

- (void)initPageControlWith:(CGRect)rect {
    self.pageControl = [[YBCustomPageControl alloc] initWithFrame:CGRectZero];
    if (self.imageUrls.count != 0)
        self.pageControl.numberOfPages = self.imageUrls.count;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.hidesForSinglePage = NO;
    CGSize size = [self.pageControl sizeForNumberOfPages:5];
    self.pageControl.frame = CGRectMake(rect.size.width - size.width - 15, rect.size.height - self.coverBg.height, size.width, self.coverBg.height);
    [self addSubview:self.pageControl];
}

- (void)initPageLabelWith:(CGRect)rect{
    UILabel * pageLabel = [UILabel rightAlignLabel];
    self.pageLabel = pageLabel;
    pageLabel.font = HPFontWithSize(12);
    pageLabel.textColor = UIColor.whiteColor;
    pageLabel.frame = CGRectMake(rect.size.width-30-15,rect.size.height - self.coverBg.height, 30, self.coverBg.height);
    [self addSubview:pageLabel];
}

- (void)initTitleViewLabelWith:(CGRect)frame {
    CGSize size = [self.pageControl sizeForNumberOfPages:5];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - self.coverBg.height, frame.size.width-size.width-15-10, self.coverBg.height)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = HPFontWithSize(15);
    if (self.titles.count != 0) {
        self.titleLabel.text = self.titles.firstObject;
    }
    [self addSubview:self.titleLabel];
}

- (void)setImageViewWithLeftImageIndex:(NSInteger)leftImageIndex middleImageIndex:(NSInteger)middleImageIndex rightImageIndex:(NSInteger)rightImageIndex {
    if (self.imageUrls.count == 1) {
        [self setImageWith:self.imageUrls.firstObject forImageView:self.leftImageView];
        [self setImageWith:self.imageUrls.firstObject forImageView:self.middleImageView];
        [self setImageWith:self.imageUrls.firstObject forImageView:self.rightImageView];
    }else {
        if (!self.imageUrls.count) return;
        [self setImageWith:self.imageUrls[leftImageIndex] forImageView:self.leftImageView];
        [self setImageWith:self.imageUrls[middleImageIndex] forImageView:self.middleImageView];
        [self setImageWith:self.imageUrls[rightImageIndex] forImageView:self.rightImageView];
    }
}

- (void)setImageWith:(id)object forImageView:(UIImageView *)imageView {
    NSString *urlString = object;
    if ([object isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)urlString;
    }else if ([object isKindOfClass:[NSURL class]]){
        [imageView sd_setImageWithURL:(NSURL *)object placeholderImage:self.placeholderImage];
    }else{
        [imageView sd_setImageWithURL:[NetworkClient imageUrlForString:object] placeholderImage:HPPlaceholderImage];
    }
}

#pragma mark - 点击事件
- (void)tapLoopScrollViewAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(clickedLoppScrollView:imageIndex:)]) {
        if (self.currentIndex == -1) self.currentIndex = self.imageUrls.count - 1;
        [_delegate clickedLoppScrollView:self imageIndex:self.currentIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewOffsetX = scrollView.contentOffset.x;
    if (scrollViewOffsetX >= 2*CGRectGetWidth(self.loopScrollView.frame)) {
        [self leftTurnScrollWithScrollView:scrollView];
        // 更新label
        if ([NSArray checkArray:self.titles].count > 0 && !self.hiddenTitleLabel) {
            if (self.currentIndex == -1) {
                self.titleLabel.text = self.titles.lastObject;
            }else {
                self.titleLabel.text = self.titles[self.currentIndex];
            }
        }
    }
    if (scrollViewOffsetX <= 0) {
        [self rightTurnScrollWithScrollView:scrollView];
        // 更新label
        if ([NSArray checkArray:self.titles].count > 0 && !self.hiddenTitleLabel) {
            if (self.currentIndex == -1) {
                self.titleLabel.text = self.titles.lastObject;
            }else {
                self.titleLabel.text = self.titles[self.currentIndex];
            }
        }
    }
}

-(void)setHiddenTitleLabel:(BOOL)hiddenTitleLabel
{
    _hiddenTitleLabel = hiddenTitleLabel;
    self.coverBg.hidden = hiddenTitleLabel;
    self.titleLabel.hidden = hiddenTitleLabel;
}
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

// setContentOffset改变时调用, 每自动滚动一次就执行一次
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.loopScrollView]) {
        if (_delegate && [_delegate respondsToSelector:@selector(loopScrollView:everyTimeEndScroll:)]) {
            if (self.currentIndex == -1) self.currentIndex = self.imageUrls.count - 1;
            [_delegate loopScrollView:self everyTimeEndScroll:self.currentIndex];
        }
    }
}

// 向左滚动
- (void)leftTurnScrollWithScrollView:(UIScrollView *)scrollView{
    
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.loopScrollView.frame), 0);
    self.currentIndex++;
    if (self.currentIndex == self.imageUrls.count - 1) {
        [self setImageViewWithLeftImageIndex:self.currentIndex - 1 middleImageIndex:self.currentIndex rightImageIndex:0];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
        self.currentIndex = -1;
    }
    else if (self.currentIndex == self.imageUrls.count){
        [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:0 rightImageIndex:1];
        self.pageControl.currentPage = 0;
        self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",1,(unsigned long)self.imageUrls.count];
        self.currentIndex = 0;
    }
    else if(self.currentIndex == 0){
        [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:self.currentIndex rightImageIndex:self.currentIndex + 1];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }else{
        [self setImageViewWithLeftImageIndex:self.currentIndex - 1 middleImageIndex:self.currentIndex rightImageIndex:self.currentIndex + 1];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }
}

// 向右滚动
- (void)rightTurnScrollWithScrollView:(UIScrollView *)scrollView{
    
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.loopScrollView.frame), 0);
    self.currentIndex--;
    if (self.currentIndex == -2) {
        self.currentIndex = self.imageUrls.count - 2;
        if (self.imageUrls.count == 2) {
            [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:self.currentIndex rightImageIndex:self.imageUrls.count - 1];
        }else{
            [self setImageViewWithLeftImageIndex:self.currentIndex - 1 middleImageIndex:self.currentIndex rightImageIndex:self.currentIndex - 1];
        }
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }
    else if (self.currentIndex == -1) {
        self.currentIndex = self.imageUrls.count-1;
        [self setImageViewWithLeftImageIndex:self.currentIndex - 1 middleImageIndex:self.currentIndex rightImageIndex:0];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }else if (self.currentIndex == 0){
        [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:self.currentIndex rightImageIndex:self.currentIndex + 1];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }else{
        [self setImageViewWithLeftImageIndex:self.currentIndex - 1 middleImageIndex:self.currentIndex rightImageIndex:self.currentIndex + 1];
        self.pageControl.currentPage = self.currentIndex;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }
}

#pragma mark - 定时器 autoScroll
- (void)handleTimerAction:(NSTimer *)timer {
    [self.loopScrollView setContentOffset:(CGPointMake(CGRectGetWidth(self.loopScrollView.frame) * 2, 0)) animated:YES];
}

- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(handleTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
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

#pragma mark - getter
- (NSTimeInterval)timeInterval {
    if (!_timeInterval) {
        _timeInterval = 3.0;
    }
    return _timeInterval;
}

#pragma mark - setter
// NSTimer的timeInterval是只读的,这里先移除定时器,在重新创建
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    [self removeTimer];
    [self addTimer];
}

- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    if (imageUrls) {
        self.pageControl.numberOfPages = _imageUrls.count;
        if (self.pageControlAlignment == YBLoopScrollViewPageControlAlignmentRight) {
            
            CGSize size = [self.pageControl sizeForNumberOfPages:_imageUrls.count];
            self.pageControl.width = size.width;
            self.pageControl.right = self.frame.size.width-15;
            self.titleLabel.width = self.frame.size.width - 15 -10 - self.pageControl.width;
        }
        [self setImageViewWithLeftImageIndex:self.imageUrls.count - 1 middleImageIndex:0 rightImageIndex:1];
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.imageUrls.count];
    }else {
        [_imageUrls.mutableCopy removeAllObjects];
    }
}

-(void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    if (titles.count > self.currentIndex) {
        self.titleLabel.text = [titles objectAtIndex:self.currentIndex];
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.titles.count];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (self.imageUrls.count == 0) {
        _currentIndex = 0;
    }else {
        _currentIndex = currentIndex;
    }
}

-(void)setPageControlAlignment:(YBLoopScrollViewPageControlAlignment)pageControlAlignment
{
    _pageControlAlignment = pageControlAlignment;
    switch (pageControlAlignment) {
        case YBLoopScrollViewPageControlAlignmentRight:
        {
            self.coverBgHeight = 30;
            [self initCoverBGWith:self.frame];
            self.pageControl.frame = CGRectMake(self.width - self.pageControl.width - 15, self.height - self.coverBg.height, self.pageControl.width, self.coverBg.height);
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.titleLabel.frame = CGRectMake(10, self.height - self.coverBg.height, self.width-self.pageControl.width-15-10, self.coverBg.height);
        }
            break;
        case YBLoopScrollViewPageControlAlignmentCenter:
        {
            self.coverBgHeight = 50;
            [self initCoverBGWith:self.frame];
            CGSize size = [self.pageControl sizeForNumberOfPages:_imageUrls.count];
            self.pageControl.frame = CGRectMake(0, 0, size.width, size.height);
            self.pageControl.centerY = self.height - 10;
            self.pageControl.centerX = self.width/2.f;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.frame = CGRectMake(10, self.height - self.coverBg.height, self.width-10-10, 30);
        }
            break;
        default:
            break;
    }
}
@end
