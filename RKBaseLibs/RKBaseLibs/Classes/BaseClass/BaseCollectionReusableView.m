//
//  BaseCollectionReusableView.m
//  RKBaseLibs
//
//  Created by rk on 2017/9/15.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "BaseCollectionReusableView.h"

@implementation BaseCollectionReusableView

+ (NSString *)reusableViewIdentify
{
    return NSStringFromClass([self class]);
}
+(NSString *)footerReusableViewIdentify{
    return @"FooterID";
}
+(NSString *)headerReusableViewIdentify{
    return @"HeaderID";
}
+ (CGSize)sizeForObject:(id)object collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(MainScreenWidth, 44);
}

- (BOOL)shouldUpdateWithObject:(id)object collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    self.entity = object;
    return YES;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel * textLabel = [UILabel leftAlignLabel];
        self.textLabel = textLabel;
        [self addSubview:textLabel];
        textLabel.font = HPFontWithSize(16);
        textLabel.textColor = [UIColor blackColor];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}
@end
