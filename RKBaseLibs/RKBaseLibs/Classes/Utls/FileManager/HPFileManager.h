//
//  HPFileManager.h
//  RKBaseLibs
//
//  Created by rk on 15/6/12.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import <Foundation/Foundation.h>

//folderName
static  NSString * CacheFolderNameVoice = @"voice";//语音文件夹
static  NSString * CacheFolderNameImage = @"image";//图片文件夹
static  NSString * CacheFolderNameAttach = @"attach";//附件文件夹
static  NSString * CacheFolderNameRecord = @"Record";//添加积分 等数据记录文件夹
static  NSString * CacheFolderNameTemp = @"CacheFolderNameTemp";//临时目录

//以下目录不计算缓存，清空缓存时不删除
static  NSString * FolderNameSystemSetting = @"FolderNameSystemSetting";//系统参数
static  NSString * FolderNameUserData = @"FolderNameUserData";//用户数据
static  NSString * FolderNameMessage = @"Message";//用来存放未读消息，记录未读数
static NSString * FolderNameLog = @"Log";//定位数据提交记录目录

static  NSString * FileNameCachedVersion = @"cachedVersion";
static  NSString * FileNameNavigate = @"navigate";
static  NSString * FileNameNavigateOne = @"navigateOne";
static  NSString * FileNameGameSelection = @"gameSelection";
static  NSString * FileNameOddsTable = @"oddsTable";
static  NSString * FileNameDiscover = @"discover";

//in folder FolderNameLog
static  NSString * FileNameLog = @"log";

//in folder FolderNameMessage
static  NSString * FileNameUnreadMessageMine = @"UnreadMessage";
static  NSString * FileNameUnreadMessageOrder = @"UnreadMessageOrder";

static NSString * SystemSettingFileName = @"SystemSettingFileName";

static NSString * XBFileNameDelegateOddsOldList = @"XBFileNameDelegateOddsOldList.archived";//代理返点报表官方玩法
static NSString * XBFileNameDelegateOddsNewList = @"XBFileNameDelegateOddsNewList";//代理返点报表信用玩法

static NSString * XBFileNameGameSelectionList = @"XBFileNameGameSelectionList";//代理返点报表官方玩法

@interface HPFileManager : NSObject

+ (instancetype)shareManager;

- (void)clearCacheFolderWithFolder:(NSString *)folderName;
- (void)clearAllCacheInCachesFloderWithCompletionHandle:(void(^)())completionHandle;
- (void)clearImageCacheOnComletion:(void(^)())completedBlock;
- (void)clearVoiceCache;
- (void)clearAttachCache;
- (void)clearTempCache;

//判断是否是本地缓存路径
- (BOOL)isLocalCacheFilePath:(NSString *)filePath;

- (NSString *)writeToFileWithData:(NSData *)data folderName:(NSString *)folderName fileName:(NSString *)fileName pathExtension:(NSString *)pathExtension;
- (NSString *)writeToFileWithData:(NSData *)data folderName:(NSString *)folderName pathExtension:(NSString *)pathExtension;
/**
 *  获取文件本地url
 *
 *  @param fileName   文件名
 *  @param folderName 文件夹名
 *
 *  @return 本地文件url
 */
- (NSURL *)fileUrlWithFileName:(NSString *)fileName folderName:(NSString *)folderName;
- (NSURL *)voiceFileUrlWithFileName:(NSString *)fileName;
- (NSURL *)attachFileUrlWithFileName:(NSString *)fileName;
- (NSURL *)imageFileUrlWithFileName:(NSString *)fileName; //不包含SDWebImage的缓存


/**
 *  获取图片UIImage对象
 *
 *  @param url 图片路径 NSURL
 *
 *  @param completion 结果回调
 */
- (void)getExistLocalImageByPath:(NSURL *)url completion:(void(^)(UIImage * image))completion;

/**
 *  获取二进制文件对象
 *
 *  @param path               文件路径
 *  @param compressionQuality 压缩系数
 *
 *  @param completion   结果回调
 */
- (void)getExistLocalImageDataByPath:(NSURL *)path quality:(CGFloat)compressionQuality completion:(void(^)(NSData * data))completion;
- (NSData *)getExistLocalVoiceDataByPath:(NSURL *)url;
- (NSData *)getExistLocalAttachDataByPath:(NSURL *)url;
- (NSData *)getExistLocalFileWithFolderName:(NSString *)folderName fileName:(NSString *)fileName;

/**
 *  获取缓存路径
 *
 *  @param folderName 文件夹名
 *
 *  @return 缓存路径
 */
- (NSString *)cachePathWithFolder:(NSString *)folderName;

/**
 *  本地是否存在文件
 *
 *  @param fileName   文件名
 *  @param folderName 文件夹名
 *
 *  @return 是否存在
 */
- (BOOL)fileExistAtPathWithFileName:(NSString *)fileName folderName:(NSString *)folderName;

/**
 *  本地是否存在语音文件
 *
 *  @param fileName 文件名
 *
 *  @return 是否存在
 */
- (BOOL)fileExistAtVoiceFolderWithFileName:(NSString *)fileName;

/**
 *  本地是否存在附件文件
 *
 *  @param fileName 文件名
 *
 *  @return 是否存在
 */
- (BOOL)fileExistAtAttachFolderWithFileName:(NSString *)fileName;

/**
 *  本地是否存在图片文件（不包含SDWebImage的缓存）
 *
 *  @param fileName 文件名
 *
 *  @return 是否存在
 */
- (BOOL)fileExistAtImageFolderWithFileName:(NSString *)fileName;

/**
 *  本地是否存在图片文件
 *
 *  @param url 图片路径 NSURL
 *  @param completion 结果回调
 */
- (void)imageExistAtPath:(NSURL *)url completion:(void(^)(BOOL isInCache))completion;

/**
 *  @return 获取缓存文件大小 
 *  包含 SDImageCache 缓存路径 以及 CacheFolderNameVoice，
 *  CacheFolderNameImage，CacheFolderNameAttach，
 *  CacheFolderNameRecord，CacheFolderNameTemp 文件夹
 *  单位B 若要换算成MB 要 size／1024.0/1024.0
 */
- (long long )getSize;

- (long long)getSizeWithFolder:(NSString *)folderName;

/*
 定位log文件读写操作
 */
- (NSString *)appendLogWithString:(NSString *)logString;
- (NSString *)getLogString;
- (void)cleanLog;



- (void)archiverdData:(HPEntity *)entity folderName:(NSString *)folderName fileName:(NSString *)fileName;
- (void)unarchiverDataWithFolderName:(NSString *)folderName fileName:(NSString *)fileName success:(HPSuccess)success;
- (void)removeFileWithFolder:(NSString *)folderName fileName:(NSString *)fileName success:(void(^)(NSString * path ,NSError * error))success;

//获取信用玩法缓存
- (NSString *)gameCachedFileNameWithGame:(NSString *)game typeId:(NSString *)typeId;
//获取玩法缓存 isOffice = YES 则是官方玩法
- (NSString *)gameCachedFileNameWithGame:(NSString *)game typeId:(NSString *)typeId isOffice:(BOOL)isOffice;
@end
