//
//  BYBasePageViewController.m
//  RKBaseLibs 
//
//  Created by rk on 16/8/1.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYBasePageViewController.h"
#import "MJRefresh.h"

@interface BYBasePageViewController ()

@end

@implementation BYBasePageViewController

#pragma mark - subclass overwrite
- (Class)modelClass
{
    return nil;
}

#pragma mark - life cycle
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSAssert([self modelClass], @"modelClass is nil");
        self.model = [[[self modelClass] alloc]initWithViewController:self];
        self.pageViewtype = BYPageTypeTableView;
        self.shouldShowEmptyView = YES;
        self.shouldShowRequestFailureView = YES;
        self.loadDataWhenViewDidAppear = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutoAdjustScrollView:NO];
    //default emptyView
    [self addDefaultEmptyView];
    
    //customEmptyView
    [self addCustomEmptyView];
    
    //customReqeustFailureView
    [self addCustomRequestFailureView];
}

- (void)addDefaultEmptyView
{
    UIView * emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    UIImageView * icon = [[UIImageView alloc]initWithImage:HPImageForKey([self customEmptyViewIcon])];
    [emptyView addSubview:icon];
    emptyView.userInteractionEnabled = NO;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView);
    }];
    
    UILabel * tipLabel = [UILabel centerAlignLabel];
    tipLabel.font = HPFontWithSize(15);
    tipLabel.textColor = [self customEmptyViewTipTextColor];
    [emptyView addSubview:tipLabel];
    tipLabel.text = [self customEmptyViewTip];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(emptyView);
        make.centerY.mas_equalTo(emptyView.mas_centerY).multipliedBy(1.2);
        make.top.mas_equalTo(icon.mas_bottom).offset(30);
    }];
    self.defaultEmptyView = emptyView;
}


- (void)addCustomEmptyView
{
    self.customEmptyView = nil;
}

- (NSString *)customEmptyViewTip
{
    if (self.customEmptyViewTipBlock) {
        return self.customEmptyViewTipBlock();
    }
//    return @"暂无数据";
    return @"去其他页面逛逛吧～";
}
-(UIColor *)customEmptyViewTipTextColor
{
    return HPColorForKey(@"text.minor");
}
- (NSString *)customEmptyViewIcon
{
    if (self.customEmptyViewIconBlock) {
        return self.customEmptyViewIconBlock();
    }
    return @"empty_icon";
}

- (void)addCustomRequestFailureView
{
    UIView * customRequestFailureView = [self.view by_createDefaultRequestFailureView];
    self.customRequestFailureView = customRequestFailureView;
}

- (void)showEmptyView
{
    [self removeCurrentShowView];
    UIView * listView = nil;
    if (self.pageViewtype == BYPageTypeTableView) {
        listView = self.tableView;
    }else if (self.pageViewtype == BYPageTypeCollectionView){
        listView = self.collectionView;
    }
    if (listView) {
        if (self.customEmptyView) {
            listView.by_customEmptyView = self.customEmptyView;
        }else{
            listView.by_customEmptyView = self.defaultEmptyView;
        }
        
        [listView by_showEmptyViewInCenter:self.shouldShowEmptyView withFrame:[self emptyViewFrame]];
    }
}

- (void)showEmptyViewIfNeed
{
    if (self.model.listData.count == 0) {
        [self showEmptyView];
    }else{
        [self removeCurrentShowView];
    }
}

- (CGRect)emptyViewFrame
{
    if (self.emptyViewFrameBlock) {
        return self.emptyViewFrameBlock();
    }else{
        UIView * listView = nil;
        if (self.pageViewtype == BYPageTypeTableView) {
            listView = self.tableView;
        }else if (self.pageViewtype == BYPageTypeCollectionView){
            listView = self.collectionView;
        }
        if (listView) {
            return listView.bounds;
        }
    }
    return self.view.bounds;
}

- (void)showRequestFailureView
{
    [self removeCurrentShowView];
    UIView * listView = nil;
    if (self.pageViewtype == BYPageTypeTableView) {
        listView = self.tableView;
    }else if (self.pageViewtype == BYPageTypeCollectionView){
        listView = self.collectionView;
    }
    if (listView) {
        if (self.customRequestFailureView) {
            listView.by_customRequestFailureView = self.customRequestFailureView;
        }else{
            listView.by_customRequestFailureView = self.defaultEmptyView;
        }
        @weakify(self);
        [listView setBy_requestFailureTapBlock:^(){
            @strongify(self);
            if (self) {
                [self firstLoadDataWithHUD];
            }
        }];
        [listView by_showRequestFailureViewInCenter:self.shouldShowRequestFailureView withFrame:[self emptyViewFrame]];
    }
}

- (void)removeCurrentShowView
{
    if (self.customRequestFailureView && self.customRequestFailureView.superview) {
        [self.customRequestFailureView removeFromSuperview];
    }
    if (self.customEmptyView && self.customEmptyView.superview) {
        [self.customEmptyView removeFromSuperview];
    }
    if (self.defaultEmptyView && self.defaultEmptyView.superview) {
        [self.defaultEmptyView removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController)
    {
        [self.model cancelRequstOperation];
        self.model = nil;
        if (self.tableView) {
            self.tableView.delegate = nil;
            self.tableView.dataSource = nil;
            self.tableView = nil;
        }
        if (self.collectionView) {
            self.collectionView.delegate = nil;
            self.collectionView.dataSource = nil;
            self.collectionView = nil;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView) {
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
    }
    if (self.model&&self.model.request && [NSArray checkArray:self.model.listData].count == 0 && self.loadDataWhenViewDidAppear && !self.model.op.isFinished) {
        
        [self firstLoadDataWithHUD];
    }
}

- (void)removeFromParentViewController
{
    [super removeFromParentViewController];
    [self.model cancelRequstOperation];
    self.model = nil;
    if (self.tableView) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        self.tableView = nil;
    }
    if (self.collectionView) {
        self.collectionView.delegate = nil;
        self.collectionView.dataSource = nil;
        self.collectionView = nil;
    }
}

#pragma mark - public

//- (void)showEmptyViewIfNeed
//{
//    if (self.defaultEmptyView.superview) {
//        [self.defaultEmptyView removeFromSuperview];
//    }
//    if (self.pageViewtype == BYPageTypeTableView) {
//        if (self.tableView) {
//            [self.tableView addSubview:self.defaultEmptyView];
//            [self.defaultEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(self.tableView);
//            }];
//        }
//    }else if (self.pageViewtype == BYPageTypeCollectionView){
//
//        if (self.collectionView) {
//            [self.collectionView addSubview:self.defaultEmptyView];
//            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(self.collectionView);
//            }];
//
//        }
//    }
//
//}
- (void)setupMJRefreshHeader
{
    @weakify(self);
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self) {
            [self pullDownRefresh];
        }
    }];
    
    if (self.pageViewtype == BYPageTypeTableView) {
        if (self.tableView) {
            self.tableView.mj_header = self.refreshHeader;
        }
    }else if (self.pageViewtype == BYPageTypeCollectionView){
        
        if (self.collectionView) {
            // 上拉刷新
            self.collectionView.mj_header = self.refreshHeader;
        }
    }
}

- (void)setupMJRefreshFooter
{
    @weakify(self);
    self.refreshFooter = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self) {
            [self loadMoreData];
        }
    }];
//    self.refreshFooter.stateLabel.text = @"";
    if (self.pageViewtype == BYPageTypeTableView) {
        if (self.tableView) {
            self.tableView.mj_footer = self.refreshFooter;
        }
    }else if (self.pageViewtype == BYPageTypeCollectionView){
        
        if (self.collectionView) {
            // 上拉刷新
            self.collectionView.mj_footer = self.refreshFooter;
        }
    }
}

#pragma mark -
- (void)firstLoadDataWithHUD
{
    if (self.willFirstLoadData) {
        self.willFirstLoadData();
    }
    [UIGlobal hideHudForView:self.view animated:NO];
    [UIGlobal showLogoHUDForView:self.view];
    // 如果有mj_footer，就重新设置可用功能，重新进行加载
    if (self.refreshFooter) {
        self.refreshFooter.hidden = NO;
        [self.refreshFooter resetNoMoreData];
//        self.refreshFooter.stateLabel.text = @"";
    }
    [self didBeginLoadData];
    
    @weakify(self);
    [self.model loadDataWithBlock:^(NSArray *listData, NSError *error) {
        @strongify(self);
        if (self) {
            [UIGlobal hideHudForView:self.view animated:NO];
            if (error) {
                [self didFailLoadData];
                [UIGlobal showError:error inView:self.view];
            }else{
                [self didFinishLoadData];
            }
        }
    } more:NO refresh:YES];
}

- (void)reloadFisrtPageDataWithHUD
{
    if (!self.isViewLoaded) {
        return;
    }
    if (self.willFirstLoadData) {
        self.willFirstLoadData();
    }
    [UIGlobal hideHudForView:self.view animated:NO];
    [UIGlobal showLogoHUDForView:self.view];
    if (self.willPullDownRefresh) {
        self.willPullDownRefresh();
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }else if (self.collectionView){
        [self.collectionView reloadData];
    }
    
    [self.model cancelRequstOperation];
    
    if (self.refreshFooter) {
        self.refreshFooter.hidden = NO;
        [self.refreshFooter resetNoMoreData];
    }
    @weakify(self);
    [self didBeginLoadData];
    [self.model loadDataWithBlock:^(NSArray *listData, NSError *error) {
        @strongify(self);
        if (self) {
            [self endRefreshing];
            [UIGlobal hideHudForView:self.view animated:NO];
            if (error) {
                [self didFailLoadData];
                [UIGlobal showError:error inView:self.view];
            }else{
                [self didFinishLoadData];
            }
        }
    } more:NO refresh:YES];
}

- (void)pullDownRefresh
{
    if (self.willPullDownRefresh) {
        self.willPullDownRefresh();
    }
//    if (self.tableView) {
//        [self.tableView reloadData];
//    }else if (self.collectionView){
//        [self.collectionView reloadData];
//    }
    
    [self.model cancelRequstOperation];
    
    if (self.refreshFooter) {
        self.refreshFooter.hidden = NO;
        [self.refreshFooter resetNoMoreData];
    }
    @weakify(self);
    [self didBeginLoadData];
    [self.model loadDataWithBlock:^(NSArray *listData, NSError *error) {
        @strongify(self);
        if (self) {
            [self endRefreshing];
            if (error) {
                [self didFailLoadData];
                [UIGlobal showError:error inView:self.view];
            }else{
                [self didFinishLoadData];
            }
        }
    } more:NO refresh:YES];
}

- (void)loadMoreData
{
    if (self.willLoadMoreData) {
        self.willLoadMoreData();
    }
    @weakify(self);
    [self didBeginLoadData];
    [self.model loadDataWithBlock:^(NSArray *listData, NSError *error) {
        @strongify(self);
        if (self) {
            if (error) {
                [self didFailLoadData];
                [UIGlobal showError:error inView:self.view];
            }else{
                [self didFinishLoadData];
            }
        }
    } more:YES refresh:YES];
}

- (void)autoPullDownRefresh
{
    [self begingRefreshing];
    [self pullDownRefresh];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didBeginLoadData
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadData
{
    [self removeCurrentShowView];
    [self.refreshHeader endRefreshing];
    
    if (self.model.hasMoreData) {
        [self endLoadMoreRefresh];
    }else {
        if (self.refreshFooter) {
            if (self.model.listData.count > 0) {
                // 设置不可用的功能 加载完毕
                [self.refreshFooter endRefreshingWithNoMoreData];
                self.refreshFooter.hidden = NO;
            }else{
                self.refreshFooter.hidden = YES;
            }
        }
    }
    
    if (self.didFinishLoadDataBlock) {
        self.didFinishLoadDataBlock();
    }
    if (self.model.listData.count == 0) {
        [self showEmptyView];
    }
    [self refreshView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    [UIGlobal hideHudForView:self.view animated:YES];
//    if (!self.model.op.isCancelled) {
        [self removeCurrentShowView];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshingWithNoMoreData];
        [self.model.listData removeAllObjects];
    if (!self.model.op.isExecuting) {
        [self showRequestFailureView];
    }
        [self refreshView];
//    }
    if (self.didFailLoadDataBlock) {
        self.didFailLoadDataBlock();
    }
}

- (void)refreshView
{
    if (self.pageViewtype == BYPageTypeTableView) {
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }else if (self.pageViewtype == BYPageTypeCollectionView){
        
        if (self.collectionView) {
            [self.collectionView reloadData];
        }
    }
}

- (void)begingRefreshing
{
    [self.refreshHeader beginRefreshing];
}

- (void)endRefreshing
{
    [self refreshView];
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
}

- (void)endLoadMoreRefresh
{
    [self.refreshFooter endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
