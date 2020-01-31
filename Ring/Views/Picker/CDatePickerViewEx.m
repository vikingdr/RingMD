//
//  CDatePickerViewEx.m
//  Ring
//
//  Created by Medpats on 12/6/2556 BE.
//  Copyright (c) 2556 Medpats Global Pte. Ltd. All rights reserved.
//
#import "CDatePickerViewEx.h"

#import "Ring-Essentials.h"

// Identifiers of components
#define MONTH ( 0 )
#define YEAR ( 1 )


// Identifies for component views
#define LABEL_TAG 43


@interface CDatePickerViewEx()

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

-(NSArray *)nameOfYears;
-(NSArray *)nameOfMonths;
-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;
@end

@implementation CDatePickerViewEx

const NSInteger bigRowCount = 1000;
const CGFloat rowHeight = 44.f;
const NSInteger numberOfComponents = 2;

@synthesize months;
@synthesize years = _years;
@synthesize date = _date;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initComponents];
  }
  return self;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self initComponents];
}

- (void)initComponents
{
  self.months = [self nameOfMonths];
  self.years = [self nameOfYears];
  self.delegate = self;
  self.dataSource = self;
  [self selectToday];
}

- (NSDate *)date
{
  NSInteger monthCount = [self.months count];
  NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
  
  NSInteger yearCount = [self.years count];
  NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"MMMM:yyyy"];
  formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
  formatter.locale = [RingUtility ringLocale];
  NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
  return date;
}

- (void)setDate:(NSDate *)date
{
  [self selectRow: [self findMonthAtDate:date]
      inComponent: MONTH
         animated: NO];
  [self selectRow: [self findYearAtDate:date]
      inComponent: YEAR
         animated: NO];
  _date = date;
  [self reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
  return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
  BOOL selected = NO;
  if(component == MONTH)
  {
    NSInteger monthCount = [self.months count];
    NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
    NSString *currentMonthName = [_date monthName];
    if([monthName isEqualToString:currentMonthName] == YES)
    {
      selected = YES;
    }
  }
  else
  {
    NSInteger yearCount = [self.years count];
    NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
    NSString *currenrYearName  = [_date yearName];
    if([yearName isEqualToString:currenrYearName] == YES)
    {
      selected = YES;
    }
  }
  
  UILabel *returnView = nil;
  if(view.tag == LABEL_TAG)
  {
    returnView = (UILabel *)view;
  }
  else
  {
    returnView = [self labelForComponent: component selected: selected];
  }
  
  returnView.textColor = [UIColor whiteColor];
  returnView.text = [self titleForRow:row forComponent:component];
  returnView.backgroundColor = [UIColor ringMainColor];
  return returnView;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
  return rowHeight;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if(component == MONTH)
  {
    return [self bigRowMonthCount];
  }
  return [self bigRowYearCount];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  [self.pickerDelegate changeDate:[self date]];
}
#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
  return [self.months count]  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
  return [self.years count]  * bigRowCount;
}

-(CGFloat)componentWidth
{
  if(IS_IPAD)
    return [RingUtility currentWidth] / 3;
  return 106;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if(component == MONTH)
  {
    NSInteger monthCount = [self.months count];
    return [self.months objectAtIndex:(row % monthCount)];
  }
  NSInteger yearCount = [self.years count];
  return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
  CGRect frame = CGRectMake(0.f, 0.f, [self componentWidth],rowHeight);
  
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = selected ? [UIColor ringMainColor] : [UIColor blackColor];
  label.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].titleFontSize];
  label.userInteractionEnabled = NO;
  
  label.tag = LABEL_TAG;
  
  return label;
}

-(NSArray *)nameOfMonths
{
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.locale = [RingUtility ringLocale];
  return [dateFormatter standaloneMonthSymbols];
}

-(NSArray *)nameOfYears
{
  NSMutableArray *years = [NSMutableArray array];
  NSInteger minYear = [NSDate currentYear];
  NSInteger maxYear = minYear + 28;
  for(NSInteger year = minYear; year <= maxYear; year++)
  {
    NSString *yearStr = [NSString stringWithFormat:@"%i", year];
    [years addObject:yearStr];
  }
  return years;
}

-(void)selectToday
{
  [self setDate:[NSDate date]];
}

- (NSInteger)findMonthAtDate:(NSDate *)date
{
  NSString *month = [date monthName];
  NSInteger index;
  for(NSString *cellMonth in self.months)
  {
    if([cellMonth isEqualToString:month])
    {
      index = [self.months indexOfObject:cellMonth];
      index = index + [self bigRowMonthCount] / 2;
      break;
    }
  }
  return index;
}

- (NSInteger)findYearAtDate:(NSDate *)date
{
  NSString *year  = [date yearName];
  NSInteger index;
  for(NSString *cellYear in self.years)
  {
    if([cellYear isEqualToString:year])
    {
      index = [self.years indexOfObject:cellYear];
      index = index + [self bigRowYearCount] / 2;
      break;
    }
  }
  return index;
}
@end
