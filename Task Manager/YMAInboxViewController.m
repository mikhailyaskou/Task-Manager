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
#import "YMADateHelper.h"
#import "YMAConstants.h"

@interface YMAInboxViewController ()

@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property(assign, nonatomic, getter=isAscending) BOOL ascending;

@end

@implementation YMAInboxViewController

#pragma mark - View lifetime

- (void)updateUi {
    [self segmentControllerTapped:self.segmentedControl];
}

- (IBAction)segmentControllerTapped:(UISegmentedControl *)sender {

    if ([YMATaskService.sharedInstance allTasks].count > 0) {

        if (sender.selectedSegmentIndex == 0) {
            //sort array
            NSMutableArray *allTasks = [[YMATaskService.sharedInstance allTasks] mutableCopy];
            NSSortDescriptor
                *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:YMAStartDateFieldName ascending:self.isAscending];
            [allTasks sortUsingDescriptors:@[sortDescriptor]];
            self.tasksForTableView = [NSMutableArray new];
            int section = 0;
            YMATaskList *taskListFirstSection = [YMATaskList new];
            //Adding first section
            taskListFirstSection.name =
                [YMADateHelper stringFromDate:[(YMATask *) allTasks[section] startDate]];
            [self.tasksForTableView addObject:taskListFirstSection];

            for (NSUInteger i = 0; i < allTasks.count - 1; i++) {
                YMATask *firstObject = allTasks[i];
                YMATask *secondObject = allTasks[i + 1];

                NSString *firstDate = [YMADateHelper stringFromDate:firstObject.startDate];
                NSString *secondDate = [YMADateHelper stringFromDate:secondObject.startDate];

                YMATaskList *taskListSection = self.tasksForTableView[section];

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
            YMATaskList *tasks = self.tasksForTableView[section];
            [tasks addTask:allTasks[allTasks.count - 1]];
        } else {
            self.tasksForTableView = [YMATaskService.sharedInstance.taskLists mutableCopy];
            NSSortDescriptor
                *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:YMANameFieldName ascending:self.isAscending];
            [self.tasksForTableView sortUsingDescriptors:@[sortDescriptor]];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Actions

- (IBAction)sortTable:(id)sender {
    self.ascending = !self.ascending;
    [self segmentControllerTapped:self.segmentedControl];
}

@end
