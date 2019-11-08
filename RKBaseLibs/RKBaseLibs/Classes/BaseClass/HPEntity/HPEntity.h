//
//  HPEntity.h
//
//  Created by rk on 14-12-14.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "NSString+Random.h"

@interface HPEntity : MTLModel <MTLJSONSerializing>

//@property (nonatomic, copy) NSNumber *nid;
+ (NSString *)formatPrice:(NSNumber *)price;
+ (BOOL)isEmpty:(id)object;

- (instancetype)initRandom;
+ (NSString*)convertServerTextForDisplay:(NSString*)text;

@end
