//
//  HPPreference.m
//
//  Created by rk on 14-10-25.
//
//

#import "HPPreference.h"
#import <SAMKeychain/SAMKeychain.h>

#define KPreferenceKeyAutoLogin @"auto-login"
#define KPreferenceKeyFirstRun @"first-run"
#define KPreferenceKeyRunTimes @"run-times"
#define KPreferenceServiceName @"preference"
#define KPreferenceServiceAddress @"p:server:address"
#define KPreferenceServicePort @"p:server:port"
#define KPreferenceServiceLastLoginUserName @"p:user:lastestLogin"
#define kPreferenceSound @"p:sound"
#define kPreferenceShake @"p:shake"
#define kPreferenceDetailMsg @"p:detail-msg"
#define kPreferenceNoHarass @"p:noharass"
#define kPreferenceWifiOnly @"downloadImageWifiOnly"
#define kPreferenceArticleFontSize @"kPreferenceArticleFontSize"

#define kPreferenceLoginFailCount @"kPreferenceLoginFailCount"
#define kPreferenceLastVersion @"kPreferenceLastVersion"


@implementation HPPreference

+ (instancetype)shareInstance
{
    static HPPreference *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[HPPreference alloc] init];
        if (![share has:kPreferenceSound])
            share.sound = YES;
        if (![share has:kPreferenceShake])
            share.vibrate = YES;
        if (![share has:kPreferenceDetailMsg])
            share.detailMsg = NO;
        if (![share has:kPreferenceNoHarass])
            share.noDisturb = YES;
        if (![share has:KPreferenceKeyAutoLogin])
            [share setAutoLogin:YES];
    });
    return share;
}

- (BOOL)has:(NSString*)key
{
    if (key.length == 0)
        return NO;
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return [NSStringFromClass([value class]) length] > 0;
}

- (void)setRunTimes:(int)runTimes
{
    NSLog(@"runTimes : %d",runTimes);
    [[NSUserDefaults standardUserDefaults] setValue:@(runTimes) forKey:KPreferenceKeyRunTimes];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)runTimes
{
    NSNumber * runtimes = [[NSUserDefaults standardUserDefaults] objectForKey:KPreferenceKeyRunTimes];
    if (!runtimes || [runtimes integerValue] == 0) {
        return 0;
    }
    return [runtimes intValue];
}

- (BOOL)canAutoLogin
{
    BOOL autoLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceKeyAutoLogin] boolValue];
    return autoLogin;
}

- (void)setAutoLogin:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setValue:@(enable) forKey:KPreferenceKeyAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasLastAccount
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceServiceLastLoginUserName] length] > 0;
}

- (void)deleteAccount:(NSString*)account
{
    if (account.length > 0)
        [SAMKeychain deletePasswordForService:KPreferenceServiceName account:account];
}

- (NSString*)lastValidAccount
{
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceServiceLastLoginUserName];
    NSArray *accounts = [SAMKeychain accountsForService:KPreferenceServiceName];
    if ([[accounts valueForKey:kSAMKeychainAccountKey] containsObject:name])
        return name;
    return nil;
}

- (NSArray *)accounts
{
    NSArray *accounts = [SAMKeychain accountsForService:KPreferenceServiceName];
    return [accounts valueForKey:kSAMKeychainAccountKey];
}

- (NSString *)lastValidPassword
{
    NSString *account = [self lastValidAccount];
    if (account.length == 0)
        return nil;
    return [SAMKeychain passwordForService:KPreferenceServiceName account:account];
}

- (void)setLastLoginUserName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString checkString:name] forKey:KPreferenceServiceLastLoginUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)lastLoginUserName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceServiceLastLoginUserName];
}
- (void)setLastVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setValue:version forKey:kPreferenceLastVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)lastVersion
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceLastVersion];
}

- (void)setPassword:(NSString *)password forAccount:(NSString *)account
{
    [SAMKeychain setPassword:password forService:KPreferenceServiceName account:account];
    [self setLastLoginUserName:account];
}

- (void)setServerAddress:(NSString *)address port:(NSString *)port
{
    if (address.length == 0)
        return;
    [[NSUserDefaults standardUserDefaults] setValue:address forKey:KPreferenceServiceAddress];
    [[NSUserDefaults standardUserDefaults] setValue:port forKey:KPreferenceServicePort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)serverAddress
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceServiceAddress];
}

- (NSString *)serverPort
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:KPreferenceServicePort];
}

- (BOOL)serverReady
{
    return [[self serverAddress] length] > 0 && [[self serverPort] length] > 0;
}

- (NSInteger)devenv
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"dev"] integerValue];
}

- (void)setDevenv:(NSInteger)enable
{
    [[NSUserDefaults standardUserDefaults] setValue:@(enable) forKey:@"dev"];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dev"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)sound
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceSound] boolValue];
}

- (void)setSound:(BOOL)sound
{
    [[NSUserDefaults standardUserDefaults] setValue:@(sound) forKey:kPreferenceSound];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)loginFailCount
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceLoginFailCount] integerValue];
}

- (void)setLoginFailCount:(NSInteger)loginFailCount
{
    [[NSUserDefaults standardUserDefaults] setValue:@(loginFailCount) forKey:kPreferenceLoginFailCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)vibrate
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceShake] boolValue];
}
- (void)setVibrate:(BOOL)vibrate
{
    [[NSUserDefaults standardUserDefaults] setValue:@(vibrate) forKey:kPreferenceShake];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)detailMsg
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceDetailMsg] boolValue];
}
- (void)setDetailMsg:(BOOL)detailMsg
{
    [[NSUserDefaults standardUserDefaults] setValue:@(detailMsg) forKey:kPreferenceDetailMsg];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)noDisturb
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceNoHarass] boolValue];
}
- (void)setNoDisturb:(BOOL)noDisturb
{
    [[NSUserDefaults standardUserDefaults] setValue:@(noDisturb) forKey:kPreferenceNoHarass];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDownLoadImageWifiOnly:(BOOL)wifiOnly
{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(wifiOnly) forKey:kPreferenceWifiOnly];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)downloadImageWifiOnly
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceWifiOnly] boolValue];
}

- (void)setArticleFontSize:(CGFloat)fontSize
{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:kPreferenceArticleFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(CGFloat)articleFontSize
{
    NSNumber * value = [[NSUserDefaults standardUserDefaults] valueForKey:kPreferenceArticleFontSize];
    if (value == nil) {
        return 15.f;
    }
    return [value floatValue];
}
- (CGFloat)fontScale
{
    CGFloat fontSize = [self articleFontSize];
    if (@(fontSize).integerValue <= 14 ) {
        return 1.f;
    }else if (@(fontSize).integerValue <= 15 ) {
        return 1.1f;
    }else if (@(fontSize).integerValue <= 16 ) {
        return 1.2f;
    }else if (@(fontSize).integerValue <= 17 ) {
        return 1.3f;
    }
    return 1.f;
}
- (NSString *)fontSizeDescription
{
    CGFloat fontSize = [self articleFontSize];
    if (@(fontSize).integerValue <= 14 ) {
        return @"小";
    }else if (@(fontSize).integerValue <= 15 ) {
        return @"中";
    }else if (@(fontSize).integerValue <= 16 ) {
        return @"大";
    }else if (@(fontSize).integerValue <= 17 ) {
        return @"超大";
    }
    /*else if (@(fontSize).integerValue <= 18 ) {
        return @"巨大";
    }*/
    return @"标准";
}

@end

