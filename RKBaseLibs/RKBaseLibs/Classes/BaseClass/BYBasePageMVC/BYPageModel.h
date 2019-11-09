//
//  BYPageModel.h
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYBasePageModel.h"
#import "HPRequest.h"

static int kHPPageStart = 1;
typedef void (^RKLoadingDataCallback)(NSArray *, NSError *);

typedef NS_ENUM(NSUInteger, HPTableModelHttpMethod) {
    HPTableModelHttpMethodGet,
    HPTableModelHttpMethodPost,
};

typedef enum : NSUInteger {
    BYPageTypeTableView,
    BYPageTypeCollectionView,
} BYPageType;

@class BYPageModel;
@protocol BYPageProtocol <NSObject>

@property (strong,nonatomic) BYPageModel * model;
@property (assign,nonatomic) BYPageType pageViewtype;

- (Class)modelClass;

@optional
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) UICollectionView * collectionView;

- (void)didBeginLoadData;
- (void)didFinishLoadData;
- (void)didFailLoadData;

@end

@interface BYPageModel : BYBasePageModel

@property (strong,nonatomic) NSMutableArray * listData;
@property (strong,nonatomic) NSPredicate * predicate;
@property (weak,nonatomic) id<BYPageProtocol> viewController;
@property (weak,nonatomic) UITableView * tableView;
@property (weak,nonatomic) UICollectionView * collectionView;

@property (strong,nonatomic) HPPageRequest * request;
@property (assign,nonatomic) HPTableModelHttpMethod httpMethod;
@property (nonatomic, strong) AFHTTPRequestOperation *op;
@property (strong,nonatomic) HPResponseEntity * responseEntity;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) NSInteger pageCounter;
@property (nonatomic, assign) NSInteger rowsPerPage;
@property (nonatomic, assign) BOOL disablePage;
@property (assign,nonatomic) NSInteger total;
@property (assign,nonatomic) NSInteger totalPages;
@property (nonatomic, strong) id other;
@property (nonatomic, strong) NSString * otherKey;

@property (copy,nonatomic) void(^dealExtensionDataBlock)(HPResponseEntity * response);

- (void)cancelRequstOperation;


+(instancetype)modelWithViewController:(id<BYPageProtocol>)viewController;
-(instancetype)initWithViewController:(id<BYPageProtocol>)viewController;

/*
 @param refresh  是否刷新缓存
 */
- (void)loadDataWithBlock:(void (^)(NSArray *, NSError *))block more:(BOOL)more refresh:(BOOL)refresh;

/*
 @param refresh  是否刷新缓存
 */
- (void)handleServiceResponse:(id)response more:(BOOL)more refresh:(BOOL)refresh complete:(void (^)(NSArray *, NSError *))block;

- (NSArray *)filteEntitiesWithEntities:(NSArray *)listDataArray;
- (NSArray *)entitiesParsedFromResponseObject:(id)responseObject;

#pragma mark - protected
- (void)performLazyLoading:(BOOL)more block:(void (^)(NSArray *, NSError *))block;
- (void)loadLocalDataWithblock:(RKLoadingDataCallback)block;

@end

@interface BYPageModel(LocalCached)

@property (assign,nonatomic) BOOL useLocalcached;//使用本地缓存
@property (copy,nonatomic) NSString * localCachedPath;
- (void)archiverdResponseData:(NSData *)responseData;
- (void)unarchiverResponseDataWithSuccess:(HPSuccess)success;


@property (assign,nonatomic) BOOL useLocalData; //使用本地数据，并且需要传入列表数组
-(void)useLocalDataWithlistData:(NSMutableArray *)listData;

@end
