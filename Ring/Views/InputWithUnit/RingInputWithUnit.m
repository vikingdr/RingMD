//
//  RingInputWithUnit.m
//  RingNative
//
//  Created by Medpats on 6/19/2557 BE.
//  Copyright (c) 2557 RingNative. All rights reserved.
//

#import "RingInputWithUnit.h"

#import "Ring-Essentials.h"

#define UNIT_WIDTH 50

@interface RingInputWithUnit() {
 NSInteger currentUnitIndex;
 NSInteger currentNumberIndex;
}
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *unit;
@property (strong, nonatomic) UIButton *firstText;
@property (strong, nonatomic) UIView *pickerContainer;
@end

@implementation RingInputWithUnit

- (UIButton *)firstText
{
  if (!_firstText) {
    _firstText = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstText.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_firstText];
    [_firstText addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    _firstText.titleLabel.font = [UIFont ringFontOfSize:14];
    [_firstText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _firstText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _firstText.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
  }
  return _firstText;
}

- (UITextField *)textField
{
  if (!_textField) {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - UNIT_WIDTH, self.frame.size.height)];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
  }
  return _textField;
}

- (UILabel *)unit
{
  if (!_unit) {
    _unit = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - UNIT_WIDTH, 0, UNIT_WIDTH, self.frame.size.height)];
    _unit.textAlignment = NSTextAlignmentLeft;
  }
  return _unit;
}

- (UIPickerView *)pickerView
{
  if (!_pickerView) {
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [RingUtility currentWidth], PICKER_HEIGHT)];
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
  }
  return _pickerView;
}

- (UIView *)pickerContainer
{
  if (!_pickerContainer) {
    NSInteger buttonHeight = 44;
    NSInteger buttonWidth = 80;
    _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [RingUtility currentHeight] - PICKER_HEIGHT - buttonHeight, [RingUtility currentWidth], PICKER_HEIGHT + buttonHeight)];
    CGRect frame = self.pickerView.frame;
    frame.origin.y = buttonHeight;
    self.pickerView.frame = frame;
    [_pickerContainer addSubview:self.pickerView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(frame.size.width - buttonWidth, 5, buttonWidth, buttonHeight - 10);
    [button addTarget:self action:@selector(pickerActionDone) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont ringFontOfSize:14];
    
    [_pickerContainer addSubview:button];
    _pickerContainer.backgroundColor = [UIColor whiteColor];
    _pickerContainer.hidden = YES;
    [_pickerContainer decorateBorder:1 andColor:[UIColor lightGrayColor]];
    UIView *separate = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight, self.pickerView.frame.size.width, 1)];
    separate.backgroundColor = [UIColor lightGrayColor];
    [_pickerContainer addSubview:separate];
  }
  return _pickerContainer;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self updateUIs];
  self.minimumValue = 1;
}

- (void)showPicker
{
  self.textField.hidden = NO;
  self.unit.hidden = NO;
  self.pickerContainer.hidden = NO;
  self.firstText.hidden  = YES;
}

- (void)showFirstText:(NSString *)text
{
  [self.firstText setTitle:text forState:UIControlStateNormal];
  self.textField.hidden = YES;
  self.unit.hidden = YES;
}

- (void)pickerActionDone
{
  self.pickerContainer.hidden = YES;
}

- (NSNumber *)currentNumber
{
  return [self numberForIndex:currentNumberIndex];
}

- (NSNumber *)numberForIndex:(NSInteger )index
{
  NSArray *numbers = [self currentNumbers];
  if ([numbers count] == 0) {
    return @(index + self.minimumValue);
  }
  return [numbers objectAtIndex:index];
}

- (NSString *)currentUnit
{
  if (!self.units) {
    return @"";
  }
  return self.units[currentUnitIndex];
}

- (void)refreshPickerView;
{
  [self.pickerView reloadAllComponents];
  self.textField.text = [[self numberForIndex:0] stringValue];
  self.unit.text = self.units[0];
}

- (void)showPickerInView:(UIView *)view
{
  [view addSubview:self.pickerContainer];
}

- (void)updateUIs
{
  [self addSubview:self.textField];
  [self addSubview:self.unit];
  self.textField.font = [UIFont ringFontOfSize:14];
  self.unit.font = [UIFont ringFontOfSize:14];
  self.textField.textColor = [UIColor orangeColor];
  self.unit.textColor = [UIColor orangeColor];
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  self.pickerContainer.hidden = NO;
  return NO;
}

#pragma mark --UIPickerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 2;
}

- (NSArray *)currentNumbers
{
  if (!self.units) {
    return @[];
  }
  NSString *key = self.units[currentUnitIndex];
  return [self.numberMaps objectForKey:key];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (component ==  0) {
    if ([[self currentNumbers] count] == 0) {
      return 1000;
    }
    return [[self currentNumbers] count];
  } else {
    return [self.units count];
  }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if (component == 0) {
    return [[self numberForIndex:row] stringValue];
  } else {
    return [self.units objectAtIndex:row];
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if (component ==  0) {
    self.textField.text = [[self numberForIndex:row] stringValue];
    currentNumberIndex = row;
  } else {
    self.unit.text = self.units[row];
    currentUnitIndex = row;
  }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel *label = [[UILabel alloc] init];
  label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  label.textColor = [UIColor ringOrangeColor];
  label.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor whiteColor];
  return label;
}
@end
