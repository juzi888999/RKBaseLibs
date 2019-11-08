//
//  MJRefreshHeaderExtension.m
//  RKBaseLibs
//
//  Created by yang on 16/4/15.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "MJRefreshHeaderExtension.h"
#import <UIImage+GIF.h>

@interface MJRefreshHeaderExtension()
/** 箭头*/
@property (strong, nonatomic)UIImageView *arrowView;
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshHeaderExtension
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"arrow.png")] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(@"arrow.png")];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - 重写父类的方法
/**
 *  重写父类的方法
 */
-(void)prepare
{
    [super prepare];
    
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 50;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
    }
}
@end

@implementation MJRefreshGifHeaderExtension

+(instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshGifHeaderExtension *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    [header commonInit];
    return header;
}

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshGifHeaderExtension *header = [[self alloc] init];
    [header commonInit];
    [header setRefreshingTarget:target refreshingAction:action];
    return header;
}

- (void)commonInit
{
    MJRefreshGifHeaderExtension * header = self;
    header.backgroundColor = HPColorForKey(@"tableview.bg");
    NSMutableArray * frames = [NSMutableArray array];
    for (int i = 1; i <= 24; i ++) {
        NSString * name = [NSString stringWithFormat:@"pull_refresh%03d",i];
        UIImage * image = [UIImage imageNamed:name];
        [frames addObject:image];
    }
    CGFloat dur = frames.count * 0.1;
    [header setImages:@[[frames firstObject]] duration:0 forState:MJRefreshStateIdle];
    [header setImages:frames duration:dur forState:MJRefreshStatePulling];
    [header setImages:frames duration:dur forState:MJRefreshStateRefreshing];
    [header setImages:frames duration:dur forState:MJRefreshStateWillRefresh];
}

#pragma mark - 重写父类的方法

-(void)prepare
{
    [super prepare];
    
    [self setTitle:@"下拉即可刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松手即可刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.right = self.centerX - 50;
}

//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//    
//    self.gifView.transform = CGAffineTransformScale(self.gifView.transform, 0.5+(0.5*self.pullingPercent), 0.5+(0.5*self.pullingPercent));
//    if (self.pullingPercent > 1) {
//        self.gifView.transform = CGAffineTransformIdentity;
//    }
//}

@end
