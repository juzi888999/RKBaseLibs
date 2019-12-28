//
//  RKCollectionViewAlignmentFlowLayout.h
//  RKBaseLibs
//
//  Created by juzi on 2019/11/16.
//  Copyright © 2019 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RKAlignmentLayoutType){
    RKAlignmentLayoutTypeLeft,
    RKAlignmentLayoutTypeCenter,
    RKAlignmentLayoutTypeRight
};

@interface RKCollectionViewAlignmentFlowLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign) CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)RKAlignmentLayoutType layoutType;

-(instancetype)initWthType:(RKAlignmentLayoutType)layoutType;
//全能初始化方法 其他方式初始化最终都会走到这里
-(instancetype)initWithType:(RKAlignmentLayoutType)layoutType betweenOfCell:(CGFloat)betweenOfCell;

@end
