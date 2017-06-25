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

@interface YMATodayViewController ()
@property(strong, nonatomic) YMATaskList *allTasks;

@end

@implementation YMATodayViewController

#pragma mark - View lifetime

- (void)updateUi {
    //get all task
    self.allTasks = [YMATaskService.sharedInstance getAllTasksOnToday];
    //tasks that will be displayed (two group - finished and not)
    self.tasksForTableView = [NSMutableArray new];
    //list with finished task
    YMATaskList *finishedTasks = [YMATaskList new];
    finishedTasks.name = @"Completed";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.taskFinished == YES"];
    finishedTasks.tasks = [NSArray arrayWithArray:[self.allTasks.tasks filteredArrayUsingPredicate:predicate]];
    //list with not finished task
    YMATaskList *notFinishedTasks = [YMATaskList new];
    predicate = [NSPredicate predicateWithFormat:@"self.taskFinished == NO"];
    notFinishedTasks.tasks = [NSArray arrayWithArray:[self.allTasks.tasks filteredArrayUsingPredicate:predicate]];
    //add in displayed array
    [self.tasksForTableView addObject:notFinishedTasks];
    [self.tasksForTableView addObject:finishedTasks];
    [self.tableView reloadData];
}

@end
