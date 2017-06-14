//
//  YMADetailViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAAddAndEditTaskViewController.h"
@class YMATaskService;

@interface YMADetailViewController : UIViewController 

@property (nonatomic, strong) YMATask *task;

@end
