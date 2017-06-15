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

@interface YMATodayViewController ()

@property (nonatomic, strong) YMATaskService *taskService;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMATodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskService = [YMATaskService sharedInstance];
    self.tableView.dataSource = self;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UINib *cellNib = [UINib nibWithNibName:@"YMATaskTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"YMATaskTableViewCell"];
    //filtering task service - onlky today tasks;
    [self.taskService filterAllTaskListOnTodayTask];
    
}

#pragma mark - Table View Delegate

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

//delete row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskService removeTaskFromListIndex:(NSUInteger) indexPath.section taskIndex:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

//title for section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YMATaskList *tasks = [self.taskService taskListAtIndex:(NSUInteger) section];
    return tasks.name;
}

//number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskService.taskLists.count;
}

//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMATaskList *tasks = self.taskService.taskLists[(NSUInteger) section];
    return tasks.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskTableViewCell"];
    YMATask *task =
    [self.taskService taskFromListAtIndex:(NSUInteger) indexPath.section taskIndex:(NSUInteger) indexPath.row];
    
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
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
    editTaskVC.task =
    [self.taskService taskFromListAtIndex:(NSUInteger) indexPath.section taskIndex:(NSUInteger) indexPath.row];
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
    YMATaskList *taskList = [self.taskService taskListAtIndex:index];
    [taskList incomingTask:task];
}

@end
