//
//  XBNumberCalculate.h
//  XBNumberCalculate
//
//  Created by xxx on 2018/5/29.
//  Copyright © 2019年 RKBaseLibs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberCalculateDelegate <NSObject>

- (void)resultNumber:(NSString *)number;

@end

@interface XBNumberCalculate : UIView

- (instancetype)initWithFrame:(CGRect)frame btnWidth:(CGFloat)btnWidth;

/** 结果回传 */
@property (nonatomic, copy) void (^resultNumber)(NSString *number);
@property (nonatomic, weak) id<NumberCalculateDelegate>delegate;

/** 初始显示值 不传默认显示0  建议必传*/
@property (nonatomic, copy) NSString *baseNum;

/** 数值增减基数（倍数增减） 默认1的倍数增减 */
@property (nonatomic, assign) NSInteger multipleNum;

/** 最小值 默认且最小为0*/
@property (nonatomic, assign) NSInteger minNum;

/** 最大值  默认99999 */
@property (nonatomic, assign) NSInteger maxNum;


/** 数字框是否可以手动输入  默认可以 */
@property (nonatomic, assign) BOOL canText;

/** 是否隐藏边框线  默认显示 */
@property (nonatomic, assign) BOOL hidBorder;

/** 边框线颜色 */
@property (nonatomic, strong) UIColor *numborderColor;

/** 加减按钮颜色 */
@property (nonatomic, strong) UIColor *buttonColor;

/** 加减按钮disable颜色 */
@property (nonatomic, strong) UIColor *disableButtonColor;

/** 数字颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 是否开启晃动  默认开启 */
@property (nonatomic, assign) BOOL isShake;

/** 加减号按钮宽度 默认为父 view的高度 */
@property (assign,nonatomic) CGFloat btnWidth;

//每次修改属性调用这个方法刷新
- (void)updateView;
- (void)resetNum;

@end
