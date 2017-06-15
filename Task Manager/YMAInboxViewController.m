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

static NSString * const YMACellIdentifier = @"YMATaskCell";
static NSString * const YMADetailViewControllerIdentifier = @"detailView";

@interface YMAInboxViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMAInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskService = [YMATaskService sharedInstance];
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"YMATaskTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"YMATaskTableViewCell"];
    
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate

//delete row
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      [self.taskService removeTaskFromListIndex:(NSUInteger) indexPath.section taskIndex:(NSUInteger) indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}*/

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

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewRowAction *doneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Done" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    // обработка
  }];
  UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    //alert
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Do you want to remove item?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      YMATaskList *taskList = self.taskService.taskLists[indexPath.section];
      YMATask *task = taskList.tasks[indexPath.row];
      [taskList removeTaskFromList:task];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

    [alertViewController addAction:deleteAction];

    [self presentViewController:alertViewController animated:YES completion:nil];
  }];

  return @[deleteAction, doneAction];
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
