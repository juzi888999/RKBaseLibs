//
//  NSDictionary+LogCategory.h
//  TestMac
//
//  Created by yuelixing on 16/9/5.
//  Copyright © 2016年 Tutu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 如果需要关掉兼容中文的打印，把下面的宏注释掉即可
#define UseLogChinese

// 默认启用 根据dict的key排序，不需要的话可以改成NO
#define UseLogChineseSort NO

@interface NSArray (Log)

@end

@interface NSDictionary (Log)

@end

@interface NSSet (Log)

@end


// version: 1.0.1
