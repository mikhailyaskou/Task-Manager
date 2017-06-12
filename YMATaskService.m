//
//  YMATaskService.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskService.h"
#import "YMATask.h"

@interface YMATaskService()

@property (nonatomic, strong) NSMutableArray *privateTasks;

@end

@implementation YMATaskService

- (instancetype)initWithTasks:(NSMutableArray *)tasks {
    self = [super init];
    if (self) {
        self.privateTasks = tasks;
        YMATask *task = [[YMATask alloc] initWithIdTask:1 name:@"Купи молока" note:@"Купить хорошего молока" startDate:[NSDate date]];
        [_privateTasks addObject: task];
        task = [[YMATask alloc] initWithIdTask:2 name:@"Sell milk" note:@"sell milk in store" startDate:[NSDate date]];
        [_privateTasks addObject: task];
        task = [[YMATask alloc] initWithIdTask:3 name:@"buy new staff" note:@"buy new staff" startDate:[NSDate date]];
        [_privateTasks addObject: task];
        //notification that add task;
    }
    return self;
}

+ (instancetype)taskServiceWithTasks:(NSMutableArray *)tasks {
    return [[self alloc] initWithTasks:tasks];
}

//lazy getter
- (NSMutableArray *)privateTasks {
    if (!_privateTasks){
        _privateTasks = [NSMutableArray new];
    }
    return _privateTasks;
}


- (NSArray *)tasks {
    return _privateTasks.copy;
}

- (void)setTasks:(NSArray *)tasks {
    _privateTasks = tasks.mutableCopy;
}

- (void)addTask:(YMATask *)task {
    [self.privateTasks addObject:task];
}

- (NSInteger)numberOfTasks {
    return self.privateTasks.count;
}

- (YMATask *)taskByIndex:(NSUInteger)index {
    return self.privateTasks[index];
}

- (void)replaceTaskByIndex:(NSUInteger)index task:(YMATask *)task{
    self.privateTasks[index] = task;
}

- (void)update:(NSUInteger)index task:(id)task {
    self.privateTasks[index] = task;
}

- (void)incomingTask:(YMATask *)task {
    if(NSNotFound == [self.privateTasks indexOfObject: task]) {
        //insert new task
        [self addTask:task];
    }
}

@end
