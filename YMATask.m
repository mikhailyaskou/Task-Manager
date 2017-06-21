//
//  YMATask.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATask.h"

@interface YMATask () <NSCoding>

@end

@implementation YMATask

- (instancetype)initWithIdTask:(NSNumber *)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        self.idTask = idTask;
        self.name = name;
        self.note = note;
        self.startDate = startDate;
    }
    return self;
}

+ (instancetype)taskWithId:(NSNumber *)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    return [[self alloc] initWithIdTask:idTask name:name note:note startDate:startDate];
}

#pragma mark - Coder

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.idTask = [coder decodeObjectForKey:@"self.idTask"];
        self.name = [coder decodeObjectForKey:@"self.name"];
        self.note = [coder decodeObjectForKey:@"self.note"];
        self.startDate = [coder decodeObjectForKey:@"self.startDate"];
        self.finishDate = [coder decodeObjectForKey:@"self.finishDate"];
        self.taskFinished = [coder decodeBoolForKey:@"self.taskFinished"];
        self.remindMeOnADay = [coder decodeBoolForKey:@"self.remindMeOnADay"];
        self.priority = [coder decodeObjectForKey:@"self.priority"];
    }

    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.idTask forKey:@"self.idTask"];
    [coder encodeObject:self.name forKey:@"self.name"];
    [coder encodeObject:self.note forKey:@"self.note"];
    [coder encodeObject:self.startDate forKey:@"self.startDate"];
    [coder encodeObject:self.finishDate forKey:@"self.finishDate"];
    [coder encodeBool:self.taskFinished forKey:@"self.taskFinished"];
    [coder encodeBool:self.remindMeOnADay forKey:@"self.remindMeOnADay"];
    [coder encodeObject:self.priority forKey:@"self.priority"];
}

- (void)finishTask {
    NSDate *currentDate = [NSDate date];
    self.finishDate = currentDate;
    self.taskFinished = YES;
}

@end
