//
//  HPPageView.m
//  RKBaseLibs
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPPageView.h"

@implementation HPPageView

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self removeAllSubviews];
    if (contentView)
    {
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
}

@end
