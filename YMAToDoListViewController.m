//
//  YMAToDoListViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 17.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAToDoListViewController.h"
#import "YMATaskList.h"
#import "YMATask.h"
#import "YMATaskService.h"
#import "YMAConstants.h"

@interface YMAToDoListViewController ()

@property(assign, nonatomic, getter=isAscending) BOOL ascending;

@end

@implementation YMAToDoListViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasksForTableView = [NSMutableArray new];
    self.tasksForTableView[0] = self.tasks;
    self.ascending = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title = self.tasks.name;
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)sortTable:(id)sender {
    self.ascending = !self.ascending;
    NSSortDescriptor
        *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nameFieldName ascending:self.isAscending];
    [self.tasks sortUsingDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}

#pragma mark - Delegate

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index {
    [self.tasks incomingTask:task];
    [YMATaskService.sharedInstance saveTasks];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    YMATask *movedTask = self.tasks.tasks[fromIndexPath.row];
    [self.tasks removeTaskFromList:movedTask];
    [self.tasks insertTask:movedTask atIndex:toIndexPath.row];
}

@end
