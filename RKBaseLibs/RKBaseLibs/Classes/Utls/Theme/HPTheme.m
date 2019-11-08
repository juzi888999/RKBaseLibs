//
//  HPTheme.m
//
//  Created by rk on 14-10-21.
//
//

#import "HPTheme.h"
#import <XMLDictionary/XMLDictionary.h>
#import "UIColor+XMC.h"
#import <YYKit/UIImage+YYAdd.h>

@interface HPTheme ()

@property (nonatomic, strong) NSDictionary *imgDict;
@property (nonatomic, strong) NSDictionary *colorDict;
@property (nonatomic, strong) NSDictionary *textDict;

@end

@implementation HPTheme

+ (instancetype)shareInstance
{
    static HPTheme *theme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theme = [HPTheme new];
        XMLDictionaryParser *parser = [XMLDictionaryParser sharedInstance];
        parser.attributesMode = XMLDictionaryAttributesModeUnprefixed;
        theme.imgDict = [NSDictionary dictionaryWithXMLFile:[[NSBundle mainBundle] pathForResource:@"images" ofType:@"xml"]];
        theme.colorDict = [NSDictionary dictionaryWithXMLFile:[[NSBundle mainBundle] pathForResource:@"colors" ofType:@"xml"]];
        theme.textDict = [NSDictionary dictionaryWithXMLFile:[[NSBundle mainBundle] pathForResource:@"strings" ofType:@"xml"]];
    });
    return theme;
}

- (UIColor *)colorForKey:(NSString *)key
{
    if ([key hasPrefix:@"#"])
        return [UIColor colorWithHexString:key];
    NSArray *nodes = [self.colorDict valueForKey:@"color"];
    if (![nodes isKindOfClass:[NSArray class]])
    {
        if ([nodes isKindOfClass:[NSDictionary class]])
            nodes = @[nodes];
        else
            nodes = @[];
    }
    NSArray *filter = [nodes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" (name == %@ ) ", key]];
    if (filter.count == 0)
        return nil;
    NSDictionary *d = filter[0];
    NSString *value = [d innerText];
    if ([value hasPrefix:@"#"] && value.length == 9)
        value = [NSString stringWithFormat:@"#%@%@", [value substringWithRange:NSMakeRange(3, 6)],[value substringWithRange:NSMakeRange(1, 2)]];
    return [UIColor colorWithHexString:value];
}

- (NSString *)textForKey:(NSString *)key
{
    NSArray *nodes = [self.textDict valueForKey:@"string"];
    if (![nodes isKindOfClass:[NSArray class]])
    {
        if ([nodes isKindOfClass:[NSDictionary class]])
            nodes = @[nodes];
        else
            nodes = @[];
    }
    NSArray *filter = [nodes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" (name == %@ ) ", key]];
    if (filter.count == 0)
        return key;
    NSDictionary *d = filter[0];
    NSString *value = [d innerText];
    return value;
    //    NSString *tbl = @"";
    //    return NSLocalizedStringFromTable(key, tbl, @"");
}

- (UIImage *)imageForKey:(NSString *)key
{
    NSArray *nodes = [self.imgDict valueForKey:@"image"];
    if (![nodes isKindOfClass:[NSArray class]])
    {
        if ([nodes isKindOfClass:[NSDictionary class]])
            nodes = @[nodes];
        else
            nodes = @[];
    }
    NSArray *filter = [nodes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" (name == %@ ) ", key]];
    if (filter.count == 0)
        return [UIImage imageNamed:key];
    NSDictionary *d = filter[0];
    NSString *value = [d innerText];
    return [UIImage imageNamed:value];
}

- (UIImage *)imageForKey:(NSString *)key withCached:(BOOL)cached ofType:(NSString *)type
{
    NSArray *nodes = [self.imgDict valueForKey:@"image"];
    if (![nodes isKindOfClass:[NSArray class]])
    {
        if ([nodes isKindOfClass:[NSDictionary class]])
            nodes = @[nodes];
        else
            nodes = @[];
    }
    NSArray *filter = [nodes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@" (name == %@ ) ", key]];
    if (filter.count == 0){
        if (cached) {
            return [UIImage imageNamed:key];
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:type];
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    NSDictionary *d = filter[0];
    NSString *value = [d innerText];
    if (cached) {
        return [UIImage imageNamed:value];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:value ofType:type];
        return [UIImage imageWithContentsOfFile:path];
    }
}

- (UIFont *)boldFontWithSize:(CGFloat)size
{
//    if ([UIScreen mainScreen].scale <= 2)  size -= 1;
    return [UIFont boldSystemFontOfSize:AdaptedWidthValue(size)];
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:AdaptedWidthValue(size)];
}

- (UIFont *)smallFont{
//    return [UIFont systemFontOfSize:AdaptedWidthValue(12)];
    return [UIFont systemFontOfSize:12];
}

- (UIFont *)mediumFont{
//    return [UIFont systemFontOfSize:AdaptedWidthValue(17)];
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)bigFont{
    return [UIFont systemFontOfSize:18];
}

- (UIViewContentMode)videoCoverViewContentMode
{
    return UIViewContentModeScaleToFill;
}
-(UIImage *)placeholderImage
{
//    return [UIImage imageWithColor:HPColorForKey(@"#f5f5f5")];
   return [UIImage imageWithColor:HPColorForKey(@"#f5f5f5") size:CGSizeMake(1, 1)];
//    return HPImageForKey(@"default_4-3");
}
- (UIImage *)placeholderImageBig
{
//    return HPImageForKey(@"default_2-1");
    return [UIImage imageWithColor:HPColorForKey(@"#f5f5f5") size:CGSizeMake(2, 1)];
}
- (UIImage *)videoPlaceholderImage
{
//    return HPImageForKey(@"default_16-9");
    return [UIImage imageWithColor:HPColorForKey(@"#f5f5f5") size:CGSizeMake(16, 9)];
}

@end
@implementation HPTheme(RKBaseLibs)

#pragma mark - button
+ (UIButton *)themeButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor backgroundHighlightColor:(UIColor *)backgroundHighlightColor
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = HPFontWithSize(19);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (backgroundColor) {
        UIImage * backgroundImage = [UIImage imageWithColor:backgroundColor];
        if (backgroundImage) {
            [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        }
    }
    if (backgroundHighlightColor) {
        UIImage * backgroundHighlightedImage = [UIImage imageWithColor:backgroundHighlightColor];
        if (backgroundHighlightedImage) {
            [button setBackgroundImage:backgroundHighlightedImage forState:UIControlStateSelected];
            [button setBackgroundImage:backgroundHighlightedImage forState:UIControlStateHighlighted];
        }
    }
    return button;
}

+ (UIButton *)themeButtonWithTitle:(NSString *)title backgroundImageName:(NSString *)backgroundImageName
{
    NSString * bgHighlightedImageName = nil;
    if ([NSString checkString:backgroundImageName].length > 0) {
        bgHighlightedImageName = [backgroundImageName stringByAppendingString:@"_s"];
    }
    UIButton * button = [HPTheme themeButtonWithTitle:title normalImage:nil highlightedImage:nil backgroundImageName:backgroundImageName backgroundHighlightedImagename:bgHighlightedImageName];
    return button;
}

+ (UIButton *)themeButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage backgroundImageName:(NSString *)backgroundImageName
{
    NSString * bgHighlightedImageName = nil;
    if ([NSString checkString:backgroundImageName]) {
        bgHighlightedImageName = [backgroundImageName stringByAppendingString:@"_s"];
    }
    UIButton * button = [HPTheme themeButtonWithTitle:title normalImage:normalImage highlightedImage:nil backgroundImageName:backgroundImageName backgroundHighlightedImagename:bgHighlightedImageName];
    return button;
}

+ (UIButton *)themeButtonWithTitle:(NSString *)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage backgroundImageName:(NSString *)backgroundImageName backgroundHighlightedImagename:backgroundHighlightedImageName
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = HPFontMediumSizeFont;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:HPImageForKey(normalImage) forState:UIControlStateNormal];
    [button setImage:HPImageForKey(highlightedImage) forState:UIControlStateHighlighted];
    if (normalImage) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    }
    UIImage * backgroundImage = HPImageForKey(backgroundImageName);
    UIImage * backgroundHighlightedImage = HPImageForKey(backgroundHighlightedImageName);
    if (backgroundImageName) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (backgroundHighlightedImage) {
        [button setBackgroundImage:backgroundHighlightedImage forState:UIControlStateSelected];
        [button setBackgroundImage:backgroundHighlightedImage forState:UIControlStateHighlighted];
    }
//    [button setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    return button;
}


#pragma mark - inputBox

/*
 @param title 标题 并根据标题计算label宽度
 @param completionHandle 回传inputBoxBg和textField对象
 */
+ (void)themeInputBoxWithTitle:(NSString *)title completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle
{
    [HPTheme themeInputBoxWithTitle:title widthTitle:title completionHandle:completionHandle];
}

/*
 @param title 标题
 @param widthTitle 根据此标题来计算label的宽度
 @param completionHandle 回传inputBoxBg和textField对象
 */
+ (void)themeInputBoxWithTitle:(NSString *)title widthTitle:(NSString *)widthTitle completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle
{
    UIImageView * inputBoxBg = [[UIImageView alloc]init];
    UIImage * image = HPImageForKey(@"input_box");
    if (image) {
        CGSize size = image.size;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0,size.width/2.f,0,size.width/2.f) resizingMode:UIImageResizingModeStretch];
        //    [inputBoxBg.image stretchableImageWithLeftCapWidth:100 topCapHeight:10];
        inputBoxBg.image = image;
    }
    inputBoxBg.userInteractionEnabled = YES;

    UIFont * font = HPFontMediumSizeFont;
    NSMutableAttributedString * attribute = [HPTheme attributeStringWithTitle:title widthTitle:widthTitle font:font];
    UILabel * nameTitleLabel = [UILabel rightAlignLabel];
    nameTitleLabel.font = font;
    nameTitleLabel.textColor = HPColorForKey(@"#5c5c5c");
    [inputBoxBg addSubview:nameTitleLabel];
    
    nameTitleLabel.attributedText = attribute;
    [nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptedWidthValue(25));
        make.width.mas_equalTo(ceilf(attribute.size.width));
        make.centerY.mas_equalTo(inputBoxBg);
    }];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectZero];
    textField.font = nameTitleLabel.font;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textColor = nameTitleLabel.textColor;
    [inputBoxBg addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameTitleLabel.mas_right).offset(0);
        make.right.mas_equalTo(inputBoxBg).offset(AdaptedWidthValue(-25));
        make.top.bottom.mas_equalTo(inputBoxBg);
    }];
    
    if (completionHandle) {
        completionHandle(inputBoxBg,textField);
    }
}

+ (NSMutableAttributedString *)attributeStringWithTitle:(NSString *)title widthTitle:(NSString *)widthTitle font:(UIFont *)font
{
    if (title== nil) {
        return nil;
    }
    CGFloat appendWidth = 0;
    NSString * maohao = @"：";
    if ([title hasSuffix:maohao]) {
        title = [title stringByReplacingOccurrencesOfString:maohao withString:@""];
    }
    if ([widthTitle hasSuffix:maohao]) {
        appendWidth = [maohao textSizeWithFont:font].width;
        widthTitle = [widthTitle stringByReplacingOccurrencesOfString:maohao withString:@""];
    }else{
        maohao = @"";
    }
    
    CGFloat maxWidth = ([widthTitle textSizeWithFont:font].width);
    CGFloat titleWidth = ([title textSizeWithFont:font].width);
    CGFloat space = ((maxWidth - titleWidth)/(title.length - 1));
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:title];
    [attribute addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, title.length)];
    NSAttributedString * attributeMaohao = [[NSAttributedString alloc]initWithString:maohao attributes:@{NSFontAttributeName:font}];
    [attribute appendAttributedString:attributeMaohao];
    [attribute addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:space] range:NSMakeRange(0, title.length-1)];
    [attribute addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:6] range:NSMakeRange(title.length-1, 1)];
    return attribute;
}

/*
 @param placeholder
 @return UITextField 实例对象
 */
+ (void)themeInputBoxWithPlaceholder:(NSString *)placeholder completionHandle:(void (^)(UIImageView *inputBoxBg , UITextField * textField))completionHandle

{
    UIImageView * inputBoxBg = [[UIImageView alloc]init];
    UIImage * image = HPImageForKey(@"input_box");
    if (image) {
        CGSize size = image.size;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0,size.width/2.f,0,size.width/2.f) resizingMode:UIImageResizingModeStretch];
        //    [inputBoxBg.image stretchableImageWithLeftCapWidth:100 topCapHeight:10];
        inputBoxBg.image = image;
    }
    inputBoxBg.userInteractionEnabled = YES;
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectZero];
    textField.font = HPFontMediumSizeFont;
    textField.textColor = HPColorForKey(@"#5c5c5c");
    [inputBoxBg addSubview:textField];
    
    NSMutableAttributedString * attributePlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributePlaceholder addAttribute:NSFontAttributeName value:HPFontMediumSizeFont range:NSMakeRange(0, placeholder.length)];
    [attributePlaceholder addAttribute:NSForegroundColorAttributeName value:HPColorForKey(@"text.minor") range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = attributePlaceholder;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputBoxBg).offset(AdaptedWidthValue(20));
        make.right.mas_equalTo(inputBoxBg).offset(-AdaptedWidthValue(20));
        make.top.bottom.mas_equalTo(inputBoxBg);
    }];
    
    if (completionHandle) {
        completionHandle(inputBoxBg,textField);
    }
}

@end
