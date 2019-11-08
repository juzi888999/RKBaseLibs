//
//  HPBaseReuseView.m
//  RKBaseLibs
//
//  Created by rk on 2017/11/7.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "HPBaseTableHeaderFooterView.h"

@implementation HPBaseTableHeaderFooterView

+ (NSString*)identifierWithObject:(id)object
{
    NSString* identifier = NSStringFromClass([self class]);
    if (object) {
        identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass(object)];
    }else{
        identifier = [identifier stringByAppendingFormat:@"."];
    }
    return identifier;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (CGFloat)heightWithObject:(id)object tableView:(UITableView *)tableView section:(NSInteger)section
{
    return 30;
}

- (BOOL)shouldUpdateWithObject:(id)object
{
    self.object = object;
    return YES;
}
@end
