//
//  VersionManager.m
//  RKBaseLibs
//
//  Created by rk on 2017/12/27.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "VersionManager.h"
#import "OpenURLManager.h"

@implementation XBVersionEntity

@end

@implementation XBVersionCacheGameRuleVersionEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"n_typename":@"typename"
             };
}
@end
@implementation XBVersionCacheVersionEntity

+ (NSValueTransformer *)gameClassVersionsJSONTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[XBVersionCacheGameRuleVersionEntity class]];
}

@end


@implementation VersionManager

static VersionManager *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[VersionManager alloc] init];
    });
    return _instance;
}

//获取最新缓存版本号
- (void)checkCacheVersionAndUpdateCachedIfNeed
{
//    NSMutableDictionary * params = @{}.mutableCopy;
//    @weakify(self);
//    [[NetworkClient sharedInstance] postWithPath:XBApi_app_cacheVersion params:params success:^(HPResponseEntity * responseObject) {
//        @strongify(self);
//        if (self) {
//            NSString * fileName = FileNameCachedVersion;
//            XBVersionCacheVersionEntity * newEntity = [MTLJSONAdapter modelOfClass:[XBVersionCacheVersionEntity class] fromJSONDictionary:[NSDictionary checkDictionary:responseObject.dataDic] error:nil];
//            self.cachedVersionEntity = newEntity;
//            @weakify(self);
//            [[HPFileManager shareManager] unarchiverDataWithFolderName:FolderNameSystemSetting fileName:fileName success:^(XBVersionCacheVersionEntity * oldEntity) {
//                @strongify(self);
//                if (self) {
//                    if (oldEntity) {
//
//#ifdef DEBUG
//                        if (XBVersionTestCached) {
//                            [UIGlobal showAlertWithTitle:[NSString stringWithFormat:@"oldNav:%@\nnewNav:%@",[NSString checkString:oldEntity.navigateVersion],[NSString checkString:newEntity.navigateVersion]] message:[NSString stringWithFormat:@"oldRule:%@ \nnewRule:%@",oldEntity.gameClassVersions.firstObject,newEntity.gameClassVersions.firstObject] customizationBlock:NULL completionBlock:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
//
//                            } cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                        }
//#endif
//                        //首页缓存数据版本对比，并更新
//                        NSInteger oldNavgateVersion = [NSString checkString:oldEntity.navigateVersion].integerValue;
//                        NSInteger newNavgateVersion = [NSString checkString:newEntity.navigateVersion].integerValue;
//                        if (oldNavgateVersion != newNavgateVersion) {
//                            NSLog(@"%@",[NSString stringWithFormat:@"缓存版本较低 : %@,%@,%@",FileNameNavigate,FileNameNavigateOne,FileNameGameSelection]);
//                            [[HPFileManager shareManager] removeFileWithFolder:CacheFolderNameTemp fileName:FileNameNavigate success:^(NSString * path , NSError * error) {
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationDidUpdateNavigateCached object:FileNameNavigate];
//                            }];
//                            [[HPFileManager shareManager] removeFileWithFolder:CacheFolderNameTemp fileName:FileNameNavigateOne success:^(NSString * path , NSError * error) {
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationDidUpdateNavigateCached object:FileNameNavigateOne];
//                            }];
//                            [[HPFileManager shareManager] removeFileWithFolder:CacheFolderNameTemp fileName:FileNameGameSelection success:^(NSString * path , NSError * error) {
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationDidUpdateNavigateCached object:FileNameGameSelection];
//                            }];
//                        }
//
//                        for (XBVersionCacheGameRuleVersionEntity * gameItem in newEntity.gameClassVersions) {
//                            NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF.game = %@ && SELF.type_id = %@",gameItem.game,gameItem.type_id];
//                            NSArray * result = [oldEntity.gameClassVersions filteredArrayUsingPredicate:pre];
//                            XBVersionCacheGameRuleVersionEntity * oldGameItem = result.firstObject;
//                            if (oldGameItem) {
//                                if ([NSString checkString:oldGameItem.version].integerValue != [NSString checkString:gameItem.version].integerValue) {
//                                    NSString  * fileName = [[HPFileManager shareManager] gameCachedFileNameWithGame:oldGameItem.game typeId:oldGameItem.type_id];
//                                    [[HPFileManager shareManager] removeFileWithFolder:CacheFolderNameTemp fileName:fileName success:^(NSString * path , NSError * error) {
//                                        NSLog(@"%@",[NSString stringWithFormat:@"玩法缓存版本较低 : %@",fileName]);
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:kHPNotificationDidUpdateGameRuleCached object:fileName];
//                                    }];
//                                }
//                            }
//                        }
//                    }
//
//                    [[HPFileManager shareManager] archiverdData:newEntity folderName:FolderNameSystemSetting fileName:fileName];
//                }
//            }];
//
//        }
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];

}

- (void)checkVersion
{
    @weakify(self);
    [[NetworkClient sharedInstance] getWithPath:self.path params:nil success:^(HPResponseEntity * responseObject) {
        @strongify(self);
        if (self) {
            XBVersionEntity * object = [MTLJSONAdapter modelOfClass:[XBVersionEntity class] fromJSONDictionary:[NSDictionary checkDictionary:responseObject.result] error:nil];
            if (self.versionEntity) {
                object.showTimes = self.versionEntity.showTimes;
            }
            self.versionEntity = object;
            [self showUpdateAlert];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

+(NSString *)getCurrentVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return [NSString stringWithFormat:@"版本号：V%@(%@)",version,build];
}

-(void)showUpdateAlert
{
    if (!self.versionEntity) {
        return;
    }
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    XBVersionEntity * object = self.versionEntity;
    BOOL hasNewVersion = object.versionCode > build.integerValue;
    if (hasNewVersion) {
        NSString * msg = [NSString stringWithFormat:@"检测到可升级版本V%@\n本次更新内容\n%@",[NSString checkString:object.versionName],[NSString checkString:object.tips]];
        NSString * title = @"升级提示";
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [OpenURLManager openUrl:object.downloadUrl];
            exit(0);
        }];
        
        if (!object.mustUpdate) {
           
            if (object.showTimes > 0) {
                return;
            }
            object.showTimes +=1;
            [alert addAction:cancelAction];
            [alert addAction:sureAction];
            [self.viewController presentViewController:alert animated:YES completion:NULL];
     
        }else{

            object.showTimes +=1;
            [alert addAction:sureAction];
            [self.viewController presentViewController:alert animated:YES completion:NULL];

        }
    }
}
@end
