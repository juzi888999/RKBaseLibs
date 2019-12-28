//
//  HPPreference.h
//
//  Created by rk on 14-10-25.
//
//

#import <Foundation/Foundation.h>


@interface HPPreference : NSObject

+ (instancetype)shareInstance;


- (int)runTimes;
- (void)setRunTimes:(int)runTimes;
- (BOOL)canAutoLogin;
- (void)setAutoLogin:(BOOL)enable;
- (BOOL)hasLastAccount;
- (void)deleteAccount:(NSString*)account;
- (NSString*)lastValidAccount;
- (NSArray *)accounts;
- (NSString*)lastValidPassword;
- (void)setLastLoginUserName:(NSString*)name;
- (NSString*)lastLoginUserName;
- (void)setPassword:(NSString*)password forAccount:(NSString*)account;
- (void)setServerAddress:(NSString*)address port:(NSString*)port;
- (NSString*)serverAddress;
- (NSString*)serverPort;

- (NSString*)lastVersion;
- (void)setLastVersion:(NSString *)version;

- (BOOL)serverReady;
- (NSInteger)devenv;
- (void)setDevenv:(NSInteger)enable;// 0:production 1:dev_production  2:dev_dev

- (BOOL)downloadImageWifiOnly;
- (void)setDownLoadImageWifiOnly:(BOOL)wifiOnly;

- (void)setArticleFontSize:(CGFloat)fontSize;
- (CGFloat)articleFontSize;
- (CGFloat)fontScale;
- (NSString *)fontSizeDescription;

@property (assign, nonatomic) BOOL sound;
@property (assign, nonatomic) BOOL vibrate;
@property (assign, nonatomic) BOOL detailMsg;
@property (assign, nonatomic) BOOL noDisturb;

@property (assign,nonatomic) NSInteger loginFailCount;//连续登录失败次数， 连续3次登录失败就要填写验证码


@property (assign,nonatomic) NSTimeInterval serviceTimestamp;//服务器的时间戳
@property (assign,nonatomic) NSTimeInterval distanceByServiceTime;//与服务器的时间差 distanceByServiceTime ＝ 服务器时间－本地时间

@end

