//
//  RingMedicalSchoolSearchViewController.m
//  Ring
//
//  Created by Medpats on 3/24/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingMedicalSchoolSearchViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

@interface RingMedicalSchoolSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *medicalSchools;
@end

@implementation RingMedicalSchoolSearchViewController

- (instancetype)init
{
  return [[RingMedicalSchoolSearchViewController alloc] initWithNibName:@"MedicalSearchViewController" bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  if(self.implicitSchool == nil) {
    [self searchBar:nil textDidChange:@""];
  } else {
    self.searchBar.text = self.implicitSchool;
  }
  [self.searchBar becomeFirstResponder];
}

#pragma mark --SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  BOOL hadImplicitSchool = self.implicitSchool != nil;
  
  self.implicitSchool = searchText.length > 0 ? searchText : nil;
  
  if(hadImplicitSchool && self.implicitSchool != nil) {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else if(hadImplicitSchool) {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else if(self.implicitSchool != nil) {
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  
  [RingMedicalSchool searchMedicalSchoolsWithText:searchText andSuccess:^(NSArray *results) {
    for(RingMedicalSchool *school in results) {
      if([self.implicitSchool isEqualToString:school.name]) {
        self.implicitSchool = nil;
        break;
      }
    }
    
    self.medicalSchools = results;
    [self.tableView reloadData];
  }];
}

#pragma mark --UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.medicalSchools count] + (self.implicitSchool == nil ? 0 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger idx = indexPath.row - (self.implicitSchool == nil ? 0 : 1);
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medical"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"medical"];
  }
  cell.textLabel.text = idx == -1 ? self.implicitSchool : [self.medicalSchools[idx] name];
  cell.textLabel.textColor = idx == -1 ? [UIColor ringOrangeColor] : [UIColor ringLightMainColor];
  cell.textLabel.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger idx = indexPath.row - (self.implicitSchool == nil ? 0 : 1);
  
  [self.delegate didSelectMedicalSchool:idx == -1 ? self.implicitSchool : ((RingMedicalSchool *)self.medicalSchools[idx]).name];
  [self dismissPopup:tableView];
}
@end