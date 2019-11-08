//
//  UIViewController+Util.m
//
//  Created by rk on 14-11-12.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "UIViewController+Util.h"

@implementation UIViewController (Util)

- (void)setExtendLayoutMode:(UIRectEdge)mode {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = mode;
    }
}

- (void)setAutoAdjustScrollView:(BOOL)automatic {
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = automatic;
    }
}

- (BOOL)isOnScreen {
    return self.isViewLoaded && [self.view isOnScreen];
}

@end
