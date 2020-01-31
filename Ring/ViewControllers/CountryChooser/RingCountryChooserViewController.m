//
//  RingCountryChooserViewController.m
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 04/09/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingCountryChooserViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Swift.h"

#import "UIViewController+Utility.h"
#import "RingCountry+Utility.h"

@interface RingCountryChooserViewController ()<UITableViewDataSource, UITableViewDelegate> {
  NSArray *_countries;
}

@property (nonatomic, retain) UITableView *view;

@end

@implementation RingCountryChooserViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view = [UITableView new];
  self.view.dataSource = self;
  self.view.delegate = self;
  
  _countries = [RingCountry all];
  if (_countries.count == 0) {
    [RingCountry pullCountriesWithSuccess:^(NSArray *countries) {
      _countries = countries;
      [self.view reloadData];
      [self didShowData];
    }];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  if(_countries.count > 0) {
    [self didShowData];
  }
}

- (void)didShowData
{
  ASSERT_MAIN_LOOP;
  
  // First try basing the selection on the selected prefix
  
  NSString *selection = [self.delegate selectedCountry];
  
  NSUInteger idx = 0;
  for (; idx < _countries.count; idx++) {
    if([((RingCountry *)_countries[idx]).name isEqualToString:selection]) {
      [self.view selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
      return;
    }
  }
  
  // If the above fails then use location detection
  
  __block RingCountryChooserViewController *weakSelf = self;
  
  [[Locator sharedLocator] obtainLocation:^(NSString *country) {
    if(weakSelf) {
      NSUInteger idx = 0;
      for (; idx < _countries.count; idx++) {
        if([((RingCountry *)_countries[idx]).name containsString:country]) {
          [self.view selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
          break;
        }
      }
    }
  }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *ident = @"CountryChooser";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
  }
  
  assert(indexPath.row < _countries.count);
  cell.textLabel.text = ((RingCountry *)_countries[indexPath.row]).name;
  
  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  assert(indexPath.row < _countries.count);
  [self.delegate didSelectcountry:_countries[indexPath.row]];
  [self dismissPopup:tableView];
}

@end
