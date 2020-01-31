//
//  RingSearchViewController.m
//  Ring
//
//  Created by Medpats on 5/7/2557 BE.
//  Copyright (c) 2557 Medpats Global Pte. Ltd. All rights reserved.
//

#import "RingSearchViewController.h"

#import "Ring-Essentials.h"
#import "Ring-Models.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "RingDoctorsCategoryViewController.h"
#import "RingDoctorProfileViewController.h"
#import "RingSpecialityCell.h"
#import "RingDoctorCell.h"
#import "RingSearchHeaderView.h"

#define CELL_ID @"doctor_cell"

@interface RingSearchViewController ()<UITextFieldDelegate, RingDoctorCellDelegate, UITableViewDataSource,  UITableViewDelegate>
{
  NSInteger showAddIndex;
  BOOL isSearching;
  NSString *searchTerm;
  NSInteger pageNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) RingSearchHeaderView *searchHeader;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *doctors;
@end

@implementation RingSearchViewController

- (IBAction)searchIconTapped:(id)sender
{
  [self.searchTextField becomeFirstResponder];
}

- (RingSearchHeaderView *)searchHeader
{
  if (!_searchHeader) {
    _searchHeader = [RingSearchHeaderView initRingSeachHeader];
  }
  return _searchHeader;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initTableView];
  [self updateUIs];
  [self loadData];
  showAddIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self observeEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self unObserveEvents];
}

- (void)observeEvents
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:ME_userStatusChanged object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.searchTextField];
}

- (void)unObserveEvents
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUIs
{
  self.searchTextField.textColor = [UIColor ringLightMainColor];
  self.searchTextField.font = [UIFont ringFontOfSize:[RingConfigConstant sharedInstance].textFontSize];
}

- (void)reload
{
  self.categories = [RingSpeciality allNonEmpty];
  [self.tableView reloadData];
}

- (void)initTableView
{
  [self.tableView addInfiniteScrollingWithActionHandler:^{
    [self loadNextSearchResults];
  }];
  self.tableView.showsInfiniteScrolling = NO;
  
  self.tableView.backgroundColor = [UIColor ringWhiteColor];
  [self.tableView registerNib:[UINib nibWithNibName:@"DoctorCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
  [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  [self reload];
}

- (void)loadData
{
  [RingSpeciality pullSpecialitiesWithSuccess:^(NSArray *categoies) {
    [self reload];
  }];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return isSearching ? 75 : 41;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return isSearching ? 0.001f : 41;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return isSearching? [self.doctors count] : [self.categories count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if (isSearching) {
    return nil;
  }
  return [self searchHeader];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (isSearching) {
    RingDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    cell.user = self.doctors[indexPath.row];
    cell.delegate = self;
    return cell;
  } else {
    RingSpecialityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specialityCell"];
    cell.speciality = self.categories[indexPath.row];
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.001f;
}

#pragma mark --TableViewDataSourceDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (isSearching) {
    RingDoctorProfileViewController *doctorDetail = (RingDoctorProfileViewController *)[RingUtility getViewControllerWithName:@"doctorProfile"];
    doctorDetail.doctor = self.doctors[indexPath.row];
    [self.navigationController pushViewController:doctorDetail animated:YES];
  } else {
    RingDoctorsCategoryViewController *viewController = (RingDoctorsCategoryViewController*)[RingUtility getViewControllerWithName:@"doctors"];
    viewController.speciality = self.categories[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mard -- searchTextChanged
- (void)searchTextFieldDidChange:(NSNotification *)notif
{
  isSearching = ![self.searchTextField.text isEmpty];
  self.tableView.showsInfiniteScrolling = isSearching;
  if (!isSearching) {
    [self.tableView reloadData];
    return;
  }
  
  _doctors = [NSMutableArray new];
  searchTerm = self.searchTextField.text;
  pageNumber = 0;
  [self loadNextSearchResults];
}

- (void)loadNextSearchResults
{
  pageNumber++;
  [RingUser searchDoctorsWithText:searchTerm
                       pageNumber:pageNumber
                          proceed:^(NSArray *doctors) {
                            [_doctors addObjectsFromArray:doctors];
                            [self.tableView reloadData];
                            [self.tableView.infiniteScrollingView stopAnimating];
                            
                            if(doctors.count < perPage) {
                              self.tableView.showsInfiniteScrolling = NO;
                            }
                          }
                        blockView:pageNumber == 1 ? self.tableView : nil];
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return NO;
}

#pragma mark -- RingDoctorCellDelegate
- (void)doctorCellRefreshUser:(RingUser *)user
{
//  showAddIndex = [self.doctors indexOfObject:user];
  [self.tableView reloadData];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
  [textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0];
  return YES;
}
@end
