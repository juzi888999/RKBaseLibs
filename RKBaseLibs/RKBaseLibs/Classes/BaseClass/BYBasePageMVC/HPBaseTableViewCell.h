//
//  HPBaseTableViewCell.h
//
//  Created by rk on 14-11-19.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "FTTableViewCell.h"

@interface HPBaseTableViewCell : FTTableViewCell

@property (strong,nonatomic) UIImageView * rightAccessoryView;

+ (NSString*)cellIdentifierWithObject:(id)object;

- (UIView *)addRightAccessoryView;

@end
//
//@interface HPTableViewCell : HPBaseTableViewCell
//
//@property (nonatomic, strong) UIView *container;
//@property (nonatomic, strong) UIView *separator;
//@property (nonatomic, assign, readonly) UITableView *tableView;
//
//@end
