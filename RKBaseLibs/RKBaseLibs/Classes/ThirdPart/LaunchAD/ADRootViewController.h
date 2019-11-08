//
//  ADRootViewController.h
//  RKBaseLibs
//
//  Created by rk on 2017/12/25.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "BaseViewController.h"

@interface ADRootViewController : BaseViewController
@property (copy,nonatomic) void(^ad_viewDidAppearBlock)();
@end
