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
#import "YMAAddTaskViewController.h"
#import "YMAConstants.h"

@interface YMASearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property(nonatomic, strong) UISearchController *searchController;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, assign, getter=isShowOnlyCompleted) BOOL showOnlyCompleted;
@property(strong, nonatomic) NSMutableArray *tasksForTableView;

@end

@implementation YMASearchViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.scopeButtonTitles = @[@"Active tasks", @"Completed"];
    [self.searchController becomeFirstResponder];

    UINib *cellNib = [UINib nibWithNibName:YMATaskTableViewCellNibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:YMATaskTableViewCellNibName];

    self.tableView.tableHeaderView = self.searchController.searchBar;
    UITapGestureRecognizer
        *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

#pragma mark UI

//show - NO RESULT
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (self.tasksForTableView.count > 0) {
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
#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.showOnlyCompleted = [@(self.searchController.searchBar.selectedScopeButtonIndex) boolValue];
    NSPredicate *predicate;
    if (self.isShowOnlyCompleted) {
        predicate =
            [NSPredicate predicateWithFormat:@"self.name contains[cd] %@ and self.isTaskFinished == YES", self.searchController.searchBar.text];
    } else {
        predicate =
            [NSPredicate predicateWithFormat:@"self.name contains[cd] %@ and self.isTaskFinished == NO", self.searchController.searchBar.text];
    }
    self.tasksForTableView = [NSArray arrayWithArray:[[YMATaskService.sharedInstance allTasks] filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksForTableView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATask *task = self.tasksForTableView[indexPath.row];
    YMATaskTableViewCell *cell = [YMATaskTableViewCell idequeueReusableCellWithTask:task tableView:self.tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController
        *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMATaskTableViewCellIdentifier];
    editTaskVC.listIndex = (NSUInteger) indexPath.section;
    editTaskVC.task = self.tasksForTableView[indexPath.row];
    [self showViewController:editTaskVC sender:nil];
}

#pragma mark - Actions

- (void)dismissKeyboard {
    [self.searchController.searchBar resignFirstResponder];
}

@end
