//
//  HPResponseEntity.h
//  RKBaseLibs
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPEntity.h"

//@interface HPResponseHeadEntity : HPEntity
//@property (copy,nonatomic) NSString * stateInfo;
//@property (copy,nonatomic) NSString * code;
//@property (copy,nonatomic) NSString * httpurl;
//@property (copy,nonatomic) NSString * timestamp;
//@property (copy,nonatomic) NSString * version;
//@property (copy,nonatomic) NSString * token;
//@property (copy,nonatomic) NSString * info;
//@property (copy,nonatomic) NSString * state;
//@property (copy,nonatomic) NSString * flag;
//@end

@interface HPResponseEntity : HPEntity

//@property (copy,nonatomic) NSString * data;
//@property (strong,nonatomic) NSDictionary * dataDic;//通过data base64解密得来
//@property (strong, nonatomic) HPResponseHeadEntity *head;
@property (strong,nonatomic) AFHTTPRequestOperation * op;
@property (strong,nonatomic) id result;
@property (copy,nonatomic) NSString * msg;
@property (copy,nonatomic) NSString * status;
@property (copy,nonatomic) NSString * code;

@end
