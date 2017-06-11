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

@property (nonatomic, strong) NSMutableArray *mutableArrayTasks;

@end

@implementation YMATaskService

- (instancetype)initWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks {
    self = [super init];
    if (self) {
        self.mutableArrayTasks = mutableArrayTasks;
        YMATask *task = [[YMATask alloc] initWithIdTask:1 name:@"Купи молока" note:@"Купить хорошего молока" startDate:[NSDate date]];
        [_mutableArrayTasks addObject: task];
        task = [[YMATask alloc] initWithIdTask:2 name:@"Sell milk" note:@"sell milk in store" startDate:[NSDate date]];
        [_mutableArrayTasks addObject: task];
        task = [[YMATask alloc] initWithIdTask:3 name:@"buy new staff" note:@"buy new staff" startDate:[NSDate date]];
        [_mutableArrayTasks addObject: task];
        //notification that add task;
    }
    return self;
}

+ (instancetype)taskServiceWithMutableArray:(NSMutableArray *)mutableArrayTasks {
    return [[self alloc] initWithMutableArrayTasks:mutableArrayTasks];
}

//lazy getter
- (NSMutableArray *)mutableArrayTasks {
    if (!_mutableArrayTasks){
        _mutableArrayTasks = [NSMutableArray new];
    }
    return _mutableArrayTasks;
}


- (NSArray *)tasks {
    return _mutableArrayTasks.copy;
}

- (void)setTasks:(NSArray *)tasks {
    _mutableArrayTasks = tasks.mutableCopy;
}

- (void)addTask:(YMATask *)task {
    [self.mutableArrayTasks addObject:task];
}

- (NSInteger)numberOftasks {
    return self.mutableArrayTasks.count;
}

- (YMATask *)taskByIndex:(NSInteger)index {
    return self.mutableArrayTasks[index];
}

- (void)replaseTaskByIndex:(NSInteger)index task:(YMATask *)task{
    self.mutableArrayTasks[index] = task;
}

- (void)update:(NSInteger)index task:(id)task {
    [self.mutableArrayTasks replaceObjectAtIndex:index withObject:task];
}

- (void)incomingTask:(YMATask *)task {
    if(NSNotFound == [self.mutableArrayTasks indexOfObject: task]) {
        //insert new task
        [self addTask:task];
    }
}

@end
