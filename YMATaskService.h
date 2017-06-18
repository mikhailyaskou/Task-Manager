//
//  YMATaskService.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMATaskList;
@class YMATask;

@interface YMATaskService : NSObject
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@property (nonatomic, strong) NSArray *taskLists;

+ (instancetype)sharedInstance;

- (void)addTasks:(YMATaskList *)tasks;
- (YMATaskList *)taskListAtIndex:(NSUInteger)index;
- (YMATask *)taskFromListAtIndex:(NSUInteger)indexOfList taskIndex:(NSUInteger)indexOfTask;
- (void) removeTaskFromListIndex:(NSUInteger)listIndex taskIndex:(NSUInteger)taskIndex;
- (void)filterAllTaskListOnTodayTask;
- (NSArray *)allTasks;
- (YMATaskList *)getAllTasksOnToday;
- (void)removeTaskFromAllList:(YMATask *)task;
- (void)incomingTask:(YMATask *)task intexOfList:(NSUInteger)listIndex;

@end
