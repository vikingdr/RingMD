//
//  RingImagePickerViewController.m
//  Ring
//
//  Created by Medpats on 1/16/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingImagePickerViewController.h"

#define BUTTON_WIDTH 80

@interface RingImagePickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (nonatomic) UIImagePickerController *imagePickerController;
@end

@implementation RingImagePickerViewController

- (UIImagePickerController *)imagePickerController
{
  if (!_imagePickerController) {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  return _imagePickerController;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initOverlay];
  [self transformOverView];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)initOverlay
{
  self.sourceType = UIImagePickerControllerSourceTypeCamera;
  self.showsCameraControls = NO;
  [[NSBundle mainBundle] loadNibNamed:@"CameraOverlay" owner:self options:nil];
  self.overlayView.frame = self.cameraOverlayView.frame;
  self.cameraOverlayView = self.overlayView;
  self.overlayView = nil;
}

- (void)transformOverView
{
  CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 50.0);
  self.cameraViewTransform = translate;
}

- (IBAction)switchCameraPressed:(UIButton *)sender {
  sender.selected =! sender.selected;
  if (sender.selected) {
    self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
  } else {
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
  }
}

- (IBAction)cameraPressed:(id)sender {
  [self takePicture];
}

- (IBAction)photosButtonPressed:(id)sender {
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)cancleButtonPressed:(id)sender {
  [self.delegate imagePickerControllerDidCancel:self];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
