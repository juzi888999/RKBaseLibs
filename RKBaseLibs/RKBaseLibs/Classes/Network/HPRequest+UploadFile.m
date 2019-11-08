//
//  HPRequest+UploadFile.m
//  RKBaseLibs
//
//  Created by rk on 16/6/7.
//  Copyright © 2016年 haixiaedu. All rights reserved.


#import "HPRequest+UploadFile.h"
#import "NSString+Json.h"
#import "HPFileManager.h"

@implementation HPUploadFileRequest
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"localUrl":NSNull.null,
             @"block":NSNull.null,
             };
}
@end
@implementation HPUploadFileEntity

- (BOOL)uploaded {
    
    if ([NSString checkString:self.url].length > 0) {
        BOOL isFileURL = [[HPFileManager shareManager] isLocalCacheFilePath:self.url];
        return !isFileURL;
    }
    return NO;
}

+ (NSString *)jsonArrayWithObjectArray:(NSArray <HPUploadFileEntity *>*)jsonArray
{
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:jsonArray.count];
    for (HPUploadFileEntity * uploadEntity in jsonArray) {
        NSDictionary * dic = [uploadEntity dictionaryValue];
        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([NSObject checkOject:obj]) {
                [mutableDic setValue:obj forKey:key];
            }
        }];
        [temp addObject:mutableDic];
    }
    NSString * resultJsonString = [NSString dataToJsonString:temp];
    return resultJsonString;
}

@end

@implementation NetworkClient (UploadFile)

- (AFHTTPRequestOperation *)uploadFileWithFileType:(HPUploadFileType)fileType uploadType:(HPUpLoadType)uploadType filePath:(NSString *)filePath
{
    if (filePath) {
        HPUploadFileRequest * uploadReq = [HPUploadFileRequest new];
        uploadReq.uploadType = uploadType;
        uploadReq.fileType = fileType;
        uploadReq.localUrl = [NSURL URLWithString:filePath];
        return [[NetworkClient sharedInstance] uploadFileWithRequest:uploadReq path:nil progress:nil success:^(HPResponseEntity * responseObject) {
            
            if ([NetworkClient isSuccessResponse: responseObject]) {
            }
            
        } failure:^(NSError *error) {
            [UIGlobal showMessage:error.localizedDescription];
        }];
    }
    return nil;
}

//@"api/v1/storage/image/uploadQiniu"
- (AFHTTPRequestOperation *)uploadFileWithRequest:(HPUploadFileRequest *)request
                                             path:(NSString *)path
                                         progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure
{
    __weak typeof(request) weakReq = request;
    [request setBlock:^(id<AFMultipartFormData> formData) {
        switch (weakReq.fileType) {
            case HPUploadFileTypeImage:
            {
                [[HPFileManager shareManager] imageExistAtPath:weakReq.localUrl completion:^(BOOL isInCache) {
                    if (isInCache) {
                        [[HPFileManager shareManager] getExistLocalImageDataByPath:weakReq.localUrl quality:1 completion:^(NSData *data) {
                            if (data) {
                                NSString * fileName = weakReq.localUrl.lastPathComponent;
                                [formData appendPartWithFileData:data name:weakReq.paramName?weakReq.paramName:@"file" fileName:fileName mimeType:@"image/jpeg"];
                            }
                        }];
                    };
                }];
            }
                break;
            case HPUploadFileTypeSound:
            {
                if ([[HPFileManager shareManager]fileExistAtVoiceFolderWithFileName:weakReq.localUrl.lastPathComponent]) {
                    NSData *data = [[HPFileManager shareManager] getExistLocalVoiceDataByPath:weakReq.localUrl];
                    if (data) {
                        [formData appendPartWithFileData:data name:weakReq.paramName?weakReq.paramName:@"file" fileName:@"voice.aac" mimeType:@"audio/mpeg3"];
                    }
                };
            }
                break;
            case HPUploadFileTypeAttach:
            {
                if ([[HPFileManager shareManager]fileExistAtAttachFolderWithFileName:weakReq.localUrl.lastPathComponent]) {
                    NSData *data = [[HPFileManager shareManager] getExistLocalAttachDataByPath:weakReq.localUrl];
                    if (data) {
                        [formData appendPartWithFileData:data name:weakReq.paramName?weakReq.paramName:@"file" fileName:weakReq.localUrl.lastPathComponent mimeType:@"application/octet-stream"];
                    }
                };
            }
                break;
            default:
                break;
        }
    }];
    AFHTTPRequestOperation * op = [self postWithPath:path bodyRequest:request success:success failure:failure];
    
    [op setUploadProgressBlock:uploadProgress];
    return op;
}

@end
