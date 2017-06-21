//
//  YMAToDoListViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 17.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAToDoListViewController.h"
#import "YMATaskList.h"
#import "YMATaskTableViewCell.h"
#import "YMATask.h"
#import "YMADateHelper.h"
#import "YMAAddTaskViewController.h"
#import "YMATaskService.h"
#import "YMAConstants.h"

@interface YMAToDoListViewController () <YMAAddTaskViewControllerDelegate>

@property(assign, nonatomic, getter=isAscending) BOOL ascending;

@end

@implementation YMAToDoListViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:YMATaskTableViewCellNibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:YMATaskTableViewCellNibName];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (IBAction)addTapped:(id)sender {
    YMAAddTaskViewController
        *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    addTaskVC.delegate = self;
    [self showViewController:addTaskVC sender:nil];
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
    YMATask *movedTask = self.tasks.tasks[(NSUInteger) fromIndexPath.row];
    [self.tasks removeTaskFromList:movedTask];
    [self.tasks insertTask:movedTask atIndex:(NSUInteger) toIndexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMATaskTableViewCellNibName];
    YMATask *task = self.tasks.tasks[(NSUInteger) indexPath.row];
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController
        *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    editTaskVC.listIndex = (NSUInteger) indexPath.section;
    editTaskVC.delegate = self;
    editTaskVC.task = self.tasks.tasks[(NSUInteger) indexPath.row];
    [self showViewController:editTaskVC sender:nil];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task
    YMATask *task = self.tasks.tasks[(NSUInteger) indexPath.row];
    UITableViewRowAction *doneAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Done" handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {

          [task finishTask];
          [self.tableView setEditing:NO];
        }];
    //delete tapped
    UITableViewRowAction *deleteAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {
          //alert
          UIAlertController *alertViewController =
              [UIAlertController alertControllerWithTitle:@"Do you want to remove item?" message:nil preferredStyle:UIAlertControllerStyleAlert];

          UIAlertAction
              *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
          [alertViewController addAction:cancelAction];
          UIAlertAction *deleteAction =
              [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [self.tasks removeTaskFromList:task];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
              }];
          [alertViewController addAction:deleteAction];

          [self presentViewController:alertViewController animated:YES completion:nil];
        }];
    if (task.isTaskFinished) {
        return @[deleteAction];
    } else {
        return @[deleteAction, doneAction];
    }
}

@end
