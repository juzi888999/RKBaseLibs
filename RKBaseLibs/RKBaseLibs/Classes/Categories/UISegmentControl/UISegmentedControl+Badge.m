//
//  UISegmentedControl+Badge.m
//  RKBaseLibs 
//
//  Created by rk on 2017/1/22.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "UISegmentedControl+Badge.h"
#import <YYKit/NSArray+YYAdd.h>

@implementation UISegmentedControl (Badge)

- (void)setBadgeNum:(int)num atIndex:(int)index
{
    NSMutableArray * subViews = [[NSArray checkArray:[self subviews]]mutableCopy];
    [subViews reverse];
    if (subViews.count > index) {
        
        UIView * segItem = subViews[index];
        if (segItem) {
            UILabel * unreadView = [segItem viewWithTag:10];
            if (!unreadView) {
                unreadView = [UILabel centerAlignLabel];
                unreadView.font = MainFontSize(10);
                unreadView.tag = 10;
                unreadView.textColor = HPColorForKey(@"unread.bg");
                [segItem addSubview:unreadView];
                [unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(segItem).offset(-2);
                    make.top.mas_equalTo(segItem).offset(2);
                }];
            }
            
            if (num > 0) {
                unreadView.text = @"●";
            }else{
                unreadView.text = @"";
            }
        }
    }
}

@end
