//
//  HPRequest+UploadFile.h
//  RKBaseLibs
//
//  Created by rk on 16/6/7.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HPRequest.h"
/**
 * 上传状态
 */
typedef NS_ENUM(NSInteger, HPUploadState) {
    HPUploadStateProgress,
    HPUploadStateFinished,
    HPUploadStateFailed,
};
/**
 *  上传文件类型
 */
typedef NS_ENUM(NSUInteger, HPUploadFileType) {
    /**
     *  图片  mimeType: image/jpeg
     */
    HPUploadFileTypeImage = 1,
    /**
     *  语音  mimeType: audio/mpeg3
     */
    HPUploadFileTypeSound,
    /**
     *  附件  mimeType: application/octet-stream
     */
    HPUploadFileTypeAttach,
};

/**
 *  上传模块类型（用户区分上传路径）
 */
typedef NS_ENUM(NSInteger, HPUpLoadType) {
   
    HPUpLoadTypeNone = -1,
    //...

};

@interface HPUploadFileRequest : HPBodyRequest

@property (assign,nonatomic) HPUpLoadType uploadType;
@property (assign,nonatomic) HPUploadFileType fileType;
@property (strong,nonatomic) NSURL * localUrl;
@property (strong,nonatomic) NSString * paramName;
@end

@interface HPUploadFileEntity : HPEntity
@property (strong,nonatomic)NSString *size;// 573.11K,
@property (strong,nonatomic)NSString *id;// f1f425e7b43645e29f0b2696a120b463,
@property (strong,nonatomic)NSString *ext;// jpg,
@property (strong,nonatomic)NSString *name;// C35E8D45-05EF-4C04-A44B-E924072F749E-1489-00000F547F68CCD1.jpg,
@property (strong,nonatomic)NSString *url;// upload/homework/image/20160612/20160612144549-2506939.jpg
@property (assign,nonatomic,readonly)BOOL uploaded;

+ (NSString *)jsonArrayWithObjectArray:(NSArray <HPUploadFileEntity *>*)jsonArray;
@end

@interface NetworkClient (UploadFile)

- (AFHTTPRequestOperation *)uploadFileWithFileType:(HPUploadFileType)fileType uploadType:(HPUpLoadType)uploadType filePath:(NSString *)filePath;

- (AFHTTPRequestOperation *)uploadFileWithRequest:(HPUploadFileRequest *)request
                                             path:(NSString *)path
                                         progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgress
                                          success:(HPSuccess)success
                                          failure:(HPFailure)failure;

@end
