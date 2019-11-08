//
//  BYBaseNavSegmentViewController.m
//  RKBaseLibs 
//
//  Created by rk on 16/9/13.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYBaseNavSegmentViewController.h"
#import <UIImage+FlatUI.h>
#import <NIPagingScrollView.h>
#import "HPPageView.h"
#import "UISegmentedControl+Badge.h"

@interface BYNavSegmentItemView()
{
}
@end
@implementation BYNavSegmentItemView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title num:(NSInteger)num
{
    if (self = [super initWithFrame:frame]) {
        UIView * itemView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        UILabel * label = [UILabel centerAlignLabel];
        _titleLabel = label;
        label.textColor = WhiteColor;
        label.font = MainFontSize(16);
        label.text = title;
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(itemView);
        }];
        
        UILabel * unreadView = [UILabel centerAlignLabel];
        _unreadView = unreadView;
        unreadView.font = MainFontSize(10);
        unreadView.textColor = HPColorForKey(@"unread.bg");
        [itemView addSubview:unreadView];
        [unreadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.centerY.mas_equalTo(label.mas_top);
        }];
        [self setBadgeNum:num];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setBadgeNum:(NSInteger)num
{
    if (num > 0) {
        _unreadView.text = @"●";
    }else{
        _unreadView.text = @"";
    }
}

- (void)tapSelf:(UITapGestureRecognizer *)tap
{
    if (self.didTapBlock) {
        self.didTapBlock(tap);
    }
}
@end

@interface BYBaseNavSegmentViewController()
@end

@implementation BYBaseNavSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//viewControllers 添加完之后调用
- (void)createSegmentWithStyle:(BYBaseNavSegmentType)segmentType
{
    @weakify(self);
    self.segmentType = segmentType;
    if ([NSArray checkArray:self.viewControllers].count == 0) {
        return;
    }
    
    NSArray *names = [self.viewControllers valueForKey:@"title"];
    if (self.segmentType == BYBaseNavSegmentTypeTitle) {
        self.segment = [[HMSegmentedControl alloc]initWithSectionItems:names customViewBlock:^UIView *(NSString * title, NSInteger index) {
            @strongify(self);
            if (self) {
                BYNavSegmentItemView * itemView = [[BYNavSegmentItemView alloc]initWithFrame:CGRectZero title:title num:0];
                itemView.index = index;
                @weakify(self);
                [itemView setDidTapBlock:^(UITapGestureRecognizer * tap) {
                    @strongify(self);
                    if (self) {
                        if (self.shouldSelectItem) {
                            if (self.shouldSelectItem(title,index)) {
                                [self moveIndicatorToIndex:index];
                                [self.segment setSelectedSegmentIndex:index animated:YES];
                                [self.pagingScrollView moveToPageAtIndex:index animated:NO];
                            }
                        }else{
                            [self moveIndicatorToIndex:index];
                            [self.segment setSelectedSegmentIndex:index animated:YES];;
                            [self.pagingScrollView moveToPageAtIndex:index animated:NO];
                        }
                    }
                }];
                return itemView;
            }
            return [UIView new];
        }];
        UIView * indicator = [[UIView alloc]init];
        self.indicator = indicator;
        indicator.backgroundColor = WhiteColor;
        [self.segment addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.width.bottom.centerX.mas_equalTo([self.segment.customViews firstObject]);
        }];
        self.segment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        self.segment.type = HMSegmentedControlTypeCustom;
        self.segment.selectionIndicatorColor = [UIColor whiteColor];
        self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        self.segment.selectionIndicatorHeight = 2;
        self.segment.backgroundColor = [UIColor clearColor];
        self.segment.segmentEdgeInset = UIEdgeInsetsMake(self.segment.segmentEdgeInset.top, 15, self.segment.segmentEdgeInset.bottom, 15);
        CGFloat width = 0;
        CGFloat space = self.segment.segmentEdgeInset.left+self.segment.segmentEdgeInset.right;
        for (NSString * name in names) {
            CGSize size = [name textSizeWithFont:self.segment.font];
            width += size.width;
        }
        width += (space*(names.count-1)+ self.segment.segmentEdgeInset.left+self.segment.segmentEdgeInset.right);
        self.segment.frame = CGRectMake(0, 0, ceilf(width+.5f), 44);
//        [segment setIndexChangeBlock:^(NSInteger index) {
//            [weakself.pagingScrollView moveToPageAtIndex:index animated:NO];
//        }];
        self.navigationItem.titleView = self.segment;
    }else if (self.segmentType == BYBaseNavSegmentTypeButton){
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:names];
        _segmentControl = seg;
        seg.frame = CGRectMake(0, 0, 160, 30);
        if (self.by_navigationBarStyle == BYNavigationBarStyleWhite) {
            seg.tintColor = HPColorForKey(@"main");;
            seg.layer.borderColor = HPColorForKey(@"main").CGColor;
        }else if (self.by_navigationBarStyle == BYNavigationBarStyleMain){
            seg.tintColor = HPColorForKey(@"#ffffff");;
            seg.layer.borderColor = HPColorForKey(@"#ffffff").CGColor;
        }
        seg.layer.cornerRadius = 5;
        seg.layer.borderWidth = 1;
        seg.layer.masksToBounds = YES;
        [seg setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HPFontWithSize(14),NSFontAttributeName, nil] forState:UIControlStateNormal];
        [seg addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        seg.selectedSegmentIndex = 0;
        self.navigationItem.titleView = seg;
        if (self.shouldSelectItem) {
            for (int i = 0; i < names.count; i++) {
                [seg setEnabled:self.shouldSelectItem(names[i],i) forSegmentAtIndex:i];
            }
        }
    }
}

#pragma mark - SegmentControl
-(void)segmentValueChange:(UISegmentedControl *)seg{
    [self.pagingScrollView moveToPageAtIndex:seg.selectedSegmentIndex animated:NO];
    UIViewController * vc = self.viewControllers[seg.selectedSegmentIndex];
    if (vc) {
        [vc viewWillAppear:YES];
    }
    if (self.enableFlipAnimate) {
        [self flipAn:vc.view];
    }
}

- (void)setBadgeNum:(NSInteger)num atIndex:(NSInteger)index
{
    if (self.segmentType == BYBaseNavSegmentTypeButton) {
        [self.segmentControl setBadgeNum:(int)num atIndex:(int)index];
    }else{
        BYNavSegmentItemView * itemView = [self.segment customViews][index];
        [itemView setBadgeNum:num];
    }
}

- (void)moveIndicatorToIndex:(NSInteger)index
{
    BYNavSegmentItemView * itemView = [self.segment customViews][index];
    [_indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.width.bottom.centerX.mas_equalTo(itemView);
    }];
    [UIView animateWithDuration:.2f animations:^{
        [self.segment layoutSubviews];
    }];
}

#pragma mark - public

- (void)selectSegmentIndex:(NSUInteger)index
{
    if (self.enableFlipAnimate) {
        UIViewController * vc = self.viewControllers[index];
        [self flipAn:vc.view];
    }
    if (self.segmentType == BYBaseNavSegmentTypeButton) {
        _segmentControl.selectedSegmentIndex = index;
        [self.pagingScrollView moveToPageAtIndex:index animated:NO];
    }else if (self.segmentType == BYBaseNavSegmentTypeTitle){
        [self moveIndicatorToIndex:index];
        [self.segment setSelectedSegmentIndex:index animated:YES];;
        [self.pagingScrollView moveToPageAtIndex:index animated:NO];
    }
}

- (void)flipAn:(UIView *)view {
    [UIView beginAnimations:@"FlipAni" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startAni:)];
    [UIView setAnimationDidStopSelector:@selector(stopAni:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    [UIView commitAnimations];
}
- (void)startAni:(NSString *)aniID {
    NSLog(@"%@ start",aniID);
}

- (void)stopAni:(NSString *)aniID {
    NSLog(@"%@ stop",aniID);
}
- (NSUInteger)currentSelectSegmentIndex
{
    return self.pagingScrollView.centerPageIndex;
}
@end
