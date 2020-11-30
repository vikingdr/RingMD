//
//  RingMenuViewController.m
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "RingMenuViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "RingCallsViewController.h"
#import "TDBadgedCell.h"

typedef enum {
  PATIENT_DOCTORS,
  PATIENT_MY_REQUEST,
  PATIENT_MESSAGES,
  PATIENT_FAVORITES,
  PATIENT_PROFILE_SETTING,
  PATIENT_MENU_ITEM_COUNT
} PATIENT_MENUS;

typedef enum {
  DOCTOR_DOCTORS,
  DOCTOR_MY_REQUEST,
  DOCTOR_MESSAGES,
  DOCTOR_PROFILE_SETTING,
  DOCTOR_MENU_ITEM_COUNT
} DOCTOR_MENUS;

@interface RingMenuViewController ()<UITableViewDataSource, UITableViewDelegate, NavigationBarOptions>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RingMenuViewController

- (NSString *)menuTitleAtIndex:(NSInteger)index
{
  NSArray *titles;
  if (!titles) {
    if (IS_DOCTOR) {
      titles = @[@"Select a Doctor", @"Appointments", @"Messages", @"Profile and Settings"];
    } else {
      titles = @[@"Select a Doctor", @"Appointments", @"Messages", @"Favorites", @"Profile and Settings"];
    }
  }
  return titles[index];
}

- (NSString *)menuImageNameAtIndex:(NSInteger)index
{
  NSArray *images;
  if (!images) {
    if (IS_DOCTOR) {
      images = @[@"doctors", @"request", @"mail", @"profile"];
    } else {
      images = @[@"doctors", @"request", @"mail", @"favorite", @"profile"];
    }
  }
  return images[index];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	return [super initWithCoder:aDecoder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self updateUIs];
  [self observeEvents];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeView) name:ME_userNotification object:nil];
}

- (void)updateBadgeView
{
  [self.tableView reloadData];
}

- (void)updateUIs
{
  self.view.backgroundColor = [UIColor ringBackgroundMenuColor];
  [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  self.tableView.separatorColor = [UIColor colorWithRed:0.125 green:0.161 blue:0.2 alpha:1];
}

- (void)gotoViewControllerWithName:(NSString *)vcName
{
  UIViewController *vc = [RingUtility getViewControllerWithName:vcName];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoCallRequests
{
  [self gotoViewControllerWithName:@"callsVC"];
}

- (void)gotoInbox
{
  [self gotoViewControllerWithName:@"inbox"];
}

- (void)gotoProfile
{
  [self gotoViewControllerWithName:@"userProfile"];
}

- (void)gotoDoctors
{
  [self gotoViewControllerWithName:@"doctors"];
}

- (void)gotoFavorites
{
  [self gotoViewControllerWithName:@"favorites"];
}

- (void)gotoSearch
{
  [self gotoViewControllerWithName:@"search"];
}

#pragma mark -
#pragma mark UITableView Datasource

- (BOOL)isRequestRow:(NSIndexPath *)indexPath
{
  return indexPath.row == (IS_DOCTOR ? DOCTOR_MY_REQUEST : PATIENT_MY_REQUEST);
}

- (BOOL)isMessageRow:(NSIndexPath *)indexPath
{
  return indexPath.row == (IS_DOCTOR ? DOCTOR_MESSAGES : PATIENT_MESSAGES);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return IS_IPAD ? 95 : 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return IS_DOCTOR ? DOCTOR_MENU_ITEM_COUNT : PATIENT_MENU_ITEM_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"BadgeCell";
  
  TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].menuFontSize];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.badgeColor = [UIColor ringNotificationColor];
    cell.badgeColorHighlighted = [UIColor ringNotificationColor];
    cell.badgeTextColor = [UIColor whiteColor];
    cell.badge.badgeTextColor = [UIColor whiteColor];
    cell.badge.radius = 2;
    cell.badge.fontSize = [RingConfigConstant sharedInstance].textFontSize;
  }
  cell.badgeString = nil;
  if ([self isRequestRow:indexPath]) {
    if ([ringDelegate.unreadRequestIds count] != 0) {
      cell.badgeString = [NSString stringWithFormat:@"%d", [ringDelegate.unreadRequestIds count]];
    }
  }
  if ([self isMessageRow:indexPath]) {
    if ([ringDelegate.unreadConversationIds count] != 0) {
      cell.badgeString = [NSString stringWithFormat:@"%d", [ringDelegate.unreadConversationIds count]];
    }
  }
  cell.textLabel.text = [self menuTitleAtIndex:indexPath.row];
  cell.imageView.image = [UIImage imageNamed:[self menuImageNameAtIndex:indexPath.row]];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.1;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (IS_DOCTOR) {
    switch (indexPath.row) {
      case DOCTOR_MY_REQUEST:
        [self gotoCallRequests];
        break;
      case DOCTOR_MESSAGES:
        [self gotoInbox];
        break;
      case DOCTOR_DOCTORS:
        [self gotoDoctors];
        break;
      case DOCTOR_PROFILE_SETTING:
        [self gotoProfile];
        break;
      default:
        break;
    }
  } else {
    switch (indexPath.row) {
      case PATIENT_MY_REQUEST:
        [self gotoCallRequests];
        break;
      case PATIENT_MESSAGES:
        [self gotoInbox];
        break;
      case PATIENT_DOCTORS:
        [self gotoDoctors];
        break;
      case PATIENT_FAVORITES:
        [self gotoFavorites];
        break;
      case PATIENT_PROFILE_SETTING:
        [self gotoProfile];
        break;
      default:
        break;
    }
  }
}

- (void)refresh
{
  [self.tableView reloadData];
}

- (BOOL)shouldShowNavigationBar
{
  return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}
@end
