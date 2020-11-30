//
//  RingMedicalSchoolSearchViewController.h
//  Ring
//
//  Created by Medpats on 3/24/2557 BE.
//  Copyright (c) 2557 Matthew James All rights reserved.
//

@protocol MedialSearchDelegate <NSObject>
- (void)didSelectMedicalSchool:(NSString *)medicalSchool;
@end

@interface RingMedicalSchoolSearchViewController : UIViewController
@property (strong, nonatomic) NSString *implicitSchool;
@property (weak, nonatomic) id<MedialSearchDelegate> delegate;
@end
