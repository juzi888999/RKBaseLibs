//
//  JKBannarView.m
//
//  Created by 王冲 on 2017/9/8.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "JKBannarView.h"

/** SDWebImage里面的类*/
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIButton+WebCache.h"
#define MaxSections 100
#import "JKBannerCollectionViewCell.h"

/** 自定义颜色 */
#define JKRGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface JKBannarView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;
@property (assign, nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, retain) UIView *viewTitleBk;
@property (nonatomic, retain) UILabel *labTitle;
@end

@implementation JKBannarView

- (void)dealloc{
    _imageViews = nil;
    [self removeNSTimer];
}

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}


- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
        [self addNSTimer];
    }
    
    return self;
}


- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        //[_myCollectionView registerNib:[UINib nibWithNibName:@"JKBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ID"];
        [_myCollectionView registerClass:[JKBannerCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self addSubview:_myCollectionView];
        [self addSubview:self.viewTitleBk];
        
        [self.viewTitleBk addSubview:self.labTitle];
        
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.viewSize.width-100, self.viewSize.height-20-5, 100, 20)];
        _mypageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _mypageControl.pageIndicatorTintColor = JKRGBCOLOR(255, 255, 255, 0.64);
        [self addSubview:_mypageControl];
    }
    return _myCollectionView;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JKBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NetworkClient imageUrlForString:_items[indexPath.row]] placeholderImage:HPPlaceholderImage];
    return cell;
    
}

- (void)setItems:(NSArray *)items{
    _items = items;
    if (_items.count<2) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
        [self removeNSTimer];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
        [self addNSTimer];
        
    }
    [self.myCollectionView reloadData];
    self.mypageControl.numberOfPages = _items.count;
}

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    
    [self.viewTitleBk setHidden:!(self.itemsTitle.count > 0)];
    if (self.itemsTitle.count <= 1) {
        [self removeNSTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    self.mypageControl.currentPage = page;
    // Add by 2017/11/21
    if (page < self.itemsTitle.count) {
        self.labTitle.text = self.itemsTitle[page];
    }
}

#pragma mark -添加定时器
-(void)addNSTimer{
    if (_timer) {
        [_timer invalidate];
    }
    _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage{
    
    if (_items.count<2) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.myCollectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _items.count) {
        nextItem = 0;
        nextSection ++;
    }
    
    // Add by 2017/11/21
    if (nextItem < self.itemsTitle.count) {
        self.labTitle.text = self.itemsTitle[nextItem];
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imageViewClick) {
        self.imageViewClick(self,indexPath.row);
    }
}


#pragma mark -删除定时器

-(void)removeNSTimer{
    if (_timer) {
        [_timer invalidate];
        _timer =nil;
    }
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.items.count > 1) {
        [self addNSTimer];
    }
}

- (void)imageViewClick:(void (^)(JKBannarView *, NSInteger))block{
    self.imageViewClick = block;
}

- (UIView *)viewTitleBk {
    const CGFloat fViewTitleBkHeight = 30.0f;
    if (!_viewTitleBk) {
        _viewTitleBk = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewSize.height - fViewTitleBkHeight, self.viewSize.width, fViewTitleBkHeight)];
        _viewTitleBk.backgroundColor = [UIColor blackColor];
        _viewTitleBk.alpha = 0.7;
    }
    
    return _viewTitleBk;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.viewTitleBk.frame.size.width - 30, self.viewTitleBk.frame.size.height)];
        _labTitle.font = [UIFont systemFontOfSize:13.0f];
        _labTitle.textColor = [UIColor whiteColor];
        
        if (self.itemsTitle.count > 0) {
            _labTitle.text = self.itemsTitle[0];
        }
    }
    
    return _labTitle;
}

@end
