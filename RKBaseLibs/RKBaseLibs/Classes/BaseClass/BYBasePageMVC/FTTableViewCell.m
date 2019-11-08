//
//  FTTableViewCell.m
//
//  Created by rk on 14-10-9.
//  Copyright (c) 2014年 juzi. All rights reserved.
//

#import "FTTableViewCell.h"

@implementation FTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 60.f;
}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    self.entity = object;
    return YES;
}

@end
