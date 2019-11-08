//
//  UIView+GetViewController.m
//  YunDuo
//
//  Created by Cullen on 14-3-3.
//  Copyright (c) 2014年 Cullen. All rights reserved.
//

#import "UIView+GetViewController.h"

@implementation UIView (GetViewController)

-(UIViewController *)getViewController//一层层循环响应者以获得viewController
{
    UIResponder * next = self.nextResponder;
    do {
        if([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next!=nil);
    
    return nil;
}

-(id)getViewControllerWithClass:(Class)viewControllerClass
{
    UIResponder * next = self.nextResponder;
    do {
        if([next isKindOfClass:viewControllerClass])
        {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next!=nil);
    
    return nil;
}

- (UITableView *)getTableView
{
    UIResponder * next = self.nextResponder;
    do {
        if([next isKindOfClass:[UITableView class]])
        {
            return (UITableView *)next;
        }
        
        next = next.nextResponder;
        
    } while (next!=nil);
    
    return nil;
}

-(id)getTableViewCellWithClass:(Class)cellClass
{
    UIResponder * next = self.nextResponder;
    do {
        if([next isKindOfClass:cellClass])
        {
            return (UITableViewCell *)next;
        }
        
        next = next.nextResponder;
        
    } while (next!=nil);
    
    return nil;
}

-(id)getTableViewCellWithMemberClass:(Class)cellClass
{
    UIResponder * next = self.nextResponder;
    do {
        if([next isMemberOfClass:cellClass])
        {
            return (UITableViewCell *)next;
        }
        
        next = next.nextResponder;
        
    } while (next!=nil);
    
    return nil;
}

@end
