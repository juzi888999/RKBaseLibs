//
//  BaseCollectionReusableView.h
//  RKBaseLibs
//
//  Created by rk on 2017/9/15.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionReusableView : UICollectionReusableView

@property (strong,nonatomic) id entity;
@property (strong,nonatomic) UILabel * textLabel;

+ (NSString *)reusableViewIdentify;
+ (NSString *)footerReusableViewIdentify;
+ (NSString *)headerReusableViewIdentify;

+ (CGSize)sizeForObject:(id)object collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

- (BOOL)shouldUpdateWithObject:(id)object collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

