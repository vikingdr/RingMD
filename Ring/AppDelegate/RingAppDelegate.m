//
//  RingAppDelegate.m
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

#import "RingAppDelegate.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"
#import "Ring-Swift.h"

#import "HockeySDK.h"
#import "RingMenuViewController.h"
#import "RingDoctorsCategoryViewController.h"
#import "RingMenuViewController.h"
#import "RingCallsViewController.h"
#import "RingInboxViewController.h"
#import "RingUserProfileViewController.h"

@interface RingAppDelegate()
@property (strong, nonatomic) UIView *requiredVersionView;
@property (strong, nonatomic) UIView *overlay;
@end

@implementation RingAppDelegate

- (NSMutableArray *)onlineUserIds
{
  if (!_onlineUserIds) {
    _onlineUserIds = [NSMutableArray array];
  }
  return _onlineUserIds;
}

//- (UILabel *)notifyNumberLabel
//{
//  if (!_notifyNumberLabel) {
//    _notifyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 6, 16, 16)];
//    _notifyNumberLabel.backgroundColor = [UIColor ringOrangeColor];
//    _notifyNumberLabel.textColor = [UIColor whiteColor];
//    _notifyNumberLabel.font = [UIFont boldRingFontOfSize:10];
//    _notifyNumberLabel.textAlignment = NSTextAlignmentCenter;
//    [_notifyNumberLabel decorateEclipseWithRadius:2];
//  }
//  return _notifyNumberLabel;
//}
//
//- (UIBarButtonItem *)leftMenuWithNotityItem
//{
//  if (!_leftMenuWithNotityItem) {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"notify-menu"] forState:UIControlStateNormal];
//    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
//    [view addSubview:button];
//    [view addSubview:self.notifyNumberLabel];
//    _leftMenuWithNotityItem =[[UIBarButtonItem alloc] initWithCustomView:view];
//  }
//  return _leftMenuWithNotityItem;
//}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Hockey Manager should be the last SDK loaded
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"1c6db942344a19b47c433bf86670661a"];
  [BITHockeyManager sharedHockeyManager].enableStoreUpdateManager = NO;
#ifdef DEBUG
  [BITHockeyManager sharedHockeyManager].disableCrashManager = YES;
//  [BITHockeyManager sharedHockeyManager].disableUpdateManager = YES;
//  [BITHockeyManager sharedHockeyManager].disableFeedbackManager = YES;
#endif
  [[BITHockeyManager sharedHockeyManager] startManager];
  [[BITHockeyManager sharedHockeyManager].authenticator
   authenticateInstallation];
  
  [RingNetworkHelper initMonitorNetwork];
  if (IS_IPAD) {
    [RingConfigConstant initIPadConfig];
  } else {
    [RingConfigConstant initIPhoneConfig];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeView:) name:ME_userNotification object:nil];
  
  currentUser = [RingAuthUser firstUser];
  
  [self customizeAppearance];
  
  return YES;
}

- (void)setUser:(RingAuthUser *)user
{
  _user = user;
  if (user) {
    NSLog(@"Successfully logged in as %@", user.name);
    [RingUser insertRingAuthUser:user];
    [currentUser subscribe];
    [[RingUser currentCacheUser] getFullUserInfoWithSuccess:^{} modally:YES];
  } else {
    [currentUser unSubscribe];
    NSLog(@"Successfully logged out");
  }
  
  [RingUtility checkRequiredVersion];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  NSLog(@"Will enter foreground");
  [RingUtility checkRequiredVersion];
}

- (void)updateBadgeView:(NSNotification *)notification
{
  ASSERT_MAIN_LOOP;
  
  NSInteger count = [self.unreadConversationIds count] + [self.unreadRequestIds count];
  [RingNavigationController sharedNavigationController].notificationCount = count;
}

- (void)customizeAppearance
{
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor whiteColor];
  shadow.shadowBlurRadius = 0.0;
  shadow.shadowOffset = CGSizeMake(0.0, 0.0);
  NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, nil];
  [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
  
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor ringLightMainColor]];
}

#pragma mark Update to New Version Prompt

- (UIView *)overlay
{
  if (!_overlay) {
    _overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [RingUtility currentWidth], [RingUtility currentHeight])];
    _overlay.backgroundColor = [UIColor ring70DarkGrayBGColor];
    [self.window addSubview:_overlay];
  }
  return _overlay;
}

- (UIView *)requiredVersionView
{
  if (!_requiredVersionView) {
    CGFloat width = 300;
    CGFloat height = 180;
    _requiredVersionView = [[UIView alloc] initWithFrame:CGRectMake(([RingUtility currentWidth] - width)/2, ([RingUtility currentHeight] - height) /2, width, height)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    title.text = @"RingMD got an upgrade";
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor ringWhiteColor];
    title.textColor = [UIColor ringMainColor];
    title.font = [UIFont boldRingFontOfSize:16];
    [_requiredVersionView addSubview:title];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, width - 30, height - 94)];
    message.text =  @"A new version of the RingMD app is available. Please download it from the App Store.";
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 3;
    message.font = [UIFont ringFontOfSize:16];
    [_requiredVersionView addSubview:message];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake((width - 180)/2, height - 45, 180, 30);
    [okButton setTitle:@"Open App Store" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
    [okButton decorateEclipseWithRadius:3];
    [okButton decorateBorder:1 andColor:[UIColor ringMainColor]];
    [okButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    
    [_requiredVersionView addSubview:okButton];
    _requiredVersionView.hidden = YES;
    _requiredVersionView.backgroundColor = [UIColor whiteColor];
    [_requiredVersionView decorateEclipseWithRadius:3];
    [_requiredVersionView decorateBorder:1 andColor:[UIColor lightGrayColor]];
    [self.overlay addSubview:_requiredVersionView];
  }
  return _requiredVersionView;
}

- (void)showRequiredVersion
{
  _overlay.hidden = NO;
  self.requiredVersionView.hidden = NO;
}

- (void)hideRequireVersion
{
  _overlay.hidden = YES;
}

- (void)updateVersion
{
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id878900126"]])
    [self openUrl:@"itms-apps://itunes.apple.com/app/id878900126"];
  else
    [self openUrl:@"https://itunes.apple.com/us/app/tournative/id878900126?ls=1&mt=8"];
}

- (void)openUrl:(NSString *)url {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [self updateVersion];
  }
}

@end
