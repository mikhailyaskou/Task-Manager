//
//  YMANotificationHelper.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 08.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YMATask;

@interface YMANotificationHelper : NSObject

+ (void)updateNotificationStateForTask:(YMATask *)task;
+ (void)removeNotificationForTask:(YMATask *)task;

@end
