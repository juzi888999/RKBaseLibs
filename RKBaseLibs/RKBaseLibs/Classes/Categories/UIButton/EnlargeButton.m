//
//  EnlargeButton.m
//  RKBaseLibs
//
//  Created by rk on 2017/6/16.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "EnlargeButton.h"

@implementation EnlargeButton

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    if(event.type != UIEventTypeTouches){
        return [super pointInside:point withEvent:event];
    }
    
    CGRect testFrame = CGRectMake(-self.extendInsets.left, - self.extendInsets.top, CGRectGetWidth(self.bounds) + self.extendInsets.left + self.extendInsets.right , CGRectGetHeight(self.bounds) + self.extendInsets.top + self.extendInsets.bottom);
    
    return CGRectContainsPoint(testFrame, point);
    
}

-(void)setExtendInsets:(UIEdgeInsets)extendInsets
{
    _extendInsets = extendInsets;
}
@end
