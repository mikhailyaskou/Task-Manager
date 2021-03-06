//
//  YMAInboxViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMATaskService;

@interface YMAInboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YMATaskService *taskService;

@end
