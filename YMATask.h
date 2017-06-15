//
//  YMATask.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMATask : NSObject

@property (nonatomic, assign) NSNumber *idTask;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *finishDate;
@property (nonatomic, assign, getter = isTaskFinished)  BOOL taskFinished;
@property (nonatomic, assign, getter = isRemindMeOnADay) BOOL remindMeOnADay;
@property (nonatomic, strong) NSString *priority;

- (instancetype)initWithIdTask:(NSNumber *)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate;
+ (instancetype)taskWithId:(NSNumber *)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate;

- (void)finishTask;

@end
