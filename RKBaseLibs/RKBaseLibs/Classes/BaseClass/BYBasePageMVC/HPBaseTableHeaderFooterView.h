//
//  HPBaseReuseView.h
//  RKBaseLibs
//
//  Created by rk on 2017/11/7.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBaseTableHeaderFooterView : UITableViewHeaderFooterView

@property (strong,nonatomic) id object;

+ (NSString*)identifierWithObject:(id)object;
+ (CGFloat)heightWithObject:(id)object tableView:(UITableView *)tableView section:(NSInteger)section;

- (BOOL)shouldUpdateWithObject:(id)object;

@end
