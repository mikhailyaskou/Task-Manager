//
//  YMAToDoListViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 17.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMATaskList;

@interface YMAToDoListViewController : UITableViewController

@property(nonatomic, strong) YMATaskList *tasks;

@end
