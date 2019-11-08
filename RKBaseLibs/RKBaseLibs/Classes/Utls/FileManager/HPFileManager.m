//
//  HPFileManager.m
//  RKBaseLibs
//
//  Created by rk on 15/6/12.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPFileManager.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCachesManager.h>
#import <SDWebImage/SDImageCache.h>

@implementation HPFileManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static HPFileManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[HPFileManager alloc] init];
    });
    return shared;
}

- (NSString *)writeToFileWithData:(NSData *)data folderName:(NSString *)folderName pathExtension:(NSString *)pathExtension
{
    NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    if ([NSString checkString:pathExtension].length == 0) {
        pathExtension = @"";
    }
    return [self writeToFileWithData:data folderName:folderName fileName:identifier pathExtension:pathExtension];
}

- (NSString *)writeToFileWithData:(NSData *)data folderName:(NSString *)folderName fileName:(NSString *)fileName pathExtension:(NSString *)pathExtension
{
    NSString *path = [[HPFileManager shareManager] cachePathWithFolder:folderName];
    NSString *identifier = fileName;
    if ([NSString checkString:pathExtension].length == 0) {
        pathExtension = @"";
    }
    NSString *fileUrl = [[path stringByAppendingPathComponent:identifier] stringByAppendingPathExtension:pathExtension];
    BOOL success = [data writeToFile:fileUrl atomically:YES];
    if (success) {
        NSLog(@"%@",fileUrl);
        return fileUrl;
    }
    return nil;
}

- (void)clearImageCacheOnComletion:(void(^)())completedBlock
{
    [self clearCacheFolderWithFolder:CacheFolderNameImage];
    [[SDImageCachesManager sharedManager] clearWithCacheType:SDImageCacheTypeDisk completion:^{
        if (completedBlock) {
            completedBlock();
        }
    }];
}

- (void)clearVoiceCache
{
    [self clearCacheFolderWithFolder:CacheFolderNameVoice];
}

-(void)clearAttachCache
{
    [self clearCacheFolderWithFolder:CacheFolderNameAttach];
}

- (void)clearTempCache
{
    [self clearCacheFolderWithFolder:CacheFolderNameTemp];
}

- (NSString *)cachePathWithFolder:(NSString *)folderName
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString * path = [cacheDir stringByAppendingPathComponent:folderName];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path])
    {
        NSError * error;
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            NSLog(@"%@",[error localizedDescription]);
        }
    }
    return path;
}

- (BOOL)isLocalCacheFilePath:(NSString *)filePath
{
    if (!filePath) {
        return NO;
    }
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    return [filePath hasPrefix:cacheDir];
}

- (void)clearCacheFolderWithFolder:(NSString *)folderName
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                            NSString * path = [cacheDir stringByAppendingPathComponent:folderName];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                           {
                               NSError * error;
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               if (error)
                               {
                                   NSLog(@"%@",[error localizedDescription]);
                               }

                           }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess:) withObject:folderName waitUntilDone:YES];
                   });
}
- (void)removeFileWithFolder:(NSString *)folderName fileName:(NSString *)fileName success:(void(^)(NSString * path ,NSError * error))success
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                       NSString * path = [cacheDir stringByAppendingPathComponent:folderName];
                       path = [path stringByAppendingPathComponent:fileName];
                       NSError * error;
                       if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                       {
                           [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           if (error)
                           {
                               NSLog(@"%@",[error localizedDescription]);
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (success) {
                               success(path,error);
                           }
                       });

                   });
}

- (void)removeFolderWithPath:(NSString *)path
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                       {
                           NSError * error;
                           [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           if (error)
                           {
                               NSLog(@"%@",[error localizedDescription]);
                           }
                           
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess:) withObject:path waitUntilDone:YES];
                   });
}

- (void)clearAllCacheInCachesFloderWithCompletionHandle:(void(^)())completionHandle
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       //                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                       NSString * cachPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];

                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files)
                       {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
                           NSLog(@"Path:%@",path);
                           if ([[self cacheFilePathArray] containsObject:path]) {
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                               {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                       }
                       [[SDImageCachesManager sharedManager] clearWithCacheType:SDImageCacheTypeDisk completion:^{
                           if (completionHandle) {
                               completionHandle();
                           }
                       }];
                      
//                       [self performSelectorOnMainThread:@selector(clearAllCacheSuccess:) withObject:cachPath waitUntilDone:YES];
                   });
}

//- (void)clearAllCacheSuccess:(NSString *)path
//{
//    [UIGlobal showMessage:@"清理成功"];
//}

-(void)clearCacheSuccess:(NSString *)path
{
    NSLog(@"清理成功 path : %@",path);
}

#pragma mark - private

- (NSArray *)cacheFilePathArray
{
    //除了这些缓存目录还有 SDImageCache 缓存
    NSString * fileCachePath1 = [self cachePathWithFolder:CacheFolderNameVoice];
    NSString * fileCachePath2 = [self cachePathWithFolder:CacheFolderNameImage];
    NSString * fileCachePath3 = [self cachePathWithFolder:CacheFolderNameAttach];
    NSString * fileCachePath4 = [self cachePathWithFolder:CacheFolderNameRecord];
    NSString * fileCachePath5 = [self cachePathWithFolder:CacheFolderNameTemp];
    return @[fileCachePath1,fileCachePath2,fileCachePath3,fileCachePath4,fileCachePath5];
}

#pragma mark -

- (NSURL *)voiceFileUrlWithFileName:(NSString *)fileName
{
    return [self fileUrlWithFileName:fileName folderName:CacheFolderNameVoice];
}

- (NSURL *)attachFileUrlWithFileName:(NSString *)fileName
{
    return [self fileUrlWithFileName:fileName folderName:CacheFolderNameAttach];
}
- (NSURL *)logFileUrlWithFileName:(NSString *)fileName
{
    return [self fileUrlWithFileName:fileName folderName:FolderNameLog];
}

- (NSURL *)imageFileUrlWithFileName:(NSString *)fileName
{
    return [self fileUrlWithFileName:fileName folderName:CacheFolderNameImage];
}

-(NSURL *)fileUrlWithFileName:(NSString *)fileName folderName:(NSString *)folderName
{
    NSString * folderPath = [self cachePathWithFolder:folderName];
    NSString *path = [folderPath stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}

- (BOOL)fileExistAtPathWithFileName:(NSString *)fileName folderName:(NSString *)folderName
{
    NSString * folderPath = [self cachePathWithFolder:folderName];
    NSString *path = [folderPath stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)fileExistAtVoiceFolderWithFileName:(NSString *)fileName
{
    return [self fileExistAtPathWithFileName:fileName folderName:CacheFolderNameVoice];
}

- (BOOL)fileExistAtAttachFolderWithFileName:(NSString *)fileName
{
    return [self fileExistAtPathWithFileName:fileName folderName:CacheFolderNameAttach];
}
- (BOOL)fileExistAtLogFolderWithFileName:(NSString *)fileName
{
    return [self fileExistAtPathWithFileName:fileName folderName:FolderNameLog];
}
- (BOOL)fileExistAtImageFolderWithFileName:(NSString *)fileName
{
    return [self fileExistAtPathWithFileName:fileName folderName:CacheFolderNameImage];
}

- (void)imageExistAtPath:(NSURL *)url completion:(void(^)(BOOL isInCache))completion
{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    [[SDImageCachesManager sharedManager] queryImageForKey:key options:SDWebImageFromCacheOnly context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        BOOL isInCache = NO;
        if (!image) {
            isInCache = [self fileExistAtImageFolderWithFileName:url.lastPathComponent];
        }else{
            isInCache = YES;
        }
        if (!isInCache) {
            NSURLRequest * req = [NSURLRequest requestWithURL:url];
            UIImage * image = [[UIButton sharedImageCache]cachedImageForRequest:req];
            isInCache = image!= nil;
        }
        if (completion) {
            completion(isInCache);
        }
    }];
}

- (void)getExistLocalImageByPath:(NSURL *)url completion:(void(^)(UIImage * image))completion
{
    [self imageExistAtPath:url completion:^(BOOL isInCache) {
        if (isInCache) {
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
            [[SDImageCachesManager sharedManager] queryImageForKey:key options:SDWebImageFromCacheOnly context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
               
                if (!image) {
                    NSURL * imageUrl = [self imageFileUrlWithFileName:url.lastPathComponent];
                    if (imageUrl) {
                        NSData * data = [NSData dataWithContentsOfURL:imageUrl];
                        if (data) {
                            image = [UIImage imageWithData:data];
                        }
                    }
                }
                if (!image) {
                    NSURLRequest * req = [NSURLRequest requestWithURL:url];
                    image = [[UIButton sharedImageCache] cachedImageForRequest:req];
                }
                if (completion) {
                    completion(image);
                }
            }];
        }
    }];
}

- (void)getExistLocalImageDataByPath:(NSURL *)path quality:(CGFloat)compressionQuality completion:(void(^)(NSData * data))completion
{
    [self getExistLocalImageByPath:path completion:^(UIImage *image) {
        
        if (completion) {
            NSData * data = UIImageJPEGRepresentation(image, compressionQuality);
            completion(data);
        }
        
    }];
}

- (NSData *)getExistLocalVoiceDataByPath:(NSURL *)url
{
    BOOL isExit = [self fileExistAtVoiceFolderWithFileName:url.lastPathComponent];
    if (isExit) {
        NSURL * fileUrl = [self voiceFileUrlWithFileName:url.lastPathComponent];
        NSData * data = [NSData dataWithContentsOfURL:fileUrl];
        return data;
    }
    return nil;
}

- (NSData *)getExistLocalFileWithFolderName:(NSString *)folderName fileName:(NSString *)fileName
{
    BOOL isExit = [self fileExistAtPathWithFileName:fileName folderName:folderName];
    if (isExit) {
        NSURL * fileUrl = [self fileUrlWithFileName:fileName folderName:folderName];
        NSData * data = [NSData dataWithContentsOfURL:fileUrl];
        return data;
    }
    return nil;
}
- (NSData *)getExistLocalAttachDataByPath:(NSURL *)url
{
    BOOL isExit = [self fileExistAtAttachFolderWithFileName:url.lastPathComponent];
    if (isExit) {
        NSURL * fileUrl = [self attachFileUrlWithFileName:url.lastPathComponent];
        NSData * data = [NSData dataWithContentsOfURL:fileUrl];
        return data;
    }
    return nil;
}
- (NSData *)getExistLocalLogFileDataByPath:(NSURL *)url
{
    BOOL isExit = [self fileExistAtLogFolderWithFileName:url.lastPathComponent];
    if (isExit) {
        NSURL * fileUrl = [self logFileUrlWithFileName:url.lastPathComponent];
        NSData * data = [NSData dataWithContentsOfURL:fileUrl];
        return data;
    }
    return nil;
}

- (long long)getSizeWithFolder:(NSString *)folderName
{
    NSString * fileCachePath = [self cachePathWithFolder:folderName];
    
//    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
//    self.fileCachePath = fileCachePath;
    NSFileManager * fileManger = [NSFileManager defaultManager];
    //通过缓存文件路径创建文件遍历器
    NSDirectoryEnumerator * fileEnumrator = [fileManger enumeratorAtPath:fileCachePath];
    
    //先定义一个缓存目录总大小的变量
    NSInteger fileTotalSize = 0;
    
    for (NSString * fileName in fileEnumrator)
    {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
        
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //获取单个文件大小,并累加到总大小
        fileTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    
    //将字节大小转为MB，然后传出去
    return fileTotalSize;
}

- (long long)getSize
{
    long long totalSize = 0;
    long long SDImageCachedSize = [[SDImageCache sharedImageCache] totalDiskSize];
    NSLog(@"SDImageCachedSize : %lld",SDImageCachedSize);
    totalSize += SDImageCachedSize;
    
    long long tempCachedSize = [self getSizeWithFolder:CacheFolderNameTemp];
    NSLog(@"CacheFolderNameTemp : %lld",tempCachedSize);
    totalSize += tempCachedSize;
    
    long long imageCachedSize = [self getSizeWithFolder:CacheFolderNameImage];
    NSLog(@"CacheFolderNameImage : %lu",(unsigned long)imageCachedSize);
    totalSize += imageCachedSize;
    
    long long attachCachedSize = [self getSizeWithFolder:CacheFolderNameAttach];
    NSLog(@"CacheFolderNameAttach : %lu",(unsigned long)attachCachedSize);
    totalSize += attachCachedSize;
    
    long long recordCachedSize = [self getSizeWithFolder:CacheFolderNameRecord];
    NSLog(@"CacheFolderNameRecord : %lu",(unsigned long)recordCachedSize);
    totalSize += recordCachedSize;
    
    long long voiceCachedSize = [self getSizeWithFolder:CacheFolderNameVoice];
    NSLog(@"CacheFolderNameVoice : %lu",(unsigned long)voiceCachedSize);
    totalSize += voiceCachedSize;
    
    return totalSize;
}

- (NSString *)appendLogWithString:(NSString *)logString
{
    NSString * path = [[HPFileManager shareManager] cachePathWithFolder:FolderNameLog];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",FileNameLog]];
    NSData * data = [[HPFileManager shareManager] getExistLocalLogFileDataByPath:[NSURL URLWithString:path]];
    NSString * originLosString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString * result = [originLosString stringByAppendingString:[NSString stringWithFormat:@"\n%@",logString]];
    path = [[HPFileManager shareManager] writeToFileWithData:[result dataUsingEncoding:NSUTF8StringEncoding] folderName:FolderNameLog fileName:FileNameLog pathExtension:@"txt"];
    return path;
}

-(NSString *)getLogString
{
    NSString * path = [[HPFileManager shareManager] cachePathWithFolder:FolderNameLog];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",FileNameLog]];
    NSData * data = [[HPFileManager shareManager] getExistLocalLogFileDataByPath:[NSURL URLWithString:path]];
    NSString * originLosString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return originLosString;
}

- (void)cleanLog
{
    NSString * path = [[HPFileManager shareManager] cachePathWithFolder:FolderNameLog];
    [[HPFileManager shareManager] removeFolderWithPath:path];
}

-(void)archiverdData:(HPEntity *)entity folderName:(NSString *)folderName fileName:(NSString *)fileName
{

//    dispatch_queue_t writeQueue = dispatch_queue_create("com.RKBaseLibs.writeQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(writeQueue, ^{
            if (!entity || ![entity isKindOfClass:[HPEntity class]]) {
                return;
            }
            NSURL * url = [[HPFileManager shareManager] fileUrlWithFileName:fileName folderName:folderName];
    
//    if (@available(iOS 11.0, *)) {
//        NSError * error;
//        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:entity requiringSecureCoding:YES error:&error];
//        if (error) {
//            NSLog(@"%@",error.localizedDescription);
//        }else{
//            if (data) {
//                [data writeToFile:url.path atomically:YES];
//            }
//        }
//    } else {
        BOOL success = [NSKeyedArchiver archiveRootObject:entity toFile:url.path];
//    }
#ifdef DEBUG
            long long size = [[HPFileManager shareManager] getSizeWithFolder:CacheFolderNameTemp];
    NSLog(@"success:%d 缓存到本地：%@/%@\n: %@目录总大小：%fMB",success,folderName,fileName,folderName,size/1024.0/1024.0);
#endif
//        });
}

-(void)unarchiverDataWithFolderName:(NSString *)folderName fileName:(NSString *)fileName success:(HPSuccess)success
{
//    dispatch_queue_t readQueue = dispatch_queue_create("com.RKBaseLibs.readQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(readQueue, ^{
        NSURL * url = [[HPFileManager shareManager] fileUrlWithFileName:fileName folderName:folderName];
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:url.path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"获取缓存：%@\n%@",url.path,object);
                success(object);
            }
        });
//    });
}

- (NSString *)gameCachedFileNameWithGame:(NSString *)game typeId:(NSString *)typeId
{
   return [self gameCachedFileNameWithGame:game typeId:typeId isOffice:NO];
}

- (NSString *)gameCachedFileNameWithGame:(NSString *)game typeId:(NSString *)typeId isOffice:(BOOL)isOffice
{
    if (!isOffice) {
        return [NSString stringWithFormat:@"game%@typeid%@",game,typeId];
    }else{
        return [NSString stringWithFormat:@"game%@typeid%@isoffice1",game,typeId];
    }
}
@end
