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

@interface YMAToDoListViewController () <YMAAddTaskViewControllerDelegate>

@end

@implementation YMAToDoListViewController

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"YMATaskTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"YMATaskTableViewCell"];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = self.tasks.name;
    [self.tableView reloadData];
}


#pragma mark - Actions


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (IBAction)addTapped:(id)sender {
    YMAAddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskViewController"];
    addTaskVC.delegate = self;
    [self showViewController:addTaskVC sender:nil];
}

#pragma mark - Delegate

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index {
    [self.tasks incomingTask:task];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMATaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMATaskTableViewCell"];
    YMATask *task = self.tasks.tasks[(NSUInteger) indexPath.row];
    cell.nameLabel.text = task.name;
    cell.noteLabel.text = task.note;
    cell.dateLabel.text = [YMADateHelper stringFromDate:task.startDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAddTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YMAAddTaskViewController"];
    editTaskVC.listIndex = (NSUInteger) indexPath.section;
    editTaskVC.delegate = self;
    editTaskVC.task = self.tasks.tasks[(NSUInteger) indexPath.row];
    [self showViewController:editTaskVC sender:nil];
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get task
    YMATask *task = self.tasks.tasks[(NSUInteger) indexPath.row];
    UITableViewRowAction *doneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Done" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

      [task finishTask];
      [self.tableView setEditing:NO];
    }];
    //delete tapped
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
      //alert
      UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Do you want to remove item?" message:nil preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
      [alertViewController addAction:cancelAction];
      UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tasks removeTaskFromList:task];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      }];
      [alertViewController addAction:deleteAction];

      [self presentViewController:alertViewController animated:YES completion:nil];
    }];
    if (task.isTaskFinished) {
        return @[deleteAction];
    }
    else {
        return @[deleteAction, doneAction];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
