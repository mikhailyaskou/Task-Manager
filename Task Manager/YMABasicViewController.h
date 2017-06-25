//
//  YMABasicViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 23.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMATaskService;
@class YMATask;
@class YMATask;

@interface YMABasicViewController : UIViewController

@property(strong, nonatomic) NSMutableArray *tasksForTableView;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

- (YMATask *)taskFromTableViewTasks:(NSIndexPath *)indexPath;

@end
