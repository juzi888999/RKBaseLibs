//
//  BYBasePageModel.m
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYBasePageModel.h"

@implementation BYBasePageModel

-(instancetype)init
{
    if (self = [super init]) {
        self.relativePath = nil;
        self.listKey = @"data";
        self.pageIndexKey = @"pageNo";
        self.pageSizeKey = @"pageSize";
        self.totalPageKey = @"totalpage";
        self.totalKey = @"total";
        self.generateParameters = @{};
        self.objectClass = nil;
    }
    return self;
}

@end
