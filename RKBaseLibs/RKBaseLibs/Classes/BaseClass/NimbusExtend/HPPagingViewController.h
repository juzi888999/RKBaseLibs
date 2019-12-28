//
//  HPPagingViewController.h
//  RKBaseLibs
//
//  Created by mac on 15/9/12.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "BaseViewController.h"
#import "NIPagingScrollView.h"
#import "NIPagingScrollView+Subclassing.h"

@interface HPPagingViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic, readonly) NIPagingScrollView *pagingScrollView;
@property (assign,nonatomic) BOOL scrollEnable;
@property (assign,nonatomic) BOOL directionLockEnable;
- (void)setScrollViewBackgroundColor:(UIColor *)backgroundColor;
@end
