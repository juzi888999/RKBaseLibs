//
//  YBLoopScrollView.h
//  YBLoopScrollView
//
//  Created by hxcj on 16/11/30.
//  Copyright © 2016年 hxcj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBCustomPageControl.h"

@class YBLoopScrollView;
@protocol YBLoopScrollViewDelegate <NSObject>

@optional
/**
 *  点击轮播图触发
 *
 *  @param loopScrollView 轮播图视图
 *  @param imageIndex     当前显示的图片下标
 */
- (void)clickedLoppScrollView:(YBLoopScrollView *)loopScrollView imageIndex:(NSInteger)imageIndex;
/**
 *  每自动滚动一次就触发一次
 *
 *  @param loopScrollView 轮播视图
 *  @param imageIndex     当前显示的图片下标
 */
- (void)loopScrollView:(YBLoopScrollView *)loopScrollView everyTimeEndScroll:(NSInteger)imageIndex;
@end

typedef enum : NSUInteger {
    YBLoopScrollViewPageControlAlignmentRight, // default
    YBLoopScrollViewPageControlAlignmentCenter
} YBLoopScrollViewPageControlAlignment;

@interface YBLoopScrollView : UIView

/**
 *  自定义初始化方法
 *
 *  @param frame            视图的frame
 *  @param imageUrls        图片数组
 *  @param titles           标题文字数组(可以为空)
 *  @param placeholderImage 占位图片(可以为空)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls titles:(NSArray *)titles placeholderImage:(UIImage *)placeholderImage;

@property (nonatomic, assign) id<YBLoopScrollViewDelegate>delegate;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) YBCustomPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (strong,nonatomic) UIView * coverBg;
@property (assign,nonatomic) BOOL hiddenTitleLabel;
@property (assign,nonatomic) YBLoopScrollViewPageControlAlignment pageControlAlignment;//default is right

/** 定时器循环间隔(默认:3.0s) **/
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  移除定时器
 */
- (void)removeTimer;
@end
