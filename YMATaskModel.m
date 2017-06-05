//
//  YMATaskModel.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskModel.h"

@implementation YMATaskModel

- (instancetype)initWithIdTask:(int)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    self = [super init];
    if (self) {
        self.idTask = idTask;
        self.name = name;
        self.note = note;
        self.startDate = startDate;
    }
    return self;
}

+ (instancetype)modelWithIdTask:(int)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate {
    return [[self alloc] initWithIdTask:idTask name:name note:note startDate:startDate];
}

@end
