//
//  AnotherStarEvaluator.h
//  StarEvaluator
//
//  Created by Mac on 16/4/28.
//  Copyright © 2016年 jyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnotherStarEvaluator;
@protocol AnotherStarEvaluatorDelegate <NSObject>

@optional
- (void)anotherStarEvaluator:(AnotherStarEvaluator *)evaluator currentValue:(float)value;

@end

@interface AnotherStarEvaluator : UIControl

@property (assign, nonatomic) id<AnotherStarEvaluatorDelegate>delegate;

@end
