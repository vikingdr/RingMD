//
//  RingPickRequestDateViewController.m
//  Ring
//
//  Created by Medpats on 5/14/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingPickRequestDateViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "NSArray+Compare.h"
#import "RDVCalendarView.h"
#import "RDVCalendarDayCell.h"

#define SELECTED_CELL_ID @"selected_cell"
#define duration @(30)
#define HEADER_HEIGHT 30

@interface RDVCalendarView (InitWithCoder)
- (id)initWithCoder:(NSCoder *)aDecoder;
@end

@implementation RDVCalendarView (InitWithCoder)
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  return [self initWithFrame:self.frame];
}
@end

@interface RingPickRequestDateViewController()<UIPickerViewDataSource, UIPickerViewDelegate, RDVCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet RDVCalendarView *calendarPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (strong, nonatomic) NSArray *slots;
@property (strong, nonatomic) NSArray *unavailableDates;
@property (strong, nonatomic) UIView *overlay;
@end

@implementation RingPickRequestDateViewController
- (void)setInitialDate:(NSDate *)initialDate
{
  self.slots = @[];
  _initialDate = initialDate;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.calendarPicker.delegate = self;
  
  [self decorateUIs];
}

- (void)viewWillAppear:(BOOL)animated
{
  assert(self.initialDate != nil);
  [self loadUnavailalbeDatesWithDate:self.initialDate];
  [self.calendarPicker setSelectedDate:self.initialDate];
  [self loadDate:self.initialDate];
}

- (void)loadUnavailalbeDatesWithDate:(NSDate *)date
{
  [self.doctor loadUnavailableDates:date andSuccess:^(NSArray *dates) {
    self.unavailableDates = dates;
    [self refreshCalendar];
  }];
}

- (void)decorateUIs
{
  [_calendarPicker setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
  _calendarPicker.separatorColor = [UIColor ringOrangeColor];
  self.calendarPicker.currentDayColor = [UIColor ringMainColor];
  self.calendarPicker.selectedDayColor = [UIColor ringOrangeColor];
  [self.calendarPicker.backButton setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
  [self.calendarPicker.forwardButton setTitleColor:[UIColor ringMainColor] forState:UIControlStateNormal];
}

- (void)refreshCalendar
{
  [self.calendarPicker reloadData];
}

- (void)reloadTimePicker:(NSDate *)previousDate
{
  [self.timePicker reloadAllComponents];
  
  NSInteger idx = 0;
  NSDate *date;
  for(; idx < self.slots.count; idx++) {
    date = ((RingBusyHour *)self.slots[idx]).from;
    NSInteger minsPastMidnight1 = [date hourValue] * 60 + [date minuteValue];
    NSInteger minsPastMidnight2 = [previousDate hourValue] * 60 + [previousDate minuteValue];
    
    if(minsPastMidnight1 >= minsPastMidnight2) {
      break;
    }
  }
  
  [self.timePicker selectRow:idx inComponent:0 animated:YES];
  [self.dateDelegate pickRequestDateViewController:self.timePicker dateChanged:date];
}

- (void)loadDate:(NSDate *)date
{
  NSDate *previousDate = self.slots.count == 0 ? self.initialDate : ((RingBusyHour *)(self.slots[[self.timePicker selectedRowInComponent:0]])).from;
  
  [self.doctor loadSlotInDate:date withDuration:duration selectedDates:self.selectedSlots andSuccess:^(NSArray *results) {
    self.slots = results;
    
    if ([self.slots count] == 0) {
      [UIViewController showMessage:@"Sorry. This date turns out not to work after all. Please try again or email support@ring.md for assistance." withTitle:@"Unknown Error"];
      [self.timePicker reloadAllComponents];
    } else {
      [self reloadTimePicker:previousDate];
    }
  }];
}

#pragma mark - Calendar delegate and dataSource
- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{
  [self loadDate:[calendarView dateForIndex:index]];
}

- (BOOL)calendarView:(RDVCalendarView *)calendarView shouldSelectCellAtIndex:(NSInteger)index
{
  NSDate *date = [calendarView dateForIndex:index];
  if ([date compare:[NSDate date]] != NSOrderedDescending) {
    return NO;
  }
  return ![self.unavailableDates containsNumber:@([date dayValue])];
}

- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index
{
  dayCell.backgroundView.backgroundColor = dayCell.textLabel.backgroundColor = [UIColor clearColor];
  if (![self calendarView:calendarView shouldSelectCellAtIndex:index]) {
    dayCell.textLabel.textColor = [UIColor redColor];
    dayCell.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  } else {
    dayCell.textLabel.textColor = [UIColor blackColor];
    dayCell.textLabel.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  }
}

- (void)calendarView:(RDVCalendarView *)calendarView didChangeMonth:(NSDateComponents *)month
{
  NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:month];
  [self loadUnavailalbeDatesWithDate:date];
}

#pragma mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [self.slots count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel *myView = [[UILabel alloc] init];
  myView.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  myView.font = [UIFont boldRingFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  myView.textAlignment = NSTextAlignmentCenter;
  return myView;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  RingBusyHour *timeslot = [self.slots objectAtIndex:row];
  return [timeslot.from hourFormat];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  RingBusyHour *timeslot = [self.slots objectAtIndex:row];
  [self.dateDelegate pickRequestDateViewController:self dateChanged:timeslot.from];
}
@end
