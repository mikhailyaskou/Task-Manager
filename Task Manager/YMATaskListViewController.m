//
//  YMATaskListViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskListViewController.h"
#import "YMATaskService.h"
#import "YMATaskList.h"
#import "YMAToDoListViewController.h"

@interface YMATaskListViewController ()

@property(nonatomic, strong) YMATaskService *taskService;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMATaskListViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskService = [YMATaskService sharedInstance];
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - TableView Delefate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.taskService.taskLists.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *taskCell;
    if (indexPath.section == indexSectionForAddRow && indexPath.row == indexRowForAddRow) {
        taskCell = [tableView dequeueReusableCellWithIdentifier:YMAAddProjectCellIdentifier];
    } else {
        taskCell = [tableView dequeueReusableCellWithIdentifier:YMATaskListCellIdetifier];
        YMATaskList *taskList = self.taskService.taskLists[(NSUInteger) indexPath.row];
        taskCell.textLabel.text = taskList.name;
        NSInteger numberOfActiveTasks = taskList.tasks.count; // active
        taskCell.detailTextLabel.text = [NSString stringWithFormat:@"(%li)", (long) numberOfActiveTasks];
    }
    return taskCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == indexRowForAddRow) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task list
    YMATaskList *taskList = self.taskService.taskLists[(NSUInteger) indexPath.row];
    UITableViewRowAction *editAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {
          //edit action
          UIAlertController *alertViewController =
              [UIAlertController alertControllerWithTitle:@"Edit Project?" message:nil preferredStyle:UIAlertControllerStyleAlert];
          [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Project Name";
            textField.text = taskList.name;
          }];
          UIAlertAction
              *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
          [alertViewController addAction:cancelAction];
          UIAlertAction *OkAction =
              [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                taskList.name = alertViewController.textFields[0].text;
                [self.taskService saveTasks];
                UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
                tableViewCell.textLabel.text = taskList.name;
                [self.tableView setEditing:NO];
              }];
          [alertViewController addAction:OkAction];
          [self presentViewController:alertViewController animated:YES completion:nil];
        }];

    editAction.backgroundColor = [UIColor blueColor];
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
                [self.taskService removeTasks:taskList];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
              }];
          [alertViewController addAction:deleteAction];

          [self presentViewController:alertViewController animated:YES completion:nil];
        }];
    return @[deleteAction, editAction];
}

#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:ShowProjectTasksIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        YMAToDoListViewController *toDoListViewController = [segue destinationViewController];
        toDoListViewController.tasks = self.taskService.taskLists[(NSUInteger) indexPath.row];
    }
}

- (IBAction)unwindToEditViewController:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:DoneTappedUnwindSegueIdentifier]) {
        YMAAddTaskListViewController *taskListViewController = [unwindSegue sourceViewController];
        YMATaskList *newTaskList = [YMATaskList new];
        newTaskList.idTaskList = @(arc4random_uniform(100000));
        newTaskList.name = taskListViewController.projectNameLabel.text;
        [self.taskService addTasks:newTaskList];
    }
}

@end
