//
//  MAdvertisementModel.h
//  RKBaseLibs
//
//  Created by minimac on 2019/10/12.
//  Copyright © 2019 rk. All rights reserved.
//

#import "BYPageModel.h"

@interface RKAdvertisementEntity : HPEntity

@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * remark;
@property (strong,nonatomic) NSString * img;//图片url 多个用逗号分隔
@property (strong,nonatomic) NSString * href;//跳转链接url 多个用逗号分隔
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * location;
@property (strong,nonatomic) NSString * sort;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * clickNums;
@property (strong,nonatomic) NSString * startDate;
@property (strong,nonatomic) NSString * endDate;
@property (strong,nonatomic) NSString * id;


@end

@interface RKAdvertisementRequest : HPPageRequest
//位置(1:app启动页,2:首页,3:频道,4:发现,5:我的,6:视频详情,7:视频)
@property (strong,nonatomic) NSString * location;

@end

@interface RKAdvertisementModel : BYPageModel

+ (instancetype)shareInstance;//视频广告用
@property (strong,nonatomic) NSMutableArray * adList;
@end
