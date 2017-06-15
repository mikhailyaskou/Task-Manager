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

@interface YMATaskListViewController ()

@property (nonatomic, strong) YMATaskService *taskService;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMATaskListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
   self.taskService = [YMATaskService sharedInstance];
  self.tableView.dataSource = self;
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self.tableView reloadData];
}
- (void)incomingTaskList:(id)Sender taskList:(YMATaskList *)taskList {
  [self.taskService addTasks:taskList];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.taskService.taskLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskListCell"];

  YMATaskList *taskList = self.taskService.taskLists[(NSUInteger) indexPath.row];
  taskCell.textLabel.text = taskList.name;

  NSInteger numberOfActiveTasks = taskList.tasks.count; // active
  taskCell.detailTextLabel.text = [NSString stringWithFormat:@"(%i)", numberOfActiveTasks];

  return taskCell;
}


#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  YMAAddTaskListViewController *showTasksOfTaskList = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskListViewController"];
  //showTasksOfTaskList.listIndex = (NSUInteger) indexPath.section;
//  showTasksOfTaskList.delegate = self;
 // showTasksOfTaskList.task =
      [self.taskService taskFromListAtIndex:(NSUInteger) indexPath.section taskIndex:(NSUInteger) indexPath.row];
  [self showViewController:showTasksOfTaskList sender:nil];
}

- (IBAction)addTapped:(id)sender {
  YMAAddTaskListViewController *addTaskListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskListViewController"];
  addTaskListVC.delegate = self;
  [self showViewController:addTaskListVC sender:nil];
}


@end
