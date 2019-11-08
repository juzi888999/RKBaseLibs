//
//  StarEvaluator.m
//  StarEvaluator
//
//  Created by Mac on 16/4/27.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import "StarEvaluator.h"

#define Space  10

@interface StarEvaluator ()
{
    float   aWidth; //一个星星+间隙的宽度
    float   aStarWidth; //一个星星的宽度
    NSMutableArray  *fullStarArray;
}

@end

@implementation StarEvaluator

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _currentValue = 0;
        self.backgroundColor = [UIColor clearColor];
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    fullStarArray = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < 5; i ++) {
        
        CGFloat width = (self.bounds.size.width - Space*4) / 5;
        
        aStarWidth = width;
        aWidth = width + Space;
        
        UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(width+Space), 0, width, width)];
        emptyImgView.image = [UIImage imageNamed:@"evaStarEmpty"];
        [self addSubview:emptyImgView];
        
        
        UIImageView *fullImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(width+Space), 0, width, width)];
        fullImgView.contentMode = UIViewContentModeScaleAspectFill;
        fullImgView.image = [UIImage imageNamed:@"evaStar"];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 0);
        layer.backgroundColor = [UIColor blackColor].CGColor;
        fullImgView.layer.mask = layer;
        
        [self addSubview:fullImgView];
        
        fullImgView.layer.mask.frame = CGRectMake(0, 0, 0, width);
        
        [fullStarArray addObject:fullImgView];
    }
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
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    int t = (int)(touchPoint.x/aWidth);
    float f = (touchPoint.x - t*Space - t*aStarWidth)/aStarWidth;
    f = f>1.0?1.0:f;
    self.currentValue = t + f;
    
    return YES;
}

- (void)drawRect:(CGRect)rect {
    
    if (_animate) {
        [CATransaction setDisableActions:NO];
    }else{
        [CATransaction setDisableActions:YES];
    }
    
    int t = (int)_currentValue;
    float f = _currentValue - t;
    
    for (int i = 0; i < 5; i ++) {
        
        UIImageView *fullImgView = [fullStarArray objectAtIndex:i];
        
        if (i < t) {
            fullImgView.layer.mask.frame = CGRectMake(0, 0, aStarWidth, aStarWidth);
        }
        else if (i == t){
            fullImgView.layer.mask.frame = CGRectMake(0, 0, aStarWidth*f, aStarWidth);
        }
        else{
            fullImgView.layer.mask.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    
    if ([_delegate respondsToSelector:@selector(starEvaluator:currentValue:)]) {
        [_delegate starEvaluator:self currentValue:_currentValue];
    }
}


@end


















