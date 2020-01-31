//
//  RingQuestionCell.m
//  Ring
//
//  Created by Medpats on 6/25/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingQuestionCell.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#define OPTION_HEIGHT 30.0f

@interface RingQuestionCell()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *questionText;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (weak, nonatomic) IBOutlet UIView *answerContainer;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectedAnswer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alignTopTable;

@property (weak, nonatomic) RingPatientAnswer *answer;
@end

@implementation RingQuestionCell
- (void)setPatientQuestion:(RingPatientQuestion *)patientQuestion
{
  _patientQuestion = patientQuestion;
  if ([patientQuestion.patientQuestionId integerValue] == SYMPTOMS_QUESTION || [patientQuestion.patientQuestionId integerValue] == TREATMENT_QUESTION) {
    [self updateValues];
    [self updateValueDetails];
  } else {
    _answer = [RingPatientAnswer findByPatientQuestionId:patientQuestion.patientQuestionId forUser:self.user];
    [self updateValues];
  }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  self.userInteractionEnabled = editing;
}

+ (NSString *)nibName
{
  return IS_IPAD ? @"QuestionCell_ipad" : @"QuestionCell";
}

- (void)awakeFromNib
{
  [self decorateUIs];
}

- (BOOL)isOptions
{
  return [_patientQuestion.extraQuestion.type isEqualToString:@"option"];
}

- (BOOL)isTextAreaAnswer
{
  return [_patientQuestion.extraQuestion.type isEqualToString:@"text_area"];
}

- (BOOL)isTextAnswer
{
  return [_patientQuestion.extraQuestion.type isEqualToString:@"text"];
}

- (BOOL)isYES
{
  return [_answer.value boolValue];
}

- (BOOL)isShowed
{
  return [self isYES];
}

- (BOOL)isShowTableOptions
{
  return !_answer.answer || [_answer.answer isEmpty];
}

- (void)layoutSubviews
{
  _alignTopTable.constant = -10;
  [super layoutSubviews];
  if ([self isShowed] && [self isOptions]) {
      _alignTopTable.constant = CELL_HEIGHT;
  }
}

#pragma =========== UIS==================
- (void)showAnswerTextArea
{
  self.answerTextView.hidden = NO;
  if ([_patientQuestion.patientQuestionId integerValue] == SYMPTOMS_QUESTION) {
    self.answerTextView.text = _user.currentSymptoms;
  } else if ([_patientQuestion.patientQuestionId integerValue] == TREATMENT_QUESTION) {
    self.answerTextView.text = _user.currentTreatment;
  }
  self.yesButton.hidden = YES;
  self.noButton.hidden = YES;
}

- (void)showAnswerTextField
{
  self.answerText.placeholder = _patientQuestion.extraQuestion.question;
  self.answerText.text = _answer.answer;
  self.answerText.hidden = NO;
}

- (void)showAnswerOptions
{
  self.answerContainer.hidden = NO;
  if ([self isShowTableOptions]) {
    [self showOptionSelect];
  } else {
    [self showOptionResult];
  }
}

- (void)showOptionResult
{
  [self.selectedAnswer setTitle:_answer.answer forState:UIControlStateNormal];
  self.tableView.hidden = YES;
  self.selectedAnswer.selected = YES;
}

- (void)showOptionSelect
{
  [self.selectedAnswer setTitle:@"Select Answer" forState:UIControlStateNormal];
  [self.tableView reloadData];
  self.tableView.hidden = NO;
  self.selectedAnswer.selected = NO;
}

- (void)decorateUIs
{
  self.questionText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.answerText.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.answerTextView.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  [self.answerTextView decorateEclipseWithRadius:3];
  [self.answerTextView decorateBorder:1 andColor:[UIColor lightGrayColor]];
  self.selectedAnswer.titleLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  self.selectedAnswer.backgroundColor = [UIColor ringWhiteColor];
  [self.selectedAnswer setTitleColor:[UIColor ringOrangeColor] forState:UIControlStateSelected];
  [self.selectedAnswer setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  //custom color here
  self.answerText.backgroundColor = [UIColor colorWithRed:0.902 green:0.906 blue:0.91 alpha:1];
  self.answerText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
  self.answerText.leftViewMode = UITextFieldViewModeAlways;
  [self.answerText decorateEclipseWithRadius:3];
  [self.answerText decorateBorder:0.5 andColor:[UIColor ringMainColor]];

  
  self.tableView.separatorInset = UIEdgeInsetsZero;
  [self.answerContainer decorateEclipseWithRadius:3];
  [self.answerContainer decorateBorder:0.5 andColor:[UIColor ringMainColor]];
}

#pragma =========== UPDATE VALUE==================

- (void)updateValues
{
  self.yesButton.hidden = NO;
  self.noButton.hidden = NO;
  self.questionText.text = self.patientQuestion.question;
  self.answerText.hidden = YES;
  self.answerContainer.hidden = YES;
  self.noButton.selected = NO;
  self.yesButton.selected = NO;
  self.tableView.hidden = YES;
  self.answerTextView.hidden = YES;
  
  if (_answer) {
    [self updateAnswerValues];
  }
}

- (void)updateAnswerValues
{
  if ([self isYES]) {
    self.noButton.selected = NO;
    self.yesButton.selected = YES;
    [self updateValueDetails];
  } else {
    self.yesButton.selected = NO;
    self.noButton.selected = YES;
  }
}

- (void)updateValueDetails
{
  if ([self isTextAnswer]) {
    [self showAnswerTextField];
  } else if ([self isOptions]) {
    [self showAnswerOptions];
  } else if ([self isTextAreaAnswer]) {
    [self showAnswerTextArea];
  }
}

#pragma =========== BUTTON ACTION ==================

- (IBAction)selectOptionPressed:(UIButton *)sender {
  NSLog(@"selectOptionPressed (??)");
  if (sender.selected) {
    _answer.answer = _answer.lastAnswer;
  } else {
    _answer.lastAnswer = _answer.answer;
    _answer.answer = @"";
  }
  [self.delegate refreshTableKeepOpenAtIndex:_index];
}

- (IBAction)noPressed:(UIButton *)sender {
  NSLog(@"Setting %@ to NO", self.patientQuestion);
  if (!_answer) {
    _answer = [self.user createAnswer:NO forQuestion:self.patientQuestion];
  }
  _answer.value = @(NO);
  [self.delegate refreshTableKeepOpenAtIndex:_index];
}

- (IBAction)yesPressed:(UIButton *)sender {
  NSLog(@"Setting %@ to YES", self.patientQuestion);
  if (!_answer) {
    _answer = [self.user createAnswer:YES forQuestion:self.patientQuestion];
  }
  _answer.value = @(YES);
  [self.delegate refreshTableKeepOpenAtIndex:_index];
}

#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self isShowed] && [self isOptions]) {
    return [_patientQuestion.extraQuestion.options count];
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return OPTION_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"answerCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  }
  NSString *value = [_patientQuestion.extraQuestion.options objectAtIndex:indexPath.row];
  cell.textLabel.text = value;
  if ([value isEqualToString:_answer.answer]) {
    self.textLabel.textColor = [UIColor ringOrangeColor];
  } else {
    self.textLabel.textColor = [UIColor blackColor];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  _answer.answer = _patientQuestion.extraQuestion.options[indexPath.row];
//  [self showOptionSelect];
  [self.delegate refreshTableKeepOpenAtIndex:_index];
}

+ (CGFloat)heightForCellWithUser:(RingUser *)user question:(RingPatientQuestion *)question
{
  RingPatientAnswer *answer = [RingPatientAnswer findByPatientQuestionId:question.patientQuestionId forUser:user];
  if (answer && [answer.value boolValue])
  {
    if ([question.extraQuestion.type isEqualToString:@"text"]) {
      return CELL_HEIGHT * 2;
    } else if ([question.extraQuestion.type isEqualToString:@"option"]) {
      if (!answer.answer || [answer.answer isEmpty]) {
        return ([question.extraQuestion.options count] + 1) * OPTION_HEIGHT + CELL_HEIGHT + 10;
      }
      return 2 * CELL_HEIGHT + 2;

    } else if ([question.extraQuestion.type isEqualToString:@"text_area"]) {
      return CELL_HEIGHT * 4;
    }
  }
  return CELL_HEIGHT;
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  _answer.answer = textField.text;
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  _answer.answer = textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.delegate scrollToIndex:self.index];
}

#pragma mark --UITextViewDeleate
- (void)textViewDidChange:(UITextView *)textView
{
  if ([_patientQuestion.patientQuestionId integerValue] == SYMPTOMS_QUESTION) {
    _user.currentSymptoms = textView.text;
  } else if ([_patientQuestion.patientQuestionId integerValue] == TREATMENT_QUESTION) {
    _user.currentTreatment = textView.text;
  }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self.delegate scrollToIndex:self.index];
}
@end
