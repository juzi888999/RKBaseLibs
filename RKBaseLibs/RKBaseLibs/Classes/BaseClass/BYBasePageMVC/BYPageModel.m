//
//  BYPageModel.m
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYPageModel.h"

typedef void (^LoadingDataCallback)(NSArray *, NSError *);

@implementation BYPageModel

- (void)commentInit
{
    self.pageCounter = 1;
    self.rowsPerPage = 10;
    self.hasMoreData = YES;
    self.httpMethod = HPTableModelHttpMethodGet;
    self.disablePage = NO;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self commentInit];
    }
    return self;
}

-(instancetype)initWithViewController:(id<BYPageProtocol>)viewController
{
    if (self = [super init]) {
        self.viewController = viewController;
        viewController.model = self;
        [self commentInit];
    }
    return self;
}

+(instancetype)modelWithViewController:(id<BYPageProtocol>)viewController
{
    BYPageModel * model = [[BYPageModel alloc]initWithViewController:viewController];
    return model;
}

- (void)cancelRequstOperation
{
    if (self.isLoading)
    {
        if (![self.op isFinished] && ![self.op isCancelled])
            [self.op cancel];
        self.op = nil;
        self.isLoading = NO;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)loadDataWithBlock:(void (^)(NSArray *, NSError *))block more:(BOOL)more refresh:(BOOL)refresh
{
    if (self.useLocalData) {
        [self loadLocalDataWithblock:block];
        return;
    }
    // test
#ifdef DEBUG
    if (![self relativePath])
    {
        [self performLazyLoading:more block:block];
        return;
    }
#endif
    // test end
    if (self.useLocalcached && self.localCachedPath.length > 0) {
        @weakify(self);
        [self unarchiverResponseDataWithSuccess:^(id responseObject) {
            @strongify(self);
            if (self) {
                if (responseObject) {
                    [self handleServiceResponse:responseObject more:NO refresh:NO complete:block];
                }else{
                    [self loadServiceDataWithBlock:block more:more refresh:refresh];
                }
            }
        }];
    }else{
        [self loadServiceDataWithBlock:block more:more refresh:refresh];
    }
}

- (void)loadServiceDataWithBlock:(void (^)(NSArray *, NSError *))block more:(BOOL)more refresh:(BOOL)refresh
{
    NSDictionary *extractedExpr = [self generateParameters];
    NSDictionary *dic = extractedExpr;
    //    if (dic == nil)
    //    {
    //        self.isLoading = NO;
    //        if (block)
    //            block(nil, nil);
    //        return;
    //    }
    if (self.isLoading)
        return;
    else
        self.isLoading = YES;
    
    if (more) {
        self.pageCounter++;
    }else {
        self.pageCounter = kHPPageStart;
    }
    self.hasMoreData = NO;
    self.rowsPerPage = [self.request.pageSize intValue];
    NSString *pageIndexKey = self.pageIndexKey;
    NSString *pageSizeKey = self.pageSizeKey;
    NSMutableDictionary * mutableDic = dic.mutableCopy;
    if (!self.disablePage){
        [mutableDic setValue:@(self.pageCounter) forKey:pageIndexKey];
        [mutableDic setValue:@(self.rowsPerPage) forKey:pageSizeKey];
    }
    NSMutableDictionary *params = mutableDic;
    
    @weakify(self);
    if (self.httpMethod == HPTableModelHttpMethodGet) {
        self.op = [[NetworkClient sharedInstance] getWithPath:[self relativePath] params:params success:^(id responseObject) {
            @strongify(self);
            if (self) {
                self.isLoading = NO;
                if (self.useLocalcached) {
                    NSLog(@"请求服务器，非缓存:%@\n",self.relativePath);
                }
                [self handleServiceResponse:responseObject more:more refresh:refresh complete:block];
            }
        } failure:^(NSError *error) {
            @strongify(self);
            if (self) {
                self.isLoading = NO;
                if (block)
                    block(nil, error);
            }
        }];
    }else if (self.httpMethod == HPTableModelHttpMethodPost){
        self.op = [[NetworkClient sharedInstance] rawPostWithPath:[self relativePath] params:params success:^(id responseObject) {
            @strongify(self);
            if (self) {
                self.isLoading = NO;
                NSLog(@"请求服务器，非缓存:%@\n",self.relativePath);
                [self handleServiceResponse:responseObject more:more refresh:refresh complete:block];
            }
        } failure:^(NSError *error) {
            @strongify(self);
            if (self) {
                self.isLoading = NO;
                if (block)
                    block(nil, error);
            }
            
        }];
    }
}

- (void)handleServiceResponse:(id)response more:(BOOL)more refresh:(BOOL)refresh complete:(void (^)(NSArray *, NSError *))block
{
    HPResponseEntity *rsp = response;
    self.responseEntity = rsp;
    if (self.useLocalcached && refresh) {
        [self archiverdResponseData:self.op.responseData];
    }
    NSInteger curPage = self.pageCounter;// base 1
    NSInteger totalPage = 0;
    if ([rsp.result isKindOfClass:[NSDictionary class]]) {
        totalPage = [rsp.result[self.totalPageKey] integerValue];
        self.other = rsp.result[[self otherKey]];
        self.totalPages = totalPage;
        self.total = [rsp.result[self.totalKey] integerValue];
        if (self.total == 0) {
            self.total = [rsp.result[@"totalSize"] integerValue];
        }
    }
    if (self.dealExtensionDataBlock) {
        self.dealExtensionDataBlock(response);
    }
    NSArray *array = [self entitiesParsedFromResponseObject:rsp.result];
    array = [self filteEntitiesWithEntities:array];
    if (!more) {
        self.listData = [array mutableCopy];
    }else {
        if (!self.listData) {
            self.listData = [NSMutableArray array];
        }
        [self.listData addObjectsFromArray:array];
    }
    
    NSArray *indexPaths = nil;
    if (array.count > 0)
        indexPaths = self.listData;
    else
        indexPaths = [NSArray array];
    if (self.total == 0) {
        //避免接口没有返回total字段
        self.hasMoreData = indexPaths.count > 0;
    }else{
        self.hasMoreData = indexPaths.count < self.total;
    }
    if (self.hasMoreData && indexPaths.count == 0) {
        //有时有服务端返回的totalSize 计算不对，如果是空页面默认 hasMoreData = NO；
        self.hasMoreData = NO;
    }
//    if (self.disablePage || array.count < self.rowsPerPage) {
//        self.hasMoreData = NO;
//    } else {
//        if (totalPage <= 0) {
//            self.hasMoreData = YES;
//        } else {
//            self.hasMoreData = curPage < totalPage;
//        }
//    }
    if (block)
    {
        block(indexPaths, nil);
    }
}

- (void)performLazyLoading:(BOOL)more block:(void (^)(NSArray *, NSError *))block
{
    [self performSelector:@selector(lazyLoading:) withObject:@{@"more":@(more), @"block":block} afterDelay:0.5f];
}

- (void)lazyLoading:(NSDictionary*)dic
{
    self.isLoading = NO;
    BOOL more = [dic[@"more"] boolValue];
    LoadingDataCallback block = dic[@"block"];
    //    NSArray *array = [self entitiesParsedFromResponseObject:nil];
    //    array = [self entitiesParsedFromListData:array];
    NSMutableArray *array = [NSMutableArray array];
    if ([self objectClass])
    {
        for (int i = 0; i < self.rowsPerPage; i++)
        {
            [array addObject:[[[self objectClass] alloc] initRandom]];
        }
    }
    if (!more) {
        self.listData = array;
    }
    else {
        [self.listData addObjectsFromArray:array];
    }
    self.hasMoreData = YES;
    NSArray * indexPaths = self.listData;
    self.isLoading = NO;
    if (block)
    {
        block(indexPaths, nil);
    }
}

- (void)loadLocalDataWithblock:(LoadingDataCallback)block
{
    self.isLoading = NO;
    //    NSArray *array = [self entitiesParsedFromResponseObject:nil];
    //    array = [self entitiesParsedFromListData:array];
    self.hasMoreData = NO;
    self.isLoading = NO;
    if (block)
    {
        block(self.listData, nil);
    }
}


- (NSArray *)entitiesParsedFromResponseObject:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSArray class]])
    {
        return [MTLJSONAdapter modelsOfClass:[self objectClass] fromJSONArray:responseObject error:nil];
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSArray *array = [responseObject valueForKey:[self listKey]];
        if ([array isKindOfClass:[NSArray class]])
            return [MTLJSONAdapter modelsOfClass:[self objectClass] fromJSONArray:array error:nil];
    }
    return nil;
}

- (NSArray *)entitiesParsedFromListData:(NSArray *)listDataArray
{
    return listDataArray;
}

- (NSArray *)filteEntitiesWithEntities:(NSArray *)listDataArray
{
    NSArray *array = listDataArray;
    //    if (self.predicate)
    //        array = [listDataArray filteredArrayUsingPredicate:self.predicate];
    return array;
}

- (NSArray*)filteEntitiesWithPredicate:(NSPredicate *)p
{
    if (p == nil)
        return self.listData;
    return [self.listData filteredArrayUsingPredicate:p];
}

-(NSDictionary *)generateParameters
{
    return [self.request parametersWithoutNull];
}

-(NSMutableArray *)listData
{
    if (self.predicate && _listData && _listData.count > 0) {
        [_listData filterUsingPredicate:self.predicate];
    }
    return _listData;
}

@end

static NSString * XBModelUseLocalDataKey = @"XBModelUseLocalDataKey";
static NSString * XBModelUseLocalcachedKey = @"XBModelUseLocalcachedKey";
static NSString * XBModelLocalCachedPathKey = @"XBModelLocalCachedPathKey";

@implementation BYPageModel(LocalCached)
@dynamic useLocalData,useLocalcached , localCachedPath;


- (BOOL)useLocalData
{
    return [objc_getAssociatedObject(self, &XBModelUseLocalDataKey) boolValue];
}

- (void)setUseLocalData:(BOOL)useLocalData
{
    return objc_setAssociatedObject(self, &XBModelUseLocalDataKey, @(useLocalData), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)useLocalcached
{
    return [objc_getAssociatedObject(self, &XBModelUseLocalcachedKey) boolValue];
}

- (void)setUseLocalcached:(BOOL)useLocalcached
{
    return objc_setAssociatedObject(self, &XBModelUseLocalcachedKey, @(useLocalcached), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)localCachedPath
{
    return objc_getAssociatedObject(self, &XBModelLocalCachedPathKey);
}

-(void)setLocalCachedPath:(NSString *)localCachedPath
{
    return objc_setAssociatedObject(self, &XBModelLocalCachedPathKey, localCachedPath, OBJC_ASSOCIATION_COPY);
}

- (void)archiverdResponseData:(NSData *)responseData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (self.useLocalcached && self.localCachedPath.length > 0 && responseData) {
            //        [[HPFileManager shareManager] archiverdData:responseObject folderName:CacheFolderNameTemp fileName:self.localCachedPath];
            NSString * url = [[HPFileManager shareManager] writeToFileWithData:responseData folderName:CacheFolderNameTemp fileName:self.localCachedPath pathExtension:@""];
            NSLog(@"缓存到本地 %@",url);
        }
    });
}

- (void)unarchiverResponseDataWithSuccess:(HPSuccess)success
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.useLocalcached && self.localCachedPath.length > 0) {
            //        [[HPFileManager shareManager] unarchiverDataWithFolderName:CacheFolderNameTemp fileName:self.localCachedPath success:success];
            NSURL * url = [[HPFileManager shareManager] fileUrlWithFileName:self.localCachedPath folderName:CacheFolderNameTemp];
            NSData * data = [NSData dataWithContentsOfFile:url.path];
            if (!data){
                success(nil);
                return;
            }
            HPResponseEntity * responseEntity = nil;
            NSError * error;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error){
                NSLog(@"%@",error);
            }else{
                if(dic){
                    NSError * error;
                    responseEntity = [MTLJSONAdapter modelOfClass:[HPResponseEntity class] fromJSONDictionary:dic error:&error];
                    if(error){
                        NSLog(@"%@",error);
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(success){
                    NSLog(@"获取缓存：%@\n",self.localCachedPath);
#ifdef DEBUG
                    if (XBVersionTestCached) {
                        if (responseEntity) {
                            [UIGlobal showAlertWithTitle:[NSString stringWithFormat:@"获取缓存：%@",self.localCachedPath] message:nil customizationBlock:NULL completionBlock:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                                
                            } cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        }
                    }
#endif
                    success(responseEntity);
                }
            });
        }

    });

}


-(void)useLocalDataWithlistData:(NSMutableArray *)listData
{
    self.useLocalData = YES;
    self.listData = listData.mutableCopy;
}


@end
