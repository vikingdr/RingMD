//
//  RingCountryCodeView.m
//  
//
//  Created by Jonas De Vuyst (RingMD) on 15/09/14.
//
//

#import "RingCountryCodeView.h"

#import "Ring-Essentials.h"

#import "RingCountryCodeHelper.h"

@interface RingCountryCodeView() {
  RingCountryCodeHelper *_helper;
  NSArray *_titles;
  NSArray *_countryCodes;
}
@end

@implementation RingCountryCodeView

- (id)init
{
  self = [super init];
  
  RingCountryCodeHelper *helper = [RingCountryCodeHelper sharedInstance];
  _titles = helper.allCountries;
  _countryCodes = helper.allCodes;
  
  return self;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
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
