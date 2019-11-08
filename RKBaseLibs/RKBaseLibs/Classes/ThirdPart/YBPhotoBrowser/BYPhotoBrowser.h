//
//  BYPhotoBrowser.h
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"

@interface BYPhotoBrowser : NSObject

@property (strong,nonatomic) MWPhotoBrowser * browser;
@property (copy,nonatomic) void(^photoBrowserDidClose)(MWPhotoBrowser * browser);
-(instancetype)initWithPhotos:(NSArray *)photos;
- (void)showInViewController:(UIViewController *)viewController animated: (BOOL)flag completion:(void (^)(void))completion;
@end
