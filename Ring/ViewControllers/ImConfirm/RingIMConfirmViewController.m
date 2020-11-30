//
//  RingIMConfirmViewController.m
//  Ring
//
//  Created by Medpats on 5/14/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

#import "RingIMConfirmViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

@interface RingIMConfirmViewController ()<NavigationBarOptions>
@property (weak, nonatomic) IBOutlet UIButton *signUpPatientButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpDoctorButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeight;
@end

@implementation RingIMConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self decorateWhitebackground];
  [self decorateUIs];
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.containerHeight.constant = self.view.frame.size.height;
}

- (void)decorateUIs
{
  self.signInButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.signInButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

  self.signUpPatientButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  [self.signUpPatientButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.signUpPatientButton.backgroundColor = [UIColor ringMainColor];
  self.signUpDoctorButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  [self.signUpDoctorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.signUpDoctorButton.backgroundColor = [UIColor ringMainColor];
}

- (IBAction)signInPressed:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)shouldShowNavigationBar
{
  return NO;
}
@end
