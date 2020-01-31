//
//  RingUserProfileViewController.m
//  Ring
//
//  Created by Tan Nguyen on 9/23/13.
//  Copyright (c) 2013 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingUserProfileViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingProfileBasicInfoViewController.h"
#import "RingImagePickerViewController.h"
#import "RingMedicalHistoryViewController.h"
#import "RingBusinessHourViewController.h"
#import "RingSearchViewController.h"
#import "RingProfileCell.h"

typedef enum {
  BASIC = 0,
  HISTORY,
  LOGOUT,
  ITEM_COUNT
} PATIENT;

typedef enum {
  DOCTOR_BASIC = 0,
  DOCTOR_BUSINESS_HOUR,
//  DOCTOR_BUSY_TIME,
  DOCTOR_LOGOUT,
  DOCTOR_ITEM_COUNT
} DOCTOR;

@interface RingUserProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NavigationBarOptions>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureProfile;
@property (weak, nonatomic) IBOutlet UILabel *profileNameText;
@property (weak, nonatomic) IBOutlet UIButton *changePictureButton;
@property (strong, nonatomic) IBOutlet CALayer *customNavBarBorder;
@end

@implementation RingUserProfileViewController

- (RingUser *)user
{
  if (!_user) {
    _user = [RingUser currentCacheUser];
  }
  return _user;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateUIs];
  
  _customNavBarBorder = [CALayer layer];
  _customNavBarBorder.borderColor = [UIColor ringMainColor].CGColor;
  _customNavBarBorder.borderWidth = 1;
  CALayer *layer = self.navigationController.navigationBar.layer;
  _customNavBarBorder.frame = CGRectMake(0, layer.bounds.size.height, layer.bounds.size.width, 1);
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController.navigationBar.layer addSublayer:_customNavBarBorder];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [_customNavBarBorder removeFromSuperlayer];
}

- (void)updateUIs
{
  self.view.backgroundColor = [UIColor ringMainColor];
  
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.separatorInset = UIEdgeInsetsZero;
  
  self.profileNameText.text = self.user.name;
  self.profileNameText.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  self.profileNameText.textColor = [UIColor whiteColor];
  
  [self.changePictureButton decorateEclipseWithRadius:8];
  [self.changePictureButton decorateBorder:1 andColor:[UIColor whiteColor]];
  [self.changePictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.changePictureButton.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  
  [self.pictureProfile loadImageFromUrl:[NSURL URLWithString:self.user.avatar]];
}

- (IBAction)changeButtonPressed:(id)sender {
  RingImagePickerViewController *picker = [[RingImagePickerViewController alloc] init];
  picker.delegate = self;
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  image = [image resizeAndCropWithSize:CGSizeMake(200, 200)];
  self.pictureProfile.image = image;
  [self dismissViewControllerAnimated:YES completion:nil];
  [self.user uploadAvatar:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchButtonPressed:(id)sender {
  RingSearchViewController *searchView = (RingSearchViewController *)[RingUtility getViewControllerWithName:@"searchView"];
  [self.navigationController pushViewController:searchView animated:YES];
}

#pragma mark -- UITableViewDelegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return IS_DOCTOR ? DOCTOR_ITEM_COUNT : ITEM_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return IS_DOCTOR ? [self doctorTableView:tableView cellForRowAtIndexPath:indexPath] : [self patientTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)patientTableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userProfileCell"];
  switch (indexPath.row) {
    case BASIC:
      cell.profileCellText.text = @"Basic Information";
      cell.profileCellIcon.image = [UIImage imageNamed:@"profile-setting"];
      break;
    case HISTORY:
      cell.profileCellText.text = @"Medical History";
      cell.profileCellIcon.image = [UIImage imageNamed:@"history"];
      break;
    case LOGOUT:
      cell.profileCellText.text = @"Logout";
      cell.profileCellIcon.image = [UIImage imageNamed:@"logout"];
      break;
    default:
      break;
  }
  [cell decorateUIs];
  return cell;
}


- (UITableViewCell *)doctorTableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RingProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userProfileCell"];
  switch (indexPath.row) {
    case DOCTOR_BASIC:
      cell.profileCellText.text = @"Basic Information";
      cell.profileCellIcon.image = [UIImage imageNamed:@"profile-setting"];
      break;
    case DOCTOR_BUSINESS_HOUR:
      cell.profileCellText.text = @"Business Hour";
      cell.profileCellIcon.image = [UIImage imageNamed:@"profile-clock"];
      break;
//    case DOCTOR_BUSY_TIME:
//      cell.profileCellText.text = @"Busy Time";
//      cell.profileCellIcon.image = [UIImage imageNamed:@"profile-clock"];
//      break;
    case DOCTOR_LOGOUT:
      cell.profileCellText.text = @"Logout";
      cell.profileCellIcon.image = [UIImage imageNamed:@"logout"];
      break;
    default:
      break;
  }
  [cell decorateUIs];
  return cell;
}

- (void)gotoBasicInfo

{
  RingProfileBasicInfoViewController *basicInfo = (RingProfileBasicInfoViewController *)[RingUtility getViewControllerWithName:@"basicInfoView"];
  [self.navigationController pushViewController:basicInfo animated:YES];
}

- (void)gotoBusinessHour
{
  RingBusinessHourViewController *businessHour = (RingBusinessHourViewController *)[RingUtility getViewControllerWithName:@"businessHour"];
  [self.navigationController pushViewController:businessHour animated:YES];
}

- (void)gotoBusyTime
{
  RingBusinessHourViewController *businessHour = (RingBusinessHourViewController *)[RingUtility getViewControllerWithName:@"busyTime"];
  [self.navigationController pushViewController:businessHour animated:YES];
}

- (void)gotoHistory
{
  RingMedicalHistoryViewController *history = (RingMedicalHistoryViewController *)[RingUtility getViewControllerWithName:@"medicalHistoryView"];
  history.user = self.user;
  history.editable = YES;
  [self.navigationController pushViewController:history animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (IS_DOCTOR) {
    [self doctorTableView:tableView didSelectRowAtIndexPath:indexPath];
  } else {
    [self patientTableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (void)patientTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case BASIC:
      [self gotoBasicInfo];
      break;
    case HISTORY:
      [self gotoHistory];
      break;
    case LOGOUT:
      [RingNetworkHelper logout];
      break;
    default:
      break;
  }
}

- (void)doctorTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case DOCTOR_BASIC:
      [self gotoBasicInfo];
      break;
    case DOCTOR_BUSINESS_HOUR:
      [self gotoBusinessHour];
      break;
//    case DOCTOR_BUSY_TIME:
//      [self gotoBusyTime];
//      break;
    case DOCTOR_LOGOUT:
      [RingNetworkHelper logout];
      break;
    default:
      break;
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.001f;
}

#pragma mark SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
  return NO;
}

- (BOOL)shouldReturnToMenu
{
  return YES;
}
@end
