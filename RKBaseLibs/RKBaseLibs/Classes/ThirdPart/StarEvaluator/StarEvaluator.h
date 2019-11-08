//
//  StarEvaluator.h
//  StarEvaluator
//
//  Created by Mac on 16/4/27.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StarEvaluator;
@protocol StarEvaluatorDelegate <NSObject>

@optional
- (void)starEvaluator:(StarEvaluator *)evaluator currentValue:(float)value;

@end

@interface StarEvaluator : UIControl

@property (nonatomic, assign) float currentValue;
@property (assign, nonatomic) BOOL animate;
@property (assign, nonatomic) id<StarEvaluatorDelegate>delegate;

@end
