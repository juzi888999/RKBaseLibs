//
//  BYBasePageModel.h
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYBasePageModel : NSObject

@property (strong,nonatomic) Class objectClass;
@property (strong,nonatomic) NSString * relativePath;
@property (strong,nonatomic) NSString * listKey;//
@property (strong,nonatomic) NSString * pageIndexKey;
@property (strong,nonatomic) NSString * pageSizeKey;
@property (strong,nonatomic) NSString * totalPageKey;
@property (strong,nonatomic) NSString * totalKey;//数据总数key
@property (strong,nonatomic) NSDictionary * generateParameters;


//- (Class)objectClass;
//- (NSString*)relativePath;
//- (NSString*)listKey;
//- (NSString*)pageIndexKey;
//- (NSString*)pageSizeKey;
//- (NSDictionary*)generateParameters;

@end
