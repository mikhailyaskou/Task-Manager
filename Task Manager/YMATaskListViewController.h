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

static NSString * const YMAAddProjectCellIdentifier = @"YMAAddProjectCellIdentifier";
static NSString * const YMATaskListCellIdetifier = @"YMATaskListCell";
static NSString * const YMAShowProjectTasksIdentifier = @"ShowProjectTasksIdentifier";
static NSString * const YMADoneTappedUnwindSegueIdentifier = @"DoneTappedUnwindSegueIdentifier";
static const NSInteger YMANumberOfSectionsForProjectView = 2;
static const NSInteger YMAIndexSectionForAddRow = 1;
static const NSInteger YMAIndexRowForAddRow = 0;

@interface YMATaskListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
