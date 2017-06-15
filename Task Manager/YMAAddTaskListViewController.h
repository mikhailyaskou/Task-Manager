//
//  YMAAddTaskListViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 14.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMATaskList;

@protocol YMAAddTaskListViewControllerDelegate <NSObject>

- (void)incomingTaskList:(id)Sender taskList:(YMATaskList *)taskList;

@end

@interface YMAAddTaskListViewController : UITableViewController

@property (nonatomic, weak) id <YMAAddTaskListViewControllerDelegate> delegate;

@end
