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

- (instancetype)initWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks;
+ (instancetype)taskServiceWithMutableArray:(NSMutableArray *)mutableArrayTasks;

- (void)addTask:(YMATask *)task;
- (NSInteger)numberOftasks;
- (YMATask *)taskByIndex:(NSInteger)index;
- (void)replaseTaskByIndex:(NSInteger)index task:(YMATask *)task;
- (void)update:(NSInteger)index task:(id)task;
- (void)incomingTask:(YMATask *)task;
    
@end
