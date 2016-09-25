//  
//  HYBPhotoPickerManager.m  
//  ehui  
//  
//  Created by 黄仪标 on 14/11/26.  
//  Copyright (c) 2014年 黄仪标. All rights reserved.  
//  
  
#import "HYBPhotoPickerManager.h"  
#import "UIImagePickerController+Photo.h"  
#import "UIImage+DSResizeAndRound.h"  
  
@interface HYBPhotoPickerManager () <UIImagePickerControllerDelegate,  
UINavigationControllerDelegate,  
UIActionSheetDelegate>  
  
@property (nonatomic, weak)     UIViewController          *fromController;  
@property (nonatomic, copy)     HYBPickerCompelitionBlock completion;  
@property (nonatomic, copy)     HYBPickerCancelBlock      cancelBlock;  
  
@end  
  
@implementation HYBPhotoPickerManager  
  
+ (HYBPhotoPickerManager *)shared {  
  static HYBPhotoPickerManager *sharedObject = nil;  
  static dispatch_once_t onceToken;  
    
  dispatch_once(&onceToken, ^{  
    if (!sharedObject) {  
      sharedObject = [[[self class] alloc] init];  
    }  
  });  
    
  return sharedObject;  
}  
  
- (void)showActionSheetInView:(UIView *)inView  
               fromController:(UIViewController *)fromController  
                   completion:(HYBPickerCompelitionBlock)completion  
                  cancelBlock:(HYBPickerCancelBlock)cancelBlock {  
  self.completion = [completion copy];  
  self.cancelBlock = [cancelBlock copy];  
  self.fromController = fromController;  
    
  dispatch_async(kGlobalThread, ^{  
    UIActionSheet *actionSheet = nil;  
    if ([UIImagePickerController isCameraAvailable]) {  
      actionSheet  = [[UIActionSheet alloc] initWithTitle:nil  
                                                 delegate:(id<UIActionSheetDelegate>)self  
                                        cancelButtonTitle:@"取消"  
                                   destructiveButtonTitle:nil  
                                        otherButtonTitles:@"从相册选择", @"拍照上传", nil nil];  
    } else {  
      actionSheet = [[UIActionSheet alloc] initWithTitle:nil  
                                                delegate:(id<UIActionSheetDelegate>)self  
                                       cancelButtonTitle:@"取消"  
                                  destructiveButtonTitle:nil  
                                       otherButtonTitles:@"从相册选择", nil nil];  
    }  
      
    dispatch_async(kMainThread, ^{  
      [actionSheet showInView:inView];  
    });  
  });  
    
  return;  
}  
  
#pragma mark - UIActionSheetDelegate  
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {  
  if (buttonIndex == 0) { // 从相册选择  
    if ([UIImagePickerController isPhotoLibraryAvailable]) {  
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
      picker.delegate = self;  
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
      picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];  
        
      if (kIsIOS7OrLater) {  
        picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;  
      }  
      // 设置导航默认标题的颜色及字体大小  
      picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],  
                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};  
      [self.fromController presentViewController:picker animated:YES completion:nil];  
    }  
  } else if (buttonIndex == 1) { // 拍照  
    if ([UIImagePickerController canTakePhoto]) {  
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
      picker.delegate = self;  
      picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
      picker.delegate = self;  
      if (kIsIOS7OrLater) {  
        picker.navigationBar.barTintColor = self.fromController.navigationController.navigationBar.barTintColor;  
      }  
      // 设置导航默认标题的颜色及字体大小  
      picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],  
                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};  
      [self.fromController presentViewController:picker animated:YES completion:nil];  
    }  
  }  
  return;  
}  
  
#pragma mark - UIImagePickerControllerDelegate  
// 选择了图片或者拍照了  
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {  
  [aPicker dismissViewControllerAnimated:YES completion:nil];  
  __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];  
    
  if (image && self.completion) {  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
    [self.fromController setNeedsStatusBarAppearanceUpdate];  
      
    dispatch_async(kGlobalThread, ^{  
      image = [image imageResizedToSize:CGSizeMake(kScreenWidth / 2.0, kScreenHeight / 2.0)];  
      DDLogVerbose(@"image size : %@", NSStringFromCGSize(image.size));  
        
      dispatch_async(kMainThread, ^{  
        self.completion(image);  
      });  
    });  
  }  
  return;  
}  
  
// 取消  
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {  
  [aPicker dismissViewControllerAnimated:YES completion:nil];  
    
  if (self.cancelBlock) {  
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
    [self.fromController setNeedsStatusBarAppearanceUpdate];  
      
    self.cancelBlock();  
  }  
  return;  
}  
  
@end  
