//
//  RKPayManager.h
//  webview
//
//  Created by rk on 2017/8/18.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKPayManager : NSObject

+ (instancetype)shareManager;
-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options;

@end
