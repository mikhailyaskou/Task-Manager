//
//  YMATaskServiceModel.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskServiceModel.h"
#import "YMATaskModel.h"

@interface YMATaskServiceModel()

@property (nonatomic, strong) NSMutableArray *mutableArrayTasks;

@end

@implementation YMATaskServiceModel

- (instancetype)initWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks {
    self = [super init];
    if (self) {
        self.mutableArrayTasks = mutableArrayTasks;
    }
    return self;
}

+ (instancetype)modelWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks {
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

- (void)addTask:(YMATaskModel *)task {
    [self.mutableArrayTasks addObject:task];
}

- (NSInteger)numberOftasks {
    return self.mutableArrayTasks.count;
}

- (YMATaskModel *)taskByIndex:(long)index {
    return self.mutableArrayTasks[index];
}

- (void)replaseTaskByIndex:(long)index :(YMATaskModel *)task{
    self.mutableArrayTasks[index] = task;
}

@end
