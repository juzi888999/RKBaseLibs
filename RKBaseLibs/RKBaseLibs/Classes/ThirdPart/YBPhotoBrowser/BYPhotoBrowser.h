//
//  BYPhotoBrowser.h
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYPhotoBrowser : NSObject

@property (strong,nonatomic) ZLPhotoActionSheet * sheet;
@property (copy,nonatomic) void(^photoBrowserDidClose)(void);
@property (assign,nonatomic) NSInteger currentPhotoIndex;
@property (copy,nonatomic) void (^configBlock)(ZLPhotoActionSheet *sheet);

- (void)showInViewController:(UIViewController *)viewController photos:(NSArray *)photos animated:(BOOL)flag completion:(void (^)(NSArray * photos))completion;

- (void)showInViewController:(UIViewController *)viewController photos:(NSArray *)photos animated:(BOOL)flag configBlock:(void (^ __nullable)(ZLPhotoActionSheet *sheet))configBlock completion:(void (^ __nullable)(NSArray * photos))completion;
@end

NS_ASSUME_NONNULL_END
