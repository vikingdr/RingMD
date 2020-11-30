//
//  RingCountryCodeViewController.m
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 15/09/14.
//  Copyright (c) 2014 Matthew James All rights reserved.
//

#import "RingCountryCodeViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

#import "RingCountryCodeHelper.h"

@interface RingCountryCodeViewController () {
  NSArray *_titles;
  NSArray *_countryCodes;
}

@end

@implementation RingCountryCodeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  RingCountryCodeHelper *helper = [RingCountryCodeHelper sharedInstance];
  _titles = helper.allCountries;
  _countryCodes = helper.allCodes;
}

- (void)viewDidAppear:(BOOL)animated
{
  [self didShowData];
}

- (void)didShowData
{
  // First try basing the selection on the selected prefix
  
  NSString *prefix = [self.delegate selectedCountryCode];
  
  NSUInteger idx = 0;
  for (; idx < _countryCodes.count; idx++) {
    if([_countryCodes[idx] isEqualToString:prefix]) {
      [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
      return;
    }
  }
  
  // If the above fails then use location detection
  
  __block RingCountryCodeViewController *weakSelf = self;
  
  [[Locator sharedLocator] obtainLocation:^(NSString *country) {
    if(weakSelf) {
      NSUInteger idx = 0;
      for (; idx < _titles.count; idx++) {
        if([_titles[idx] containsString:country]) {
          [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
          break;
        }
      }
    }
  }];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.delegate didSelectCountryCode:_countryCodes[indexPath.row]];
  [self dismissPopup:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellID = @"RingCountryCodeViewCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  
  cell.textLabel.text = _titles[indexPath.row];
  
  return cell;
}

@end
