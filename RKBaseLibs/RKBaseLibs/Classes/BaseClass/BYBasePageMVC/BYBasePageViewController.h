//
//  BYBasePageViewController.h
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BaseViewController.h"
#import "BYPageModel.h"
#import <MJRefresh.h>

@interface BYBasePageViewController : BaseViewController<BYPageProtocol>

@property (assign,nonatomic) BOOL loadDataWhenViewDidAppear;//是否是第一次加载数据
@property (strong,nonatomic) MJRefreshNormalHeader  *refreshHeader;
@property (strong,nonatomic) MJRefreshAutoStateFooter * refreshFooter;

//emptyView and requestFailureView
@property (strong,nonatomic) UIView * defaultEmptyView;
@property (strong,nonatomic) UIView * customEmptyView;
@property (strong,nonatomic) UIView * customRequestFailureView;
@property (assign,nonatomic) BOOL shouldShowEmptyView;
@property (assign,nonatomic) BOOL shouldShowRequestFailureView;

- (NSString *)customEmptyViewTip;
@property (copy,nonatomic) NSString *(^customEmptyViewTipBlock)(void);
- (UIColor *)customEmptyViewTipTextColor;
- (NSString *)customEmptyViewIcon;
@property (copy,nonatomic) NSString *(^customEmptyViewIconBlock)(void);

- (void)addCustomEmptyView;
- (CGRect)emptyViewFrame;
- (void)showEmptyViewIfNeed;
@property (copy,nonatomic) CGRect(^emptyViewFrameBlock)(void);

@property (copy,nonatomic) void(^didFinishLoadDataBlock)(void);
@property (copy,nonatomic) void(^didFailLoadDataBlock)(void);

@property (copy,nonatomic) void(^willFirstLoadData)(void);
@property (copy,nonatomic) void(^willPullDownRefresh)(void);
@property (copy,nonatomic) void(^willLoadMoreData)(void);

#pragma mark - BYPageProtocol
@property (strong,nonatomic) BYPageModel * model;
@property (strong, nonatomic) UICollectionView *collectionView;//default is nil
@property (strong,nonatomic) UITableView * tableView;//default is nil
@property (assign,nonatomic) BYPageType pageViewtype;//default is BYPageTypeTableView

- (Class)modelClass;

- (void)didBeginLoadData;
- (void)didFinishLoadData;
- (void)didFailLoadData;

#pragma mark -

/*
 调用 setupMJRefreshHeader and setupMJRefreshFooter 方法前 self.tableView 或者 self.collectionView 不能为空
 一般在viewDidLoad 创建完self.tableView 或者 self.collectionView之后调用
 */
- (void)setupMJRefreshHeader;
- (void)setupMJRefreshFooter;

////加载数据并显示hud
//- (void)firstLoadDataWithHUD;

//重新加载数据
- (void)reloadFisrtPageDataWithHUD;

//下啦刷新加载数据
- (void)pullDownRefresh;

//加载更多数据
- (void)loadMoreData;

////当customEmptyView 为空的时候默认显示 defaultEmptyView ，此方法可以修改 defaultEmptyView 的显示文字
//- (void)setEmptyViewText:(NSString*)text;

//刷新界面，[self.tableView reloadData] or [self.collectionView reloadData]
- (void)refreshView;

- (void)showEmptyView;
- (void)removeCurrentShowView;

@end
