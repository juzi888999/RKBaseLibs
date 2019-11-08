//
//  AnotherStarEvaluator.m
//  StarEvaluator
//
//  Created by Mac on 16/4/28.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "AnotherStarEvaluator.h"

#define Space  10

@interface AnotherStarEvaluator ()
{
    float   aWidth; //一个星星+间隙的宽度
    float   aStarWidth; //一个星星的宽度
    float   touchX;
    NSMutableArray  *fullStarArray;
}
@property (nonatomic, assign) float currentValue;

@end

@implementation AnotherStarEvaluator

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentValue = 0;
        self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setCurrentValue:(float)currentValue
{
    _currentValue = currentValue;
    [self setNeedsDisplay];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    int t = (int)(touchPoint.x/aWidth);
    float f = (touchPoint.x - t*Space - t*aStarWidth)/aStarWidth;
    f = f>1.0?1.0:f;
    self.currentValue = t + f;
    
    touchX = touchPoint.x;
    [self setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    int t = (int)(touchPoint.x/aWidth);
    float f = (touchPoint.x - t*Space - t*aStarWidth)/aStarWidth;
    f = f>1.0?1.0:f;
    self.currentValue = t + f;
    
    touchX = touchPoint.x;
    [self setNeedsDisplay];
    
    return YES;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = (self.bounds.size.width - Space*4) / 5;
    
    aStarWidth = width;
    aWidth = width + Space;
    
    
    UIImage *image = [UIImage imageNamed:@"evaStar.png"];
    for (int i = 0; i < 5; i ++) {
        CGRect rect = CGRectMake(i*(width+Space), 0, width, width);
        [image drawInRect:rect];
    }
    
    [[UIColor whiteColor] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    
    CGRect newRect = CGRectMake(0, 0, touchX, rect.size.height);
    [[UIColor orangeColor] set];
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
    
    if ([_delegate respondsToSelector:@selector(anotherStarEvaluator:currentValue:)]) {
        [_delegate anotherStarEvaluator:self currentValue:_currentValue];
    }
}

@end
