//
//  BYPhotoBrowser.m
//  RKBaseLibs 
//
//  Created by rk on 16/7/20.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYPhotoBrowser.h"

@interface BYPhotoBrowser()<MWPhotoBrowserDelegate>
@property (strong,nonatomic) NSMutableArray * photos;
@end
@implementation BYPhotoBrowser

-(instancetype)initWithPhotos:(NSArray *)photos
{
    if (self = [super init]) {
        self.photos = [NSMutableArray arrayWithCapacity:[NSArray checkArray:photos].count];
        
        for (id image in photos) {
            if ([image isKindOfClass:[UIImage class]]) {
                [self.photos addObject:[MWPhoto photoWithImage:image]];
            }else if ([image isKindOfClass:[NSString class]]){
                if ([image hasSuffix:@".mp4"]) {
                     [self.photos addObject:[MWPhoto videoWithURL:[NetworkClient imageUrlForString:image]]];
                }else{
                    [self.photos addObject:[MWPhoto photoWithURL:[NetworkClient imageUrlForString:image]]];
                }
            }else if ([image isKindOfClass:[NSURL class]]){
                NSURL * url = (NSURL *)image;
                if ([url.absoluteString hasSuffix:@".mp4"]) {
                    [self.photos addObject:[MWPhoto videoWithURL:url]];
                }else{
                    [self.photos addObject:[MWPhoto photoWithURL:image]];
                }
            }else if ([image isKindOfClass:[MWPhoto class]]){
                [self.photos addObject:image];
            }
        }
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        self.browser = browser;
        // Set options
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = YES; // Auto-play first video
        browser.enableSwipeToDismiss = NO;
    }
    return self;
}

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

-(void)dealloc
{
    NSLog(@"");
}
@end
