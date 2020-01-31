//
//  RingQuestionCell.h
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

@class RingUser;
@class RingPatientQuestion;

#define CELL_HEIGHT  (IS_IPAD ? 65.0f : 40.0f)
#define CELL_TEXTAREA_HEIGHT 160.0f

@protocol RingQuetionCellDelegate <NSObject>
- (void)refreshTableKeepOpenAtIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index;
@end

@interface RingQuestionCell : UITableViewCell
@property (weak, nonatomic) RingPatientQuestion *patientQuestion;
@property (weak, nonatomic) RingUser *user;
@property (weak, nonatomic) id<RingQuetionCellDelegate> delegate;
@property (nonatomic) NSInteger index;

+ (NSString *)nibName;
+ (CGFloat)heightForCellWithUser:(RingUser *)user question:(RingPatientQuestion *)question;
@end
