//
//  YMAInboxViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAInboxViewController.h"
#import "YMATaskService.h"
#import "YMATask.h"
#import "YMATaskList.h"
#import "YMATaskTableViewCell.h"
#import "YMADateHelper.h"
#import "YMAConstants.h"

@interface YMAInboxViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) YMATaskService *taskService;
@property(strong, nonatomic) NSMutableArray *tasksForTableView;
@property(assign, nonatomic, getter=isAscending) BOOL ascending;

@end

@implementation YMAInboxViewController

#pragma mark - View lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskService = [YMATaskService sharedInstance];
    UINib *cellNib = [UINib nibWithNibName:YMATaskTableViewCellNibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:YMATaskTableViewCellNibName];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.ascending = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self segmentControllerTapped:self.segmentedControl];
}

- (IBAction)segmentControllerTapped:(UISegmentedControl *)sender {

    if ([YMATaskService.sharedInstance allTasks].count >0) {

        if (sender.selectedSegmentIndex == 0) {
            //sort array
            NSMutableArray *allTasks = [[self.taskService allTasks] mutableCopy];
            NSSortDescriptor
                *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:startDateFieldName ascending:self.isAscending];
            [allTasks sortUsingDescriptors:@[sortDescriptor]];

            self.tasksForTableView = [NSMutableArray new];
            int section = 0;
            YMATaskList *taskListFirstSection = [YMATaskList new];
            //Adding first section
            taskListFirstSection.name =
                [YMADateHelper stringFromDate:[(YMATask *) allTasks[(NSUInteger) section] startDate]];
            [self.tasksForTableView addObject:taskListFirstSection];

            for (NSUInteger i = 0; i < allTasks.count - 1; i++) {
                YMATask *firstObject = allTasks[i];
                YMATask *secondObject = allTasks[i+1];

                NSString *firstDate = [YMADateHelper stringFromDate:firstObject.startDate];
                NSString *secondDate = [YMADateHelper stringFromDate:secondObject.startDate];

                YMATaskList *taskListSection = self.tasksForTableView[(NSUInteger) section];

                if (![taskListSection.tasks containsObject:firstObject]) {
                    [taskListSection addTask:firstObject];
                }
                if (![firstDate isEqualToString:secondDate]) {
                    YMATaskList *taskList = [YMATaskList new];
                    taskList.name = [YMADateHelper stringFromDate:[secondObject startDate]];
                    [taskList addTask:secondObject];
                    [self.tasksForTableView addObject:taskList];
                    section++;
                }
            }
            //add last task in last section
            YMATaskList *tasks = self.tasksForTableView[(NSUInteger) section];
            [tasks addTask:allTasks[allTasks.count-1]];
        } else {
            self.tasksForTableView = [self.taskService.taskLists mutableCopy];
            NSSortDescriptor
                *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nameFieldName ascending:self.isAscending];
            [self.tasksForTableView sortUsingDescriptors:@[sortDescriptor]];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table View Delegate

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
    YMATaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMATaskTableViewCellNibName];
    YMATask *task = [self taskFromTableViewTasks:indexPath];
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) indexPath.section];
    YMATask *task = tasks.tasks[(NSUInteger) indexPath.row];
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
                [self.taskService removeTaskFromAllList:task];
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

#pragma mark - Actions

- (IBAction)sortTable:(id)sender {
    self.ascending = !self.ascending;
    [self segmentControllerTapped:self.segmentedControl];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController
        *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    editTaskVC.delegate = self;
    editTaskVC.task = [self taskFromTableViewTasks:indexPath];
    [self showViewController:editTaskVC sender:nil];
}

- (IBAction)addTapped:(id)sender {
    YMAAddTaskViewController
        *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:YMAAddTaskViewControllerIdentifier];
    addTaskVC.delegate = self;
    [self showViewController:addTaskVC sender:nil];
}

#pragma mark - Delegate

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index {
    //add in default group in index 0
    NSArray *allTask = [YMATaskService.sharedInstance allTasks];
    if (NSNotFound == [allTask indexOfObject:task]) {
        //add new task
        [YMATaskService.sharedInstance incomingTask:task intexOfList:indexForInboxSection];
    }
}

- (YMATask *)taskFromTableViewTasks:(NSIndexPath *)indexPath {
    YMATaskList *tasks = self.tasksForTableView[(NSUInteger) indexPath.section];
    YMATask *task = tasks.tasks[(NSUInteger) indexPath.row];
    return task;
}

@end
