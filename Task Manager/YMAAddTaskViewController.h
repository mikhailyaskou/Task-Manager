//
//  YMAAddTaskViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//
#import "YMADateSelectorViewController.h"
#import <UIKit/UIKit.h>

@class YMAAddTaskViewControllerDelegate;
@class YMATaskModel;

@protocol YMAAddTaskViewControllerDelegate <NSObject>

-(void)addTaskToList:(YMATaskModel *)task;

@end

@interface YMAAddTaskViewController : UIViewController <YMADateSelectorViewControllerDelegate>

@property (nonatomic, strong) YMATaskModel *task;
@property (nonatomic, weak) id <YMAAddTaskViewControllerDelegate> delegate;

@end
