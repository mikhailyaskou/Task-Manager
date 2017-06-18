//
//  YMATodayViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATodayViewController.h"
#import "YMATaskService.h"
#import "YMATaskList.h"
#import "YMATaskTableViewCell.h"
#import "YMATask.h"
#import "YMADateHelper.h"
#import "YMAAddTaskViewController.h"

@interface YMATodayViewController () <UITableViewDataSource, UITableViewDelegate, YMAAddTaskViewControllerDelegate>

@property (strong, nonatomic) YMATaskList *allTasks;
@property (strong, nonatomic) NSMutableArray *tasksForTableView;
@property (strong, nonatomic) YMATaskService *taskService;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMATodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UINib *cellNib = [UINib nibWithNibName:@"YMATaskTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"YMATaskTableViewCell"];
}

- (void)updateUi {
    self.taskService = [YMATaskService sharedInstance];
    //get all task
    self.allTasks = [self.taskService getAllTasksOnToday];
    //tasks that will be displayed (two group - finished and not)
    self.tasksForTableView = [NSMutableArray new];
    //list with finished task
    YMATaskList *finishedTasks = [YMATaskList  new];
    finishedTasks.name = @"Completed";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.taskFinished == YES"];
    finishedTasks.tasks = [NSArray arrayWithArray:[self.allTasks.tasks filteredArrayUsingPredicate:predicate]];
    //list with not finished task
    YMATaskList *notFinishedTasks = [YMATaskList  new];
    predicate = [NSPredicate predicateWithFormat:@"self.taskFinished == NO"];
    notFinishedTasks.tasks = [NSArray arrayWithArray:[self.allTasks.tasks filteredArrayUsingPredicate:predicate]];
    //add in displayed array
    [self.tasksForTableView addObject:notFinishedTasks];
    [self.tasksForTableView addObject:finishedTasks];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateUi];

}


//title for section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) section];
    return tasks.name;
}

//number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tasksForTableView.count;
}

//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) section];
    return tasks.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskTableViewCell"];
    YMATaskList *taskList = self.tasksForTableView[(NSUInteger) indexPath.section];
    YMATask *task = taskList.tasks[(NSUInteger) indexPath.row];
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //done tapped.
    //get task
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) indexPath.section];
    YMATask *task = tasks.tasks[(NSUInteger) indexPath.row];
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
                //delete task from tasksForTableView
                [tasks removeTaskFromList:task];
                //remove task vorom service
                [self.taskService removeTaskFromAllList:task];
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

#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskViewController"];
    editTaskVC.listIndex = (NSUInteger) indexPath.section;
    editTaskVC.delegate = self;
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) indexPath.section];
    editTaskVC.task =   tasks.tasks[(NSUInteger) indexPath.row];
    [self showViewController:editTaskVC sender:nil];
}

- (IBAction)addTapped:(id)sender {
    YMAAddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskViewController"];
    addTaskVC.delegate = self;
    //0 is default category - Inbox
    addTaskVC.listIndex = 0;
    [self showViewController:addTaskVC sender:nil];
}

#pragma mark - Delegate

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index {

    YMATaskList *tasks = self.taskService.taskLists[(NSUInteger) index];
    if(NSNotFound == [self.allTasks.tasks indexOfObject: task]) {
        //add new task
        [tasks incomingTask:task];
    }
}

@end
