//
//  YMATaskServiceModel.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMATaskModel;

@interface YMATaskServiceModel : NSObject

@property (nonatomic, strong) NSArray *tasks;

- (instancetype)initWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks;
+ (instancetype)modelWithMutableArrayTasks:(NSMutableArray *)mutableArrayTasks;

- (void)addTask:(YMATaskModel *)task;
- (NSInteger)numberOftasks;
- (YMATaskModel *)taskByIndex:(NSInteger)index;
- (void)replaseTaskByIndex:(NSInteger)index :(YMATaskModel *)task;
- (void)update:(NSInteger)index task:(id)task;

@end
