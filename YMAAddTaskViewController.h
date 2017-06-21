//
//  YMAAddTaskViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 14.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMADateSelectorViewController.h"

static NSString *const DateSelectorDoneTappedIdentifier = @"DateSelectorDoneTappedIdentifier";
static NSString *const DateSelectorTappedSegueIdentefier = @"DateSelectorTappedSegueIdentefier";
static NSString *const PriorityCancel = @"Cancel";
static NSString *const PriorityNone = @"None";
static NSString *const PriorityLow = @"Low";
static NSString *const PriorityMedium = @"Medium";
static NSString *const PriorityHigh = @"High";

@class YMATask;
@class YMAAddTaskViewController;

@protocol YMAAddTaskViewControllerDelegate <NSObject>

- (void)incomingTask:(id)Sender task:(YMATask *)task listIndex:(NSUInteger)index;

@end

@interface YMAAddTaskViewController : UITableViewController

@property(nonatomic, weak) id <YMAAddTaskViewControllerDelegate> delegate;
@property(nonatomic, strong) YMATask *task;
@property(assign, nonatomic) NSUInteger listIndex;


@end
