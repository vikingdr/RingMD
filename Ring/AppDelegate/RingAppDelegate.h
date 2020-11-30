//
//  RingAppDelegate.h
//  Ring
//
// Created by Matthew James on 05/09/13
// Copyright ( c ) 2013 Matthew James. All rights reserved.
//

@class RingAuthUser, RingMenuViewController, RingCallsViewController, RingInboxViewController, RingUserProfileViewController, RingDoctorsCategoryViewController;

@interface RingAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIStoryboard *storyboard;

@property (strong, nonatomic) NSMutableArray *onlineUserIds;
@property (strong, nonatomic) NSMutableArray *unreadConversationIds;
@property (strong, nonatomic) NSMutableArray *unreadRequestIds;

@property (strong, nonatomic) RingAuthUser *user;

- (void)showRequiredVersion;
@end
