//
//  HPRequest.h
//  RKBaseLibs
//
//  Created by mac on 15/10/2.
//  Copyright © 2015年 haixiaedu. All rights reserved.
//

#import "HPEntity.h"

@interface HPRequest : HPEntity

- (NSDictionary *)parameters;
//- (NSDictionary *)valueParameters;
- (NSDictionary *)parametersWithoutNull;

@end

@interface HPBodyRequest : HPRequest

@property (copy, nonatomic) void(^block)(id <AFMultipartFormData> formData);

@end


@interface HPPageRequest : HPRequest
@property (strong,nonatomic) NSString * pageNo; //default is 1
@property (strong,nonatomic) NSString * pageSize;//default is 20

@end
