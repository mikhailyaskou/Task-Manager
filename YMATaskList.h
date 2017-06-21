//
//  YMATaskList.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

@class YMATask;
#import <Foundation/Foundation.h>

@interface YMATaskList : NSObject
- (instancetype)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@property(nonatomic, assign) NSNumber *idTaskList;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSDate *creationDate;
@property(nonatomic, copy) NSArray *tasks;

- (void)removeTaskFromList:(YMATask *)task;
- (void)addTask:(YMATask *)task;
- (YMATask *)taskAtIndex:(NSUInteger)index;
- (void)removeTask:(NSUInteger *)index;
- (void)incomingTask:(YMATask *)task;
- (void)filterTaskToday;
- (void)insertTask:(YMATask *)task atIndex:(NSUInteger)index;
- (void)sortUsingDescriptors:(NSSortDescriptor *)sortDescriptor;


@end
