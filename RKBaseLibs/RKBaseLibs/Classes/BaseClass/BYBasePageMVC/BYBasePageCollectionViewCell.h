//
//  BYBasePageCollectionViewCell.h
//  RKBaseLibs
//
//  Created by rk on 2017/9/17.
//  Copyright © 2017年 杨艺博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYBasePageCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) id entity;

+ (NSString *)cellIdentifyWithObject:(id)object;
- (BOOL)shouldUpdateWithObject:(id)object collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@end
