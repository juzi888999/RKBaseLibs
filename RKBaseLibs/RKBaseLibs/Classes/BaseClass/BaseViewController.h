//
//  BaseViewController.h
//  GPai
//
//  Created by rk on 15/12/6.
//  Copyright © 2015年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LeftNavBtnHandel)(UIButton *leftNavBtn , id viewController);
typedef void (^RightNavBtnHandel)(UIButton *rightNavBtn , id viewController);

typedef enum : NSUInteger {
    BYNavigationBarStyleMain,
    BYNavigationBarStyleWhite,
} BYNavigationBarStyle;

@interface BaseViewController : UIViewController
@property (copy,nonatomic) void(^viewWillDisappearBlock)(BOOL animated);
@property (copy,nonatomic) void(^viewDidDisappearBlock)(BOOL animated);
@property (copy,nonatomic) void(^viewWillAppearBlock)(BOOL animated);
@property (copy,nonatomic) void(^viewDidAppearBlock)(BOOL animated);
@property (copy,nonatomic) void(^didTapBackBtnAction)(void);

@end

@interface BaseViewController (Helper)
@property (assign,nonatomic) BOOL by_navigationBarHiddent;
@property (assign,nonatomic) BYNavigationBarStyle by_navigationBarStyle;
@property (strong,nonatomic)UIButton * by_navLeftBtn;
@property (strong,nonatomic)UIButton * by_navRightBtn;
@property (copy,nonatomic)LeftNavBtnHandel by_leftNavBtnHandel;
@property (copy,nonatomic)RightNavBtnHandel by_rightNavBtnHandel;
@property (nonatomic, assign) BOOL bNavigationBarIsTransparent;

//导航样式设置
- (void)setNavigationStyle;

/*创建导航按钮的方法*/
- (UIButton *)addRightNavigationBarButtonImage:(NSString *)image Title:(NSString *)title Target:(id)target Action:(SEL)action;
-(NSArray *)addRightNavigationBarButtons:(NSArray *)items target:(id)target action:(SEL)action;
-(UIButton *)addLeftNavigationBarButtonImage:(NSString *)image Title:(NSString *)title Target:(id)target Action:(SEL)action;
- (UIButton *)addRightNavigationBarButtonImage:(NSString *)image Title:(NSString *)title  block:(RightNavBtnHandel)block;
-(UIButton *)addLeftNavigationBarButtonImage:(NSString *)image Title:(NSString *)title block:(LeftNavBtnHandel)block;
-(void)createGoBackItem;
-(void)createDismissItem;

/*setLeftNavBtnTitle 和 setRightNavBtnTitle 只有创建过导航按钮之后才生效*/
- (void)setLeftNavBtnTitle:(NSString *)title;
- (void)setRightNavBtnTitle:(NSString *)title;

- (UIViewController *)getCurrentVC;

- (void)by_backAction;

//navigationBar hidden 的时候添加返回按钮
- (UIButton *)addBackButton;
- (UILabel *)addTitleLabel;
@end
