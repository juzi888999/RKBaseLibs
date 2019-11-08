//
//  BYImagePickerController.h
//  RKBaseLibs 
//
//  Created by rk on 16/10/8.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BYImagePickerType) {
    BYImagePickerTypePhoto,
    BYImagePickerTypeCamera
};

@class BYImagePickerController;
@protocol BYImagePickerDelegate <NSObject>

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMedia:(UIImage *)image;

@end
@interface BYImagePickerController : NSObject
@property (weak,nonatomic) id<BYImagePickerDelegate> delegate;
@property (copy,nonatomic) void(^didFinishPickingMedia)(UIImage * image,UIImagePickerController *picker);

+ (instancetype)showWithViewController:(UIViewController *)viewController didFinishPickMediaBlock:(void(^)(UIImage * image,UIImagePickerController *picker))block;

-(instancetype)initWithViewController:(UIViewController *)viewController;

- (void)showActionSheetInView:(UIView *)view;

-(void)showPickerController:(BYImagePickerType)type viewController:(UIViewController *)viewController;

@end
