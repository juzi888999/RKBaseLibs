//
//  HPTheme.h
//
//  Created by rk on 14-10-21.
//
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

//#import "XBTPTool.h"

#define HPTextForKey(a) [[HPTheme shareInstance] textForKey:a]
#define HPColorForKey(a) [[HPTheme shareInstance] colorForKey:a]
#define HPImageForKey(a) [[HPTheme shareInstance] imageForKey:a]
#define HPChessImageForKey(a) [XBTPTool chess_imageNamed:a]
#define HPBigPNGImageForKey(a) [[HPTheme shareInstance] imageForKey:a withCached:NO ofType:@"png"]
#define HPBigJPGImageForKey(a) [[HPTheme shareInstance] imageForKey:a withCached:NO ofType:@"jpg"]

#define HPFontWithSize(a) [[HPTheme shareInstance] fontWithSize:a]
#define HPBoldFontWithSize(a) [[HPTheme shareInstance] boldFontWithSize:a]
#define HPFontSmallSizeFont [[HPTheme shareInstance] smallFont]
#define HPFontMediumSizeFont [[HPTheme shareInstance] mediumFont]
#define HPFontBigSizeFont [[HPTheme shareInstance] bigFont]

#define HPPlaceholderImage [[HPTheme shareInstance] placeholderImage]
#define HPPlaceholderImageBig [[HPTheme shareInstance] placeholderImageBig]
#define HPVideoPlaceholderImage [[HPTheme shareInstance] videoPlaceholderImage]

#define HPMatchViewHeight (MainScreenWidth * 260/375)
#define HPArticlePicViewHeight (MainScreenWidth * 316/621)
#define HPPickerViewHeight 230
//HPImageForKey(@"placeholder")
#define HPDefaultPic HPImageForKey(@"default_pic")

@interface HPTheme : NSObject

+ (instancetype)shareInstance;
@property (copy,nonatomic) void(^applyNavigationBarThemeBlock)(BaseViewController * viewController);

- (UIColor*)colorForKey:(NSString*)key;
- (NSString*)textForKey:(NSString*)key;
- (UIImage*)imageForKey:(NSString*)key;
- (UIImage *)imageForKey:(NSString *)key withCached:(BOOL)cached ofType:(NSString *)type;

- (UIFont*)boldFontWithSize:(CGFloat)size;
- (UIFont*)fontWithSize:(CGFloat)size;
- (UIFont*)smallFont;
- (UIFont *)mediumFont;
- (UIFont *)bigFont;
- (UIViewContentMode)videoCoverViewContentMode;
- (UIImage *)placeholderImage;
- (UIImage *)placeholderImageBig;
- (UIImage *)videoPlaceholderImage;

@end

@interface HPTheme(RKBaseLibs)

+ (NSMutableAttributedString *)attributeStringWithTitle:(NSString *)title widthTitle:(NSString *)widthTitle font:(UIFont *)font;

/**inputbox*/
+ (void)themeInputBoxWithTitle:(NSString *)title completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle;
+ (void)themeInputBoxWithTitle:(NSString *)title widthTitle:(NSString *)widthTitle completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle;
+ (void)themeInputBoxWithPlaceholder:(NSString *)placeholder completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle;

/**button*/
+ (UIButton *)themeButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor backgroundHighlightColor:(UIColor *)backgroundHighlightColor;
+ (UIButton *)themeButtonWithTitle:(NSString *)title backgroundImageName:(NSString *)backgroundImageName;
+ (UIButton *)themeButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage backgroundImageName:(NSString *)backgroundImageName;
+ (UIButton *)themeButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage backgroundImageName:(NSString *)backgroundImageName backgroundHighlightedImagename:backgroundHighlightedImageName;

@end
