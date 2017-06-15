//
//  YMASearchViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMASearchViewController.h"
#import "YMATaskService.h"
#import "YMATaskTableViewCell.h"
#import "YMATask.h"
#import "YMADateHelper.h"

@interface YMASearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *tasks;
@property (nonatomic, strong) NSArray *resultOfSearch;
@property (nonatomic, assign, getter=isShowOnlyCompleted) BOOL showOnlyCompleted;



@end

@implementation YMASearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.searchBar.delegate = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.scopeButtonTitles = @[@"All tasks", @"Completed"];


  UINib *cellNib = [UINib nibWithNibName:@"YMATaskTableViewCell" bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:@"YMATaskTableViewCell"];

  self.tableView.tableHeaderView = self.searchController.searchBar;
}

-(void)viewWillAppear:(BOOL)animated {
    YMATaskService *taskService = [YMATaskService sharedInstance];
    self.tasks = [taskService allTasks];
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.showOnlyCompleted = [@(self.searchController.searchBar.selectedScopeButtonIndex) boolValue];
  NSPredicate *predicate;

    if (self.isShowOnlyCompleted) {
       predicate = [NSPredicate predicateWithFormat:@"self.name contains[cd] %@ and self.isTaskFinished == YES", self.searchController.searchBar.text];
    }
  else{
      predicate = [NSPredicate predicateWithFormat:@"self.name contains[cd] %@", self.searchController.searchBar.text];
    }

  self.resultOfSearch = [NSArray arrayWithArray:[self.tasks filteredArrayUsingPredicate:predicate]];

  NSLog(@"bool is: %@", self.showOnlyCompleted ? @"YES" : @"NO");

  [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.resultOfSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YMATaskTableViewCell"];
  
    YMATask *task = self.resultOfSearch[(NSUInteger) indexPath.row];
    
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
}


@end
