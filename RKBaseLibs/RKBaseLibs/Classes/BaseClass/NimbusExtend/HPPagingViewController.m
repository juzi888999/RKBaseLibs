//
//  HPPagingViewController.m
//  RKBaseLibs
//
//  Created by mac on 15/9/12.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPPagingViewController.h"
#import <UIImage+FlatUI.h>
#import <NIPagingScrollView+Subclassing.h>
#import "HPPageView.h"

@interface HPPagingViewController () <NIPagingScrollViewDataSource, NIPagingScrollViewDelegate>

@property (strong, nonatomic) NIPagingScrollView *pagingScrollView;

@end

@implementation HPPagingViewController

@synthesize viewControllers = _viewControllers;

#pragma mark - LifeCycle

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setExtendLayoutMode:UIRectEdgeNone];
    self.pagingScrollView = [[NIPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.pagingScrollView];
    [self setScrollEnable:NO];
    self.pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pagingScrollView.dataSource = self;
    self.pagingScrollView.delegate = self;
    [self.pagingScrollView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [self.viewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    }
}

#pragma mark - Accessory

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (void)setViewControllers:(NSMutableArray *)viewControllers {
    if (_viewControllers.count > 0) {
        for (UIViewController *vc in _viewControllers) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
    _viewControllers = viewControllers;
//    if (_viewControllers.count > 0) {
        [self.pagingScrollView reloadData];
//    }
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
    return self.viewControllers.count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
    HPPageView *page = (HPPageView*)[pagingScrollView dequeueReusablePageWithIdentifier:@"PAGE"];
    if (page == nil)
        page = [[HPPageView alloc] initWithFrame:CGRectZero];
    NSArray *childs = self.childViewControllers;
    UIViewController *vc = self.viewControllers[pageIndex];
    if ([childs indexOfObject:vc] == NSNotFound) {
        [self addChildViewController:vc];
    }
    [vc didMoveToParentViewController:self];
    page.contentView = vc.view;
    page.pageIndex = pageIndex;
    return page;
}

#pragma mark - public

-(void)setScrollEnable:(BOOL)scrollEnable
{
    self.pagingScrollView.scrollView.scrollEnabled = scrollEnable;
    self.pagingScrollView.scrollView.pagingEnabled = scrollEnable;
    _scrollEnable = scrollEnable;
}

- (void)setDirectionLockEnable:(BOOL)directionLockEnable
{
    self.pagingScrollView.scrollView.directionalLockEnabled = directionLockEnable;
    _directionLockEnable = directionLockEnable;
}

- (void)setScrollViewBackgroundColor:(UIColor *)backgroundColor
{
    self.pagingScrollView.backgroundColor = backgroundColor;
    self.pagingScrollView.scrollView.backgroundColor = backgroundColor;
}
@end
