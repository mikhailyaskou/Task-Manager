//
//  YMAAddTaskViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//
#import "YMADateSelectorViewController.h"
#import <UIKit/UIKit.h>

@class YMATaskModel;

@interface YMAAddAndEditTaskViewController : UIViewController <YMADateSelectorViewControllerDelegate>

@property (nonatomic, strong) YMATaskModel *task;
//if this is new task his index is < 0; (-1)
@property (nonatomic, assign) NSInteger indexOfTaskInList;

-(NSDate*)startDate;

@end
