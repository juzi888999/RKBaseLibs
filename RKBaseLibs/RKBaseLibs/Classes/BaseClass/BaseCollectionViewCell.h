//
//  BaseCollectionViewCell.h
//  RKBaseLibs
//
//  Created by rk on 2017/9/15.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "BYBasePageCollectionViewCell.h"

@interface BaseCollectionViewCell : BYBasePageCollectionViewCell

+ (NSString *)getCollectionCellIdentify:(Class)class;
+ (CGSize)sizeForObject:(id)object collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
