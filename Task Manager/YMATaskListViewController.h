//
//  YMATaskListViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAAddTaskViewController.h"
#import "YMAAddTaskListViewController.h"

static NSString *const YMAAddProjectCellIdentifier = @"YMAAddProjectCellIdentifier";
static NSString *const YMATaskListCellIdetifier = @"YMATaskListCell";
static NSString *const ShowProjectTasksIdentifier = @"ShowProjectTasksIdentifier";
static NSString *const DoneTappedUnwindSegueIdentifier = @"DoneTappedUnwindSegueIdentifier";
static const NSInteger numberOfSections = 2;
static const NSInteger indexSectionForAddRow = 1;
static const NSInteger indexRowForAddRow = 0;

@interface YMATaskListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
