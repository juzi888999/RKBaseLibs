//
//  BYPhotoBrowser.m
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYPhotoBrowser.h"

@interface BYPhotoBrowser()///<MWPhotoBrowserDelegate>
@property (strong,nonatomic) NSMutableArray * photos;

@end
@implementation BYPhotoBrowser

-(instancetype)init
{
    if (self = [super init]) {
        self.currentPhotoIndex = 0;
    }
    return self;
}

-(void)setupPhotos:(NSArray *)photos
{
    self.photos = [NSMutableArray arrayWithCapacity:[NSArray checkArray:photos].count];
    for (id obj in photos) {
        NSDictionary * dic = nil;
        if ([obj isKindOfClass:[UIImage class]]) {
            dic = GetDictForPreviewPhoto(obj, ZLPreviewPhotoTypeUIImage);
            [self.photos addObject:dic];
        }else if ([obj isKindOfClass:[NSString class]]){
            if ([obj hasSuffix:@".mp4"]) {
                 dic = GetDictForPreviewPhoto([NSURL URLWithString:obj], ZLPreviewPhotoTypeURLVideo);
                 [self.photos addObject:dic];
            }else{
                dic = GetDictForPreviewPhoto(obj, ZLPreviewPhotoTypeURLImage);
                [self.photos addObject:dic];
            }
        }else if ([obj isKindOfClass:[NSURL class]]){
            NSURL * url = (NSURL *)obj;
            if ([url.absoluteString hasSuffix:@".mp4"]) {
                dic = GetDictForPreviewPhoto(obj, ZLPreviewPhotoTypeURLVideo);
                [self.photos addObject:dic];
            }else{
                dic = GetDictForPreviewPhoto(obj, ZLPreviewPhotoTypeURLImage);
                [self.photos addObject:dic];
            }
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            [self.photos addObject:obj];
        }
    }
}

- (void)showInViewController:(UIViewController *)viewController photos:(NSArray *)photos animated:(BOOL)flag completion:(void (^)(NSArray * photos))completion
{
    [self setupPhotos:photos];
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    self.sheet = ac;
    if (self.configBlock) {
        self.configBlock(self.sheet);
    }
    //如调用的方法无sender参数，则该参数必传
    ac.sender = viewController;
    [ac previewPhotos:self.photos index:self.currentPhotoIndex hideToolBar:YES complete:^(NSArray * _Nonnull nPhotos) {
        if (completion) {
            completion(nPhotos);
        }
    }];
}

- (void)showInViewController:(UIViewController *)viewController photos:(NSArray *)photos animated:(BOOL)flag configBlock:(void (^ __nullable)(ZLPhotoActionSheet *sheet))configBlock completion:(void (^ __nullable)(NSArray * photos))completion
{
    self.configBlock = configBlock;
    [self showInViewController:viewController photos:photos animated:flag completion:completion];
}

/*
- (void)showInViewController:(UIViewController *)viewController animated: (BOOL)flag completion:(void (^ __nullable)(void))completion
{
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:self.browser];
    [viewController presentViewController:navi animated:flag completion:completion];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.photos[index];
}

-(void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    if (self.photoBrowserDidClose) {
        self.photoBrowserDidClose(photoBrowser);
    }else{
        [self.browser dismissViewControllerAnimated:YES completion:nil];
    }
}
*/

-(void)dealloc
{
    NSLog(@"");
}
@end
