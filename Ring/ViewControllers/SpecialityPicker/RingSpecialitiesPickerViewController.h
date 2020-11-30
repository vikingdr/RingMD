//
//  RingSpecialitiesPickerViewController.h
//  Ring
//
//  Created by Medpats on 7/15/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@class RingSpeciality;
@protocol RingSpecialitiesPickerViewControllerDelegate;

@protocol RingSpecialitiesPickerViewControllerDelegate
- (void)RingSpecialitySelected:(RingSpeciality *)speciality;
@end

@interface RingSpecialitiesPickerViewController : UIViewController
@property (weak, nonatomic) id<RingSpecialitiesPickerViewControllerDelegate> delegate;
@end
