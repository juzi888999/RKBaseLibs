//
//  HPInputAccessoryView.h
//  RKBaseLibs
//
//  Created by rk on 16/5/3.
//  Copyright © 2016年 haixiaedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPInputAccessoryView : NSObject

+ (UIToolbar *)createThemeInputAccessoryViewWithTarget:(id)target cancelSel:(SEL)cancelSel completeSel:(SEL)completeSel;
@end
