//
//  YMATaskModel.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMATaskModel : NSObject

@property (nonatomic, assign) int idTask;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *finishDate;
@property (nonatomic, assign, getter = isTaskFinished)  BOOL taskFinished;

- (instancetype)initWithIdTask:(int)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate;

+ (instancetype)modelWithIdTask:(int)idTask name:(NSString *)name note:(NSString *)note startDate:(NSDate *)startDate;

@end
