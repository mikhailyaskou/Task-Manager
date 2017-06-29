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
#import "YMALocalizedConstants.h"

@interface YMATaskListViewController ()

@property(nonatomic, strong) YMATaskService *taskService;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMATaskListViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskService = [YMATaskService sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - TableView Delefate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return YMANumberOfSectionsForProjectView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.taskService.taskLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *taskCell;
    if (indexPath.section == YMAIndexSectionForAddRow && indexPath.row == YMAIndexRowForAddRow) {
        taskCell = [tableView dequeueReusableCellWithIdentifier:YMAAddProjectCellIdentifier];
    } else {
        taskCell = [tableView dequeueReusableCellWithIdentifier:YMATaskListCellIdetifier];
        YMATaskList *taskList = self.taskService.taskLists[indexPath.row];
        taskCell.textLabel.text = taskList.name;
        NSInteger numberOfActiveTasks = taskList.tasks.count;
        taskCell.detailTextLabel.text = [NSString stringWithFormat:@"(%li)", (long) numberOfActiveTasks];
    }
    return taskCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == YMAIndexRowForAddRow ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task list
    YMATaskList *taskList = self.taskService.taskLists[indexPath.row];
    UITableViewRowAction *editAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:YMATitleEdit handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {
          //edit action


          UIAlertController *alertViewController =
              [UIAlertController alertControllerWithTitle:YMATitleEditProject message:nil preferredStyle:UIAlertControllerStyleAlert];
          [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = YMATitleProjectName;
            textField.text = taskList.name;
          }];
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:YMATitleChancel style:UIAlertActionStyleCancel handler:nil];
          [alertViewController addAction:cancelAction];
          UIAlertAction *OkAction =
              [UIAlertAction actionWithTitle:YMATitleOk style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
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
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:YMATitleDelete handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {
          //alert
          UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:YMATitleRemoveItem message:nil preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:YMATitleChancel style:UIAlertActionStyleCancel handler:nil];
          [alertViewController addAction:cancelAction];
          UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:YMATitleDelete style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
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
    if ([segue.identifier isEqualToString:YMAShowProjectTasksIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        YMAToDoListViewController *toDoListViewController = [segue destinationViewController];
        toDoListViewController.tasks = self.taskService.taskLists[indexPath.row];
    }
}

- (IBAction)unwindToEditViewController:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:YMADoneTappedUnwindSegueIdentifier]) {
        YMAAddTaskListViewController *taskListViewController = [unwindSegue sourceViewController];
        YMATaskList *newTaskList = [YMATaskList new];
        newTaskList.idTaskList = @(arc4random_uniform(100000));
        newTaskList.name = taskListViewController.projectNameLabel.text;
        [self.taskService addTasks:newTaskList];
    }
}

@end
