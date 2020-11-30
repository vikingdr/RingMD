//
//  RingCountryCodeViewController.h
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 15/09/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

@protocol RingCountryCodeViewControllerDelegate
- (void)didSelectCountryCode:(NSString *)code;
- (NSString *)selectedCountryCode;
@end

@interface RingCountryCodeViewController : UITableViewController
@property (weak, nonatomic) id<RingCountryCodeViewControllerDelegate> delegate;
@end
