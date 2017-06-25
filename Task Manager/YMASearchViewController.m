//
//  YMASearchViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMASearchViewController.h"
#import "YMATaskService.h"
#import "YMATaskList.h"

@interface YMASearchViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property(weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property(nonatomic, strong) UISearchController *searchController;

@end

@implementation YMASearchViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    //create search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.scopeButtonTitles = @[@"Active tasks", @"Completed"];
    [self.searchController becomeFirstResponder];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - Search

//tapped on scope button
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //default section
    self.tasksForTableView = [NSMutableArray new];
    //filter finished or not and search text
    NSPredicate
        *predicate = [NSPredicate predicateWithFormat:@"self.name contains[cd] %@ and self.isTaskFinished == %@",
                                                      self.searchController.searchBar.text, [NSNumber numberWithBool:self.searchController.searchBar.selectedScopeButtonIndex]];
    self.tasksForTableView[0] =
        [YMATaskList listWithTasks:[[[YMATaskService.sharedInstance allTasks] filteredArrayUsingPredicate:predicate] mutableCopy]];
    [self.tableView reloadData];
}

#pragma mark TableView Delegate

//show - NO RESULT
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    YMATaskList *tasks = self.tasksForTableView[0];
    if (tasks.count > 0) {
        numOfSections = 1;
        self.noResultLabel.hidden = YES;
        tableView.scrollEnabled = YES;
    } else {
        self.noResultLabel.hidden = NO;
        self.tableView.backgroundView = self.noResultLabel;
        tableView.scrollEnabled = NO;
    }
    return numOfSections;
}

@end
