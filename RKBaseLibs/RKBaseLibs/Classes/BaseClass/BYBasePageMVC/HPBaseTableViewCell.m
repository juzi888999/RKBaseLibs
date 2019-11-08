//
//  HPBaseTableViewCell.m
//
//  Created by rk on 14-11-19.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPEntity.h"


@implementation HPBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    }
    return self;
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

+ (NSString*)cellIdentifierWithObject:(id)object {
    NSString* identifier = NSStringFromClass([self class]);
    if ([self respondsToSelector:@selector(shouldAppendObjectClassToReuseIdentifier)]
        && [self shouldAppendObjectClassToReuseIdentifier]) {
        if (object) {
            identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass(object)];
        }else{
            identifier = [identifier stringByAppendingFormat:@"."];
        }
    }
    return identifier;
}

- (UIImageView *)addRightAccessoryView
{
    UIImageView * rightAccessoryView = [[UIImageView alloc]initWithImage:HPImageForKey(@"icon_arrow")];
    self.rightAccessoryView = rightAccessoryView;
    [self.contentView addSubview:rightAccessoryView];
    [rightAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-15);
    }];
    return rightAccessoryView;
}

@end

//@interface HPTableViewCell ()
//
//@end
//
//@implementation HPTableViewCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self)
//    {
//        _container = [UIView new];
//        [self.contentView addSubview:_container];
//        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
//        }];
//        _container.backgroundColor = [UIColor whiteColor];
//        
//        self.separator = [UIView new];
//        [_container addSubview:self.separator];
//        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.container);//.offset(10);
//            make.right.mas_equalTo(self.container);//.offset(-10);
//            make.bottom.mas_equalTo(self.container);
//            make.height.mas_equalTo(2);
//        }];
//        UIView *line = [UIView new];
//        line.backgroundColor = HPColorForKey(@"table_cell_separator1");
//        [self.separator addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.and.right.mas_equalTo(self.separator);
//            make.height.mas_equalTo(HPLineHeight);
//        }];
//        line = [UIView new];
//        line.backgroundColor = HPColorForKey(@"table_cell_separator2");
//        [self.separator addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.mas_equalTo(self.separator);
//            make.top.mas_equalTo(HPLineHeight);
//            make.height.mas_equalTo(HPLineHeight);
//        }];
//    }
//    return self;
//}
//
////- (void)updateConstraints
////{
////    [_container mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
////    }];
////    [super updateConstraints];
////        JLRangeResponse *object = self.entity;
////    NSLog(@"uc: %@ %d", self.container, object.range.location);
////}
//
//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.container.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(0, 10, 0, 10));
//}
//
//- (BOOL)shouldUpdateCellWithObject:(HPEntity*)object
//{
//    self.entity = object;
//    return YES;
//}
//
//- (UITableView *)tableView
//{
//    id view = [self superview];
//    while (view && ![view isKindOfClass:[UITableView class]]) {
//        view = [view superview];
//    }
//    return view;
//}
//
//@end
