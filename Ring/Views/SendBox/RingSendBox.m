//
//  RingSendBox.m
//  Ring
//
//  Created by Medpats on 1/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingSendBox.h"

#import "Ring-Essentials.h"

#import "RingImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "RingAudioHelper.h"

#define NORMAL_HEIGHT 60
#define EXPAND_HEIGHT 105
#define EXPAND_TIMER_HEIGHT 135

@interface RingSendBox()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
  NSURL *outputFileURL;
  NSInteger timeCount;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *attachButton;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) UIButton *touchRecord;

@property (strong, nonatomic) UIView *recordingContainer;
@property (weak, nonatomic) IBOutlet UILabel *timerText;
@property (weak, nonatomic) IBOutlet UILabel *maximumText;
@property (weak, nonatomic) IBOutlet UILabel *cancelText;

@property (strong, nonatomic) RingImagePickerViewController *imagePicker;
@end

@implementation RingSendBox
- (RingImagePickerViewController *)imagePicker
{
  if (!_imagePicker) {
    _imagePicker = [[RingImagePickerViewController alloc] init];
    _imagePicker.delegate = self;
  }
  return _imagePicker;
}

+ (RingSendBox *)initSendBox
{
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SendBoxView" owner:nil options:nil];
  RingSendBox *customView;
  UIView *recordingView;
  UIView *touchRecordView;
  for (UIView *view in views) {
    if (view.tag == 1) { //custom Tag
      customView = (RingSendBox *)view;
    } else if (view.tag ==2) { //Recording Tag
      recordingView = view;
    } else {
      touchRecordView = view;
    }
  }
  customView.recordingContainer = recordingView;
  customView.touchRecord = (UIButton *)touchRecordView;
  [customView decorateUIs];
return customView;
}

- (void)decorateUIs
{
  self.backgroundColor = [UIColor ringNormalGrayColor];
  [self.messageBox decorateEclipseWithRadius:3];
  [self.messageBox decorateBorder:1 andColor:[UIColor ringLightGrayColor]];
  self.messageBox.backgroundColor = [UIColor whiteColor];
  self.messageBox.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
  self.messageBox.leftViewMode  = UITextFieldViewModeAlways;
  
  self.recordingContainer.backgroundColor = [UIColor ring70DarkGrayBGColor];
  [self.recordingContainer decorateEclipseWithRadius:5];
  self.timerText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].superFontSize];
  self.maximumText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.cancelText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.timerText.textColor = self.maximumText.textColor = self.cancelText.textColor = [UIColor ringMainColor];
}

#pragma mark --stateChange
- (void)resetFields
{
  self.messageBox.text = @"";
  self.messageBox.hidden = NO;
  self.emotionButton.hidden = NO;
  self.attachButton.hidden = NO;
  self.cancelButton.hidden = YES;
  self.recordButton.selected = NO;
  self.messageBox.alpha = 1;
}

- (void)hideTouchToRecord
{
  [UIView animateWithDuration:0.5 animations:^{
    self.touchRecord.alpha = 0;
  }];
}

- (void)showTouchToRecord
{
  CGRect frame = self.touchRecord.frame;
  UIWindow *view = [[UIApplication sharedApplication] keyWindow];
  frame.origin.x = (view.frame.size.width - frame.size.width) / 2;
  frame.origin.y = view.frame.size.height - frame.size.height - 5;
  frame.size.width = 68;
  frame.size.height = 68;
  self.touchRecord.frame = frame;
  [view addSubview:self.touchRecord];
  [UIView animateWithDuration:0.5 animations:^{
    self.touchRecord.alpha = 1;
    self.messageBox.alpha = 0;
  }];
}

- (void)hideRecordingView
{
  [self.recordingContainer removeFromSuperview];
}

- (void)hideAllButtonExpectRecord
{
  self.emotionButton.hidden = YES;
  self.attachButton.hidden = YES;
}

- (void)showWaitForConfirm
{
  self.recordButton.selected = YES;
  self.cancelButton.hidden = NO;
}

- (void)showRecordingView
{
  // show recording view
  CGRect frame = self.recordingContainer.frame;
  UIWindow *view = [[UIApplication sharedApplication] keyWindow];
  frame.origin.x = (view.frame.size.width - frame.size.width) / 2;
  frame.origin.y = (view.frame.size.height - frame.size.height) / 2;
  self.recordingContainer.frame = frame;
  [view addSubview:self.recordingContainer];
}

- (IBAction)cameraButtonPressed:(id)sender {
  [self.delegate presentModalViewController:self.imagePicker animated:YES];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([self.messageBox isEmtpy]) {
    [UIViewController showMessage:@"Please enter a message." withTitle:@"Form data invalid"];
    return NO;
  }
  [self.delegate sendWithText:self.messageBox.text];
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  NSString *imageUrl = [NSString stringWithFormat:@"%@",[info valueForKey:UIImagePickerControllerReferenceURL]];
  [self.delegate dismissViewControllerAnimated:YES completion:nil];
  [self.delegate sendWithImage:image andLocalUrl:imageUrl];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self.delegate dismissViewControllerAnimated:YES completion:nil];
}
@end
