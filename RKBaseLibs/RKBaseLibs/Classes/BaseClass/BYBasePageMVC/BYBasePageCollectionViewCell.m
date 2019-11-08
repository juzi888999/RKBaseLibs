//
//  BYBasePageCollectionViewCell.m
//  RKBaseLibs
//
//  Created by rk on 2017/9/17.
//  Copyright © 2017年 杨艺博. All rights reserved.
//

#import "BYBasePageCollectionViewCell.h"

@implementation BYBasePageCollectionViewCell

- (BOOL)shouldUpdateWithObject:(id)object collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.entity = object;
    return YES;
}

+ (NSString *)cellIdentifyWithObject:(id)object
{
    if (object) {
        return [NSStringFromClass([self class]) stringByAppendingString:NSStringFromClass([object class])];
    }else{
        return NSStringFromClass([self class]);
    }
}
@end
