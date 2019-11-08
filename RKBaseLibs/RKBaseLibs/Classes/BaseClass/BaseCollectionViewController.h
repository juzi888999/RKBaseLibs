//
//  BaseCollectionViewController.h
//  RKBaseLibs
//
//  Created by rk on 2017/9/15.
//  Copyright © 2017年 rk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic)  UICollectionView * collectionView;
- (UICollectionViewLayout *)collectionLayout;

@end
