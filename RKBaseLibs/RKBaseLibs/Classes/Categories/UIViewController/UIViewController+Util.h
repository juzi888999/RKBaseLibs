//
//  UIViewController+Util.h
//
//  Created by rk on 14-11-12.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Util)

- (void)setExtendLayoutMode:(UIRectEdge)mode;
- (void)setAutoAdjustScrollView:(BOOL)automatic;
- (BOOL)isOnScreen;

@end
