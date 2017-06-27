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
#import "YMALocalizedConstants.h"

@interface YMATaskService () <NSCoding>

@property(nonatomic, strong) NSMutableArray *privateTaskLists;

@end

@implementation YMATaskService

+ (instancetype)sharedInstance {
    static YMATaskService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [YMATaskService new];
      [sharedInstance loadData];
      //to prevent crash if "[NSKeyedUnarchiver initForReadingWithData:]: data is NULL"
      if (sharedInstance.privateTaskLists.count == 0) {
          YMATaskList *tasks = [YMATaskList new];
          tasks.name = titleInbox;
          [sharedInstance.privateTaskLists addObject:tasks];
      }
    });
    return sharedInstance;
}

//lazy getter
- (NSMutableArray *)privateTaskLists {
    if (!_privateTaskLists) {
        _privateTaskLists = [NSMutableArray new];
    }
    return _privateTaskLists;
}

- (void)setTaskLists:(NSArray *)taskLists {
    _privateTaskLists = [taskLists mutableCopy];
}

- (NSArray *)taskLists {
    return [_privateTaskLists copy];
}

#pragma mark - Coder

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.privateTaskLists = [coder decodeObjectForKey:@"self.privateTaskLists"];
    }

    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.privateTaskLists forKey:@"self.privateTaskLists"];
}

- (void)saveTasks {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_privateTaskLists];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"self.privateTaskLists"];
}

- (void)loadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"self.privateTaskLists"];
    _privateTaskLists = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - List

- (void)addTasks:(YMATaskList *)tasks {
    [self.privateTaskLists addObject:tasks];
    [self saveTasks];
}

- (void)removeTasks:(YMATaskList *)tasks {
    [self.privateTaskLists removeObject:tasks];
    [self saveTasks];
}

- (YMATaskList *)taskListAtIndex:(NSUInteger)index {
    return self.privateTaskLists[index];
}

#pragma mark - Task

- (void)incomingTask:(YMATask *)task intexOfList:(NSUInteger)listIndex {
    YMATaskList *tasks = self.privateTaskLists[listIndex];
    [tasks incomingTask:task];
    [self saveTasks];
}

- (YMATaskList *)getAllTasksOnToday {
    YMATaskList *tasks = [YMATaskList new];
    tasks.tasks = [self allTasks];
    [tasks filterTaskToday];
    return tasks;
}

- (NSArray *)allTasks {
    return [self.privateTaskLists valueForKeyPath:@"@unionOfArrays.tasks"];
}

- (void)removeTaskFromListIndex:(NSUInteger)listIndex taskIndex:(NSUInteger)taskIndex {
    YMATaskList *taskList = [self taskListAtIndex:listIndex];
    [taskList removeTask:(NSUInteger *) taskIndex];
    [self saveTasks];
}

- (void)removeTaskFromAllList:(YMATask *)task {
    for (NSUInteger i = 0; i < [self.privateTaskLists count]; ++i) {
        YMATaskList *taskList = self.privateTaskLists[i];
        [taskList removeTaskFromList:task];
        [self saveTasks];
    }
}

@end
