//
//  YMADetailViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAAddTaskViewController.h"
@class YMATaskServiceModel;

@interface YMADetailViewController : UIViewController  <YMAAddTaskViewControllerDelegate>

@property (nonatomic, strong) YMATaskServiceModel* tasks;
@property (nonatomic, assign) long index;

@end
