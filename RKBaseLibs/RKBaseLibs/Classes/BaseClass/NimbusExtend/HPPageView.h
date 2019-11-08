//
//  HPPageView.h
//  RKBaseLibs
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIPagingScrollView.h>

@interface HPPageView : UIView <NIPagingScrollViewPage>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) NSInteger pageIndex;

@end
