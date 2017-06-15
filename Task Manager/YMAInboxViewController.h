//
//  YMAInboxViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAAddTaskViewController.h"
@class YMATaskService;

@interface YMAInboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, YMAAddTaskViewControllerDelegate>

@property (nonatomic, strong) YMATaskService *taskService;

@end
