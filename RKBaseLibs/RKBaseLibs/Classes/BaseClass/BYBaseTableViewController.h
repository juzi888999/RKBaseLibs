//
//  BYBaseTableViewController.h
//  RKBaseLibs 
//
//  Created by rk on 16/7/27.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BaseViewController.h"

@interface BYBaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView * tableView;

-(UITableViewStyle)tableViewStyle;

@end
