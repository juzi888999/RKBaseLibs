//
//  HPPopMenu.m
//  RKBaseLibs
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 haixiaedu. All rights reserved.
//

#import "HPPopMenu.h"
#import "HMSegmentedControl.h"
#import "UIImage+Tint.h"
#import <JHChainableAnimations/JHChainableAnimations.h>

@interface HPPopContentButton : UIButton

@end
@implementation HPPopContentButton
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat labelWidth = self.titleLabel.bounds.size.width;
    CGFloat move = 4;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+move, 0, -labelWidth-move);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-move, 0, imageWidth+move);
    
}

@end
@interface HPPopMenu ()

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIView *popMenuView;
@property (strong, nonatomic) NSMutableArray *segmentDataArray;
@property (strong,nonatomic) UIView * showSuperView;
@property (assign,nonatomic) CGRect showFrame;
@end

@implementation HPPopMenu

- (void)commonInit
{
    self.normalTextColor = [UIColor blackColor];
    self.highlightedTextColor = [UIColor blackColor];
    self.indicatorColor = nil;//[UIColor grayColor];
    self.indicatorHighlightedColor = nil;//[UIColor blackColor];
    self.saperateLineColor = [UIColor grayColor];
    self.textFont = HPFontMediumSizeFont;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
        for (NSString *str in titles) {
            [self.segmentDataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:str, @"text", @NO, @"expand",@"arrow_down_gray",@"indicator" ,nil]];
        }
        
        __weak typeof(self) weakSelf = self;
        HMSegmentedControl * segment = [[HMSegmentedControl alloc] initWithSectionItems:self.segmentDataArray customViewBlock:^UIView *(NSMutableDictionary *item, NSInteger index) {
            
            UIView *contentView = [UIView new];
            HPPopContentButton *button = [HPPopContentButton buttonWithType:UIButtonTypeCustom];
            [contentView addSubview:button];
            [button setTitle:item[@"text"] forState:UIControlStateNormal];
            [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
            [button setTitleColor:self.highlightedTextColor forState:UIControlStateHighlighted];
            button.userInteractionEnabled = NO;
            button.titleLabel.font = self.textFont;
            
            NSString * imageName = item[@"indicator"];
            UIImage *normalImage = HPImageForKey(imageName);
            
            if (self.indicatorColor) {
                [button setImage:[normalImage imageTintedWithColor:self.indicatorColor] forState:UIControlStateNormal];
            }else{
                [button setImage:normalImage forState:UIControlStateNormal];
            }
            if (self.indicatorHighlightedColor) {
                [button setImage:[normalImage imageTintedWithColor:self.indicatorHighlightedColor] forState:UIControlStateSelected];
            }else{
                [button setImage:normalImage forState:UIControlStateSelected];
            }
//            UIImageView *indicator = button.imageView;
//            indicator.contentMode = UIViewContentModeCenter;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(contentView);
            }];
            
//            [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.mas_equalTo(contentView);
//                make.right.mas_equalTo(contentView).mas_offset(-10);
//                make.size.mas_equalTo(CGSizeMake(9, 7));
//            }];
//            JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:indicator];
//            animator.rotate(180).animate(0);
            
            if (index != 2) {
                UIView *line = [UIView addLine:contentView];
                line.backgroundColor = self.saperateLineColor;
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(contentView);
                    make.height.mas_equalTo(contentView).mas_offset(-6);
                    make.width.mas_equalTo(HPLineHeight);
                    make.centerY.mas_equalTo(contentView);
                }];
            }
            
            return contentView;
        }];
        segment.selectedSegmentIndex = HMSegmentedControlNoSegment;
        segment.selectionIndicatorBoxOpacity = 0;
        segment.selectionIndicatorHeight = 0;
        segment.backgroundColor = [UIColor clearColor];
        segment.selectedStyleBlock = ^(NSArray *views, NSInteger selectedIndex) {
           //...
        };
        segment.indexChangeBlock = ^(NSInteger index) {
        };
        segment.tapAtIndexBlock = ^(NSInteger index) {
            [weakSelf tapSegmentAtIndex:index];
        };
        [self addSubview:segment];
        self.segmentedControl = segment;
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        [segment addBottomLine];
        
        segment.selectedSegmentIndex = HMSegmentedControlNoSegment;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    NSMutableDictionary * dic = self.segmentDataArray[self.segmentedControl.selectedSegmentIndex];
    dic[@"text"] = title;
    [self.segmentedControl setSectionItems:self.segmentDataArray];
}

- (void)setTitle:(NSString *)title forSegmentIndex:(NSInteger)index
{
    if (index < 0 || index >= self.segmentDataArray.count) {
        return;
    }
    NSMutableDictionary * dic = self.segmentDataArray[index];
    dic[@"text"] = title;
    [self.segmentedControl setSectionItems:self.segmentDataArray];
}

- (void)setIndicatorImage:(NSString * )image forSegmentIndex:(NSInteger)index
{
    if (index < 0 || index >= self.segmentDataArray.count) {
        return;
    }
    NSMutableDictionary * dic = self.segmentDataArray[index];
    dic[@"indicator"] = image;
    [self.segmentedControl setSectionItems:self.segmentDataArray];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitles:nil];
}

- (void)showSuperView:(UIView *)showSuperView showFrame:(CGRect)showFrame
{
    self.showSuperView = showSuperView;
    self.showFrame = showFrame;
}

- (void)showPopMenuWithContentView:(UIView*)view {
    if ([self.delegate respondsToSelector:@selector(willShowPopMenu:)]) {
        [self.delegate willShowPopMenu:self];
    }
    UIView * superView = nil;
    CGRect frame = CGRectZero;
    if (self.showSuperView && !CGRectEqualToRect(self.showFrame, CGRectZero)) {
        superView = self.showSuperView;
        frame = self.showFrame;
    }else{
        frame = CGRectMake(0, self.bottom, superView.width, superView.height-self.bottom);
        superView = self.superview;
    }
    if (!self.popMenuView && superView) {
        self.popMenuView = [[UIView alloc] initWithFrame:frame];
        self.popMenuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.popMenuView.backgroundColor = [UIColor clearColor];
        self.popMenuView.layer.masksToBounds = YES;
        [superView addSubview:self.popMenuView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.popMenuView.width, self.popMenuView.height)];
        maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.popMenuView addSubview:maskView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.popMenuView.width, self.popMenuView.height)];
        contentView.backgroundColor = [UIColor clearColor];
        [self.popMenuView addSubview:contentView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWhenTapAtContentBackgroundView)];
        gesture.cancelsTouchesInView = NO;
        [contentView addGestureRecognizer:gesture];
    }
    self.popMenuView.hidden = NO;
    UIView *maskView = [self.popMenuView subviews][0];
    maskView.opaque = NO;
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:maskView];
    animator.makeOpacity(YES).animate(0.3);
    UIView *contentView = [self.popMenuView subviews][1];
    [contentView removeAllSubviews];
    if (view) {
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(contentView);
        }];
    }
    contentView.bottom = 0;
    JHChainableAnimator *animator2 = [[JHChainableAnimator alloc] initWithView:contentView];
    animator2.makeY(0).easeInOut.animate(0.3);
}

- (void)hidePopMenu {
    if (!self.popMenuView || self.popMenuView.hidden) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(willHiddenPopMenu:)]) {
        [self.delegate willHiddenPopMenu:self];
    }
    UIView *maskView = [self.popMenuView subviews][0];
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:maskView];
    animator.makeOpacity(NO).animate(0.3);
    UIView *contentView = [self.popMenuView subviews][1];
        JHChainableAnimator *animator2 = [[JHChainableAnimator alloc] initWithView:contentView];
        animator2.makeY(-contentView.height).easeInOut.animateWithCompletion(0.3,^{
            self.popMenuView.hidden = YES;
        });
}

- (NSMutableArray*)segmentDataArray {
    if (!_segmentDataArray) {
        _segmentDataArray = [NSMutableArray array];
    }
    return _segmentDataArray;
}

- (void)closeWhenTapAtContentBackgroundView {
    if (!self.disableTapClose)
    {
        [self closePopMenu];
    }
}

- (void)closePopMenu {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index == HMSegmentedControlNoSegment) {
        index = 0;
    }
    NSMutableDictionary *item = self.segmentDataArray[index];
    if (![item[@"expand"] boolValue]) {
        return;
    }
    [self.popMenuView endEditing:YES];
    self.segmentedControl.tapAtIndexBlock(index);
}

- (void)tapSegmentAtIndex:(NSInteger)index {
    [self.popMenuView endEditing:YES];

    for (int i = 0; i < self.segmentedControl.customViews.count; i ++) {
        NSArray *subs = [self.segmentedControl.customViews[i] subviews];
        UIButton *button = (UIButton *)(subs[0]);
        if (i == index) {
            button.selected = !button.isSelected;
        }else{
            button.selected = NO;
        }
        UIImageView *indicator = button.imageView;
        [indicator.layer removeAllAnimations];
        indicator.transform = CGAffineTransformIdentity;
        if (button.selected) {
            JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:indicator];
            animator.rotate(180).animate(0);
        }
    }
    NSMutableDictionary *item = self.segmentDataArray[index];
    UIView * contentView = [self contentViewFormSegmentAtIndex:index];
    if ([item[@"expand"] boolValue]) {
        item[@"expand"] = @NO;
        [self hidePopMenu];
    }
    else {
        for (NSMutableDictionary *d in self.segmentDataArray) {
            d[@"expand"] = @NO;
        }
        item[@"expand"] = @YES;
        
        if (contentView) {
            [self showPopMenuWithContentView:contentView];
        }else{
            [self hidePopMenu];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popMenu:didTapSegmentAtIndex:item:)]) {
        [self.delegate popMenu:self didTapSegmentAtIndex:index item:item];
    }

}

- (UIView*)contentViewFormSegmentAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(popMenu:popContentViewForIndex:)]) {
        return [self.delegate popMenu:self popContentViewForIndex:index];
    }
    return nil;
}

- (void)reloadSegmentControllCustomViews
{
    self.segmentedControl.sectionItems = self.segmentedControl.sectionItems;
}

@end
