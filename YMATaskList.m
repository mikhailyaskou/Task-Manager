//
//  YMATaskList.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskList.h"
#import "YMATask.h"

@interface YMATaskList () <NSCoding>

@property(nonatomic, strong) NSMutableArray *privateTasks;

@end

@implementation YMATaskList
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.idTaskList = [coder decodeObjectForKey:@"self.idTaskList"];
        self.name = [coder decodeObjectForKey:@"self.name"];
        self.creationDate = [coder decodeObjectForKey:@"self.creationDate"];
        self.privateTasks = [coder decodeObjectForKey:@"self.privateTasks"];
    }

    return self;
}

#pragma mark  - Coder

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.idTaskList forKey:@"self.idTaskList"];
    [coder encodeObject:self.name forKey:@"self.name"];
    [coder encodeObject:self.creationDate forKey:@"self.creationDate"];
    [coder encodeObject:self.privateTasks forKey:@"self.privateTasks"];
}

- (instancetype)initWithIdTaskList:(NSNumber *)idTaskList name:(NSString *)name creationDate:(NSDate *)creationDate tasks:(NSArray *)tasks {
    self = [super init];
    if (self) {
        _idTaskList = idTaskList;
        _name = name;
        _creationDate = creationDate;
        _privateTasks = [tasks mutableCopy];
    }

    return self;
}

+ (instancetype)listWithIdTaskList:(NSNumber *)idTaskList name:(NSString *)name creationDate:(NSDate *)creationDate tasks:(NSArray *)tasks {
    return [[self alloc] initWithIdTaskList:idTaskList name:name creationDate:creationDate tasks:tasks];
}

//lazy getter
- (NSMutableArray *)privateTasks {
    if (!_privateTasks) {
        _privateTasks = [NSMutableArray new];
    }
    return _privateTasks;
}

- (void)setTasks:(NSArray *)tasks {
    _privateTasks = [tasks mutableCopy];
}

- (NSArray *)tasks {
    return [_privateTasks copy];
}

- (void)incomingTask:(YMATask *)task {
    if (NSNotFound == [self.privateTasks indexOfObject:task]) {
        //add new task
        [self addTask:task];
    }
}

- (void)addTask:(YMATask *)task {
    [self.privateTasks addObject:task];
}

- (YMATask *)taskAtIndex:(NSUInteger)index {
    return self.privateTasks[index];
}

- (void)removeTask:(NSUInteger *)index {
    [self.privateTasks removeObjectAtIndex:(NSUInteger) index];
}

- (void)removeTaskFromList:(YMATask *)task {
    if ([self.privateTasks containsObject:task]) {
        [self.privateTasks removeObject:task];
    }
}

- (void)insertTask:(YMATask *)task atIndex:(NSUInteger)index {
    [self.privateTasks insertObject:task atIndex:index];
}

- (void)filterTaskToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:now options:0];
    NSDate *endDate = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:now options:0];
    NSPredicate
        *predicate = [NSPredicate predicateWithFormat:@"(startDate >= %@) AND (startDate <= %@)", startDate, endDate];
    [self.privateTasks filterUsingPredicate:predicate];
}
@end
