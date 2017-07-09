//
//  YMANotificationHelper.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 08.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMANotificationHelper.h"
#import "YMATask.h"
#import "YMADateHelper.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@implementation YMANotificationHelper

+ (void)updateNotificationStateForTask:(YMATask *)task {
    //remove notification (if exist or not doesn't matter)
    [self removeNotificationForTask:task];
    //create it again with new date if flag is on
    if (task.isRemindMeOnADay) {
        //create NotificationContent
        UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
        notificationContent.title = [NSString localizedUserNotificationStringForKey:task.name arguments:nil];
        notificationContent.body = [NSString localizedUserNotificationStringForKey:task.note arguments:nil];
        notificationContent.sound = [UNNotificationSound defaultSound];
        notificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        //create trigger
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
            triggerWithDateMatchingComponents:[YMADateHelper dateComponentsFromDate:task.startDate] repeats:NO];
        // create the request object.
        UNNotificationRequest *request = [UNNotificationRequest
            requestWithIdentifier:[task.idTask stringValue] content:notificationContent trigger:trigger];
        //get center
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //add notification
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
          if (error != nil) {
              NSLog(@"%@", error.localizedDescription);
          }
        }];
    }
}

+ (void)removeNotificationForTask:(YMATask *)task {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    NSArray *notificationId = @[[task.idTask stringValue]];
    [center removePendingNotificationRequestsWithIdentifiers:notificationId];
}

@end
