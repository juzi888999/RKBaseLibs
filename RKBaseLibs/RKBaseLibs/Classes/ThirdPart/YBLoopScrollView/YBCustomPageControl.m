//
//  YBCustomPageControl.m
//  RKBaseLibs
//
//  Created by rk on 2018/8/15.
//  Copyright © 2018年 rk. All rights reserved.
//

#import "YBCustomPageControl.h"

@implementation YBCustomPageControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.size = CGSizeMake(6, 6);
        subview.layer.cornerRadius = 3;
        subview.layer.masksToBounds = YES;
        if (subviewIndex != currentPage){
            subview.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
            subview.layer.borderColor = [UIColor whiteColor].CGColor;
            subview.layer.borderWidth = 0.5;
        }else{
            subview.backgroundColor = HPColorForKey(@"#ffffff");
            subview.layer.borderColor = [UIColor whiteColor].CGColor;
            subview.layer.borderWidth = 0.5;
        }
    }
}
@end
