//
//  JKBannerCollectionViewCell.m
//
//  Created by 王冲 on 2017/9/8.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "JKBannerCollectionViewCell.h"

//屏幕尺寸
#define CIO_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define CIO_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
@implementation JKBannerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        
         [self layout];
    }
    
    return self;

}

-(void)layout{

    /*
     *  图片的添加
     */
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    _imageView.layer.cornerRadius = 4;
//    _imageView.clipsToBounds = YES;

    [self.contentView addSubview:_imageView];
}

@end
