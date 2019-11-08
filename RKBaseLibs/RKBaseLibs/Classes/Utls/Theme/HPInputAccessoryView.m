//
//  HPInputAccessoryView.m
//  RKBaseLibs
//
//  Created by rk on 16/5/3.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import "HPInputAccessoryView.h"

@implementation HPInputAccessoryView

+ (UIToolbar *)createThemeInputAccessoryViewWithTarget:(id)target cancelSel:(SEL)cancelSel completeSel:(SEL)completeSel
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    toolBar.layer.borderWidth = .5f;
    toolBar.layer.borderColor = HPColorForKey(@"separator").CGColor;
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:target action:cancelSel];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:completeSel];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:space1,left,space2,right,space3,nil];
    return toolBar;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
