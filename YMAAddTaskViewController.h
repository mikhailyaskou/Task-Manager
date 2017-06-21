//
//  YMAAddTaskViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 14.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMADateSelectorViewController.h"
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
