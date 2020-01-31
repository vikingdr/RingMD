//
//  RingAppDelegate.h
//  Ring
//
// Created by Medpats Global Pte. Ltd. on 05/09/13
// Copyright ( c ) 2013 Medpats Global Pte. Ltd.. All rights reserved.
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
