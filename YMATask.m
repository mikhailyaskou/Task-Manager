//
//  YMATask.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATask.h"

@implementation YMATask

- (instancetype)initWithIdTask:(NSInteger)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        self.idTask = idTask;
        self.name = name;
        self.note = note;
        self.startDate = startDate;
    }
    return self;
}

+ (instancetype)taskWithId:(NSInteger)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    return [[self alloc] initWithIdTask:idTask name:name note:note startDate:startDate];
}

- (void)finishTask {
    NSDate *currentDate = [NSDate date];
    self.finishDate = currentDate;
    self.taskFinished = YES;
}

@end
