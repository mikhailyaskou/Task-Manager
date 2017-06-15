//
//  YMATaskService.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskService.h"
#import "YMATask.h"
#import "YMATaskList.h"
#import "YMADateHelper.h"

@interface YMATaskService()

@property (nonatomic, strong) NSMutableArray *privateTaskLists;

@end

@implementation YMATaskService

+ (instancetype)sharedInstance {
    static YMATaskService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YMATaskService alloc] init];
        
        NSDate *notToday = [YMADateHelper dateFromString:@"30:23/10.02.2016"];
        
        YMATask *task = [[YMATask alloc] initWithIdTask:@1 name:@"Купи молока" note:@"Купить хорошего молока" startDate:[NSDate date]];
        YMATask *task1 = [[YMATask alloc] initWithIdTask:@2 name:@"Sell milk" note:@"sell milk in store" startDate:[NSDate date]];
        YMATask *task2 = [[YMATask alloc] initWithIdTask:@3 name:@"buy new home 3" note:@"buy new home 3" startDate:notToday];
        YMATask *task3 = [[YMATask alloc] initWithIdTask:@4 name:@"buy new home 4" note:@"buy new home 4" startDate:[NSDate date]];
        YMATask *task4 = [[YMATask alloc] initWithIdTask:@5 name:@"buy new work 5" note:@"buy new work 5" startDate:notToday];
        YMATask *task5 = [[YMATask alloc] initWithIdTask:@6 name:@"buy new work 6" note:@"buy new work 6" startDate:[NSDate date]];
        [task5 finishTask];
        YMATask *task6 = [[YMATask alloc] initWithIdTask:@7 name:@"buy new work 7" note:@"buy new work 7" startDate:notToday];
        
        YMATaskList *taskListInbox =
        [[YMATaskList alloc] initWithIdTaskList:@0 name:@"Inbox" creationDate:[NSDate date] tasks:[NSArray new]];
        [taskListInbox addTask:task];
        [taskListInbox addTask:task1];
        [taskListInbox addTask:task2];
        [taskListInbox addTask:task3];
        [taskListInbox addTask:task4];
        [taskListInbox addTask:task5];
        [taskListInbox addTask:task6];
        
        YMATaskList *taskListHome =
        [[YMATaskList alloc] initWithIdTaskList:@1 name:@"Home" creationDate:[NSDate date] tasks:[NSArray new]];
        [taskListHome addTask:task3];
        [taskListHome addTask:task4];
        [taskListHome addTask:task5];
        
        YMATaskList *taskListWork =
        [[YMATaskList alloc] initWithIdTaskList:@2 name:@"Work" creationDate:[NSDate date] tasks:[NSArray new]];
        [taskListWork addTask:task4];
        [taskListWork addTask:task5];
        [taskListWork addTask:task6];
        
        
        [sharedInstance addTasks:taskListInbox];
        [sharedInstance addTasks:taskListHome];
        [sharedInstance addTasks:taskListWork];
    });
    return sharedInstance;
}

//lazy getter
- (NSMutableArray *)prvateTaskLists {
    if (!_privateTaskLists){
        _privateTaskLists = [NSMutableArray new];
    }
    return _privateTaskLists;
}

-(void)setTaskLists:(NSArray *)taskLists {
    _privateTaskLists = [taskLists mutableCopy];
}

-(NSArray *)taskLists {
    return [_privateTaskLists copy];
}

- (void)addTasks:(YMATaskList *)tasks {
    [self.prvateTaskLists addObject:tasks];
}

- (YMATaskList *)taskListAtIndex:(NSUInteger)index {
    return self.privateTaskLists[index];
}

- (YMATask *)taskFromListAtIndex:(NSUInteger)indexOfList taskIndex:(NSUInteger)indexOfTask {
    YMATaskList *tasks = [self taskListAtIndex:indexOfList];
    return [tasks taskAtIndex:indexOfTask];
}

- (void) removeTaskFromListIndex:(NSUInteger)listIndex taskIndex:(NSUInteger)taskIndex {
    YMATaskList *taskList = [self taskListAtIndex:listIndex];
    [taskList removeTask:(NSUInteger *) taskIndex];
}

- (void)filterAllTaskListOnTodayTask {
    for (NSUInteger i = 0; i < [self.privateTaskLists count]; ++i) {
        [self.privateTaskLists[i] filterTaskToday];
    }
}

- (NSArray *)allTasks {
    return [self.privateTaskLists valueForKeyPath:@"@unionOfArrays.tasks"];
}

@end
