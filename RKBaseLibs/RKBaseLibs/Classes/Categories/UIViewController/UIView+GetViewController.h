//
//  UIView+GetViewController.h
//  YunDuo
//
//  Created by Cullen on 14-3-3.
//  Copyright (c) 2014年 Cullen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetViewController)

-(UIViewController *)getViewController;//一层层循环响应者以获得viewController
-(id )getViewControllerWithClass:(Class)viewControllerClass;
- (UITableView *)getTableView;
-(id)getTableViewCellWithClass:(Class)cellClass;
-(id)getTableViewCellWithMemberClass:(Class)cellClass;

@end
