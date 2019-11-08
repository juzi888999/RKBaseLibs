//
//  BYInputAccessoryView.h
//  RKBaseLibs 
//
//  Created by rk on 16/10/9.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYInputAccessoryView : UIView

@property (strong,nonatomic) NSString * title;

@property (copy,nonatomic) void(^cancelBlock)();
@property (copy,nonatomic) void(^sureBlock)();

+ (instancetype)createThemeInputAccessoryView;
@end
