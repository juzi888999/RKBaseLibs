//
//  RKWaterFlowLayout.h
//  RKBaseLibs
//
//  Created by rk on 2017/12/21.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) NSInteger numberOfColumns;//number of column. Default is 1
@property (nonatomic) NSInteger section;

- (void)clearFrameCache;//all the cell frames by index path will be cached, so when the frame of some index path changed, you must call this method to clean the record. for example, datasource changed when you pull down refresh.

@end
