//
//  YMATaskService.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMATask;

@interface YMATaskService : NSObject

@property (nonatomic, strong) NSArray *tasks;

- (instancetype)initWithTasks:(NSMutableArray *)tasks;
+ (instancetype)taskServiceWithTasks:(NSMutableArray *)tasks;

- (void)addTask:(YMATask *)task;
- (NSInteger)numberOfTasks;
- (YMATask *)taskByIndex:(NSUInteger)index;
- (void)replaceTaskByIndex:(NSUInteger)index task:(YMATask *)task;
- (void)update:(NSUInteger)index task:(id)task;
- (void)incomingTask:(YMATask *)task;
    
@end
