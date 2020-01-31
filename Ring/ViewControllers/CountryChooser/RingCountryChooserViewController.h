//
//  RingCountryChooserViewController.h
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 04/09/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingCountry;

@protocol RingCountryChooserDelegate
- (void)didSelectcountry:(RingCountry *)country;
- (NSString *)selectedCountry;
@end

@interface RingCountryChooserViewController : UIViewController
@property (nonatomic,weak) id<RingCountryChooserDelegate> delegate;
@end
