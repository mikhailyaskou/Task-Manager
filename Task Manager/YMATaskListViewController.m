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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.taskService.taskLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskListCell"];
  YMATaskList *taskList = self.taskService.taskLists[(NSUInteger) indexPath.row];
  taskCell.textLabel.text = taskList.name;
  NSInteger numberOfActiveTasks = taskList.tasks.count; // active
  taskCell.detailTextLabel.text = [NSString stringWithFormat:@"(%li)", (long)numberOfActiveTasks];
  return taskCell;
}


#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString:@"ShowProjectTasksIdentifier"]) {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    YMAToDoListViewController *toDoListViewController = [segue destinationViewController];
   toDoListViewController.tasks = self.taskService.taskLists[(NSUInteger) indexPath.row];

  }
}


- (IBAction)unwindToEditViewController:(UIStoryboardSegue *)unwindSegue {
  if ([unwindSegue.identifier isEqualToString:@"DoneTappedUnwindSegueIdentifier"]) {
    YMAAddTaskListViewController *taskListViewController = [unwindSegue sourceViewController];
    YMATaskList *newTaskList = [YMATaskList new];
    newTaskList.idTaskList = @(arc4random_uniform(100000));
    newTaskList.name = taskListViewController.projectNameLabel.text;
    [self.taskService addTasks:newTaskList];
  }
}

@end
