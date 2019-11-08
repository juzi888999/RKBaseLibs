//
//  BYImagePickerController.m
//  RKBaseLibs 
//
//  Created by rk on 16/10/8.
//  Copyright © 2016年 rk. All rights reserved.
//

#import "BYImagePickerController.h"
#import "UIImage+Helper.h"

@interface BYImagePickerController()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong,nonatomic) UIViewController * viewController;

@end
@implementation BYImagePickerController

+ (instancetype)showWithViewController:(UIViewController *)viewController didFinishPickMediaBlock:(void(^)(UIImage * image,UIImagePickerController *picker))block
{
    BYImagePickerController * pickerController = [[BYImagePickerController alloc]initWithViewController:viewController];
    pickerController.didFinishPickingMedia = block;
    [pickerController showActionSheetInView:viewController.view];
    return pickerController;
}

-(instancetype)initWithViewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

- (void)showActionSheetInView:(UIView *)view
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:view];
}

#pragma mark  --- actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showPickerController:BYImagePickerTypeCamera viewController:self.viewController];
    }else if (buttonIndex == 1){
        [self showPickerController:BYImagePickerTypePhoto viewController:self.viewController];
    }
}

#pragma mark  图片选择
-(void)showPickerController:(BYImagePickerType)type viewController:(UIViewController *)viewController{
    self.viewController = viewController;
    UIImagePickerController *pickerCamera = [[UIImagePickerController alloc] init];
    pickerCamera.delegate = self;
    if (type==BYImagePickerTypeCamera) {
        if ([UIGlobal showCameraAuthAlertIfNeed]) return;
        pickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (type==BYImagePickerTypePhoto){
        pickerCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pickerCamera.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    pickerCamera.allowsEditing = YES;
    [self.viewController presentViewController:pickerCamera animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage * pickerImage;
        pickerImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //压缩图片
        pickerImage = [UIImage adjustImageWithImage:pickerImage];
        if (self.didFinishPickingMedia) {
            self.didFinishPickingMedia(pickerImage,picker);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMedia:)]) {
            [self.delegate imagePickerController:picker didFinishPickingMedia:pickerImage];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
