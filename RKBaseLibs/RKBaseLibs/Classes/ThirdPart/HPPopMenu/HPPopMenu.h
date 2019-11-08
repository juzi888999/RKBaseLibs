//
//  HPPopMenu.h
//  RKBaseLibs
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPPopMenu;
@protocol HPPopMenuDelegate <NSObject>

@optional
- (UIView*)popMenu:(HPPopMenu*)menu popContentViewForIndex:(NSInteger)index;

- (void)popMenu:(HPPopMenu*)menu didTapSegmentAtIndex:(NSInteger)index item:(NSDictionary *)item;
- (void)willShowPopMenu:(HPPopMenu*)menu;
- (void)willHiddenPopMenu:(HPPopMenu*)menu;

@end

@interface HPPopMenu : UIView

//设置 normalTextColor , highlightedTextColor , indicatorColor ,indicatorHighlightedColor 之后要调用 reloadSegmentControllCustomViews;
@property (strong,nonatomic) UIColor * normalTextColor;
@property (strong,nonatomic) UIColor * highlightedTextColor;
@property (strong,nonatomic) UIColor * indicatorColor;
@property (strong,nonatomic) UIColor * indicatorHighlightedColor;
@property (strong,nonatomic) UIColor * saperateLineColor;
@property (strong,nonatomic) UIFont * textFont;

//自定义显示的superview 和 frame ，默认是self.superView frame默认覆盖self.bottom 一下的superView
- (void)showSuperView:(UIView *)showSuperView showFrame:(CGRect)showFrame;

- (void)reloadSegmentControllCustomViews;
- (void)tapSegmentAtIndex:(NSInteger)index;

@property (assign,nonatomic) BOOL disableTapClose;
@property (assign, nonatomic) id<HPPopMenuDelegate> delegate;

- (instancetype)initWithTitles:(NSArray*)titles;
- (void)closePopMenu;

/*!
 @brief: 设置标题
 @discussion: 设置完需要调用 reloadSegmentControllCustomViews 方法才能马上生效
 */
- (void)setTitle:(NSString *)title;
- (void)setTitle:(NSString *)title forSegmentIndex:(NSInteger)index;
- (void)setIndicatorImage:(NSString * )image forSegmentIndex:(NSInteger)index;
@end
