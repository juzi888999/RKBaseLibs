//
//  BaseCollectionViewCell.m
//  RKBaseLibs
//
//  Created by rk on 2017/9/15.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (BOOL)shouldUpdateCellWithObject:(id)object collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    return [super shouldUpdateWithObject:object collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

+ (CGSize)sizeForObject:(id)object collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}

+ (NSString *)getCollectionCellIdentify:(Class)class
{
    return [NSStringFromClass(class) stringByAppendingString:@"ID"];
}

@end
