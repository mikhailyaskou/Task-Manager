//
//  YMABasicViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 23.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMABasicViewController.h"
#import "YMATaskService.h"
#import "YMATaskList.h"
#import "YMATaskTableViewCell.h"
#import "YMAConstants.h"
#import "YMATask.h"
#import "YMAAddTaskViewController.h"

@interface YMABasicViewController () <UITableViewDataSource, UITableViewDelegate, YMAAddTaskViewControllerDelegate>

@property(nonatomic, strong) YMATaskService *taskService;

@end

@implementation YMABasicViewController

- (YMATaskService *)taskService {
    if (!_taskService) {
        _taskService = YMATaskService.sharedInstance;
    }
    return _taskService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UINib *cellNib = [UINib nibWithNibName:YMATaskTableViewCellNibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:YMATaskTableViewCellNibName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateUi];
}

//title for section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YMATaskList *tasks = self.tasksForTableView[section];
    return tasks.name;
}

//number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tasksForTableView.count;
}

//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMATaskList *tasks = self.tasksForTableView[section];
    return tasks.tasks.count;
}

//fill the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATask *task = [self taskFromTableViewTasks:indexPath];
    YMATaskTableViewCell *cell = [YMATaskTableViewCell idequeueReusableCellWithTask:task tableView:self.tableView];
    return cell;
}

- (YMATask *)taskFromTableViewTasks:(NSIndexPath *)indexPath {
    YMATaskList *tasks = self.tasksForTableView[indexPath.section];
    YMATask *task = tasks.tasks[indexPath.row];
    return task;
}

- (void)updateUi {
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task
    YMATaskList *tasks = self.tasksForTableView[indexPath.section];
    YMATask *task = tasks.tasks[indexPath.row];
    UITableViewRowAction *doneAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Done" handler:^(
            UITableViewRowAction *_Nonnull action,
            NSIndexPath *_Nonnull indexPath) {
          [task finishTask];
          [self updateUi];
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
                //remove task from service
                [self.taskService removeTaskFromAllList:task];
                //delete task from tasksForTableView
                [tasks removeTaskFromList:task];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController
        *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    editTaskVC.delegate = self;
    editTaskVC.task = [self taskFromTableViewTasks:indexPath];
    [self showViewController:editTaskVC sender:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (IBAction)addTapped:(id)sender {
    YMAAddTaskViewController
        *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    addTaskVC.delegate = self;
    addTaskVC.listIndex = indexForInboxSection;
    [self showViewController:addTaskVC sender:nil];
}

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index {

    NSArray *allTask = [YMATaskService.sharedInstance allTasks];
    if (NSNotFound == [allTask indexOfObject:task]) {
        //add new task
        [self.taskService incomingTask:task intexOfList:indexForInboxSection];
    }
}


@end
