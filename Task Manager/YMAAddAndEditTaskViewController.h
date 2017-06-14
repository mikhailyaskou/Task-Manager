//
//  YMAAddTaskViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//
#import "YMADateSelectorViewController.h"
#import <UIKit/UIKit.h>

@class YMATask;

@interface YMAAddAndEditTaskViewController : UIViewController <YMADateSelectorViewControllerDelegate>

@property (nonatomic, strong) YMATask *task;

@end
