//
//  BYBaseNavSegmentViewController.h
//  RKBaseLibs 
//
//  Created by rk on 16/9/13.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "HMSegmentedControl.h"
#import "HPPagingViewController.h"

typedef enum : NSUInteger {
    BYBaseNavSegmentTypeCustom,
    BYBaseNavSegmentTypeTitle,
    BYBaseNavSegmentTypeButton
} BYBaseNavSegmentType;

@interface BYNavSegmentItemView : UIView
@property (strong,nonatomic) UILabel * unreadView;
@property (strong,nonatomic) UILabel * titleLabel;

@property (assign,nonatomic) NSInteger index;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title num:(NSInteger)num;
- (void)setBadgeNum:(NSInteger)num;
@property (copy,nonatomic) void(^didTapBlock)(UITapGestureRecognizer * tap);
@end



@interface BYBaseNavSegmentViewController : HPPagingViewController

@property (strong,nonatomic)UISegmentedControl *segmentControl;
@property (strong,nonatomic)HMSegmentedControl * segment;
@property (strong,nonatomic)UIView * indicator;


@property (assign,nonatomic) BOOL enableFlipAnimate;
@property (assign,nonatomic) NSInteger selectedIndex;//viewdidload 前设置有效
@property (assign,nonatomic) BYBaseNavSegmentType segmentType;
- (void)setBadgeNum:(NSInteger)num atIndex:(NSInteger)index;
- (void)createSegmentWithStyle:(BYBaseNavSegmentType)segmentType;
@property (assign,nonatomic) BOOL (^shouldSelectItem)(NSString * title, NSInteger index);

- (void)selectSegmentIndex:(NSUInteger)index;
- (NSUInteger)currentSelectSegmentIndex;

-(void)segmentValueChange:(UISegmentedControl *)seg;

@end
