//
//  YMAAddTaskListViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 14.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddTaskListViewController.h"
#import "YMATaskList.h"

@interface YMAAddTaskListViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (nonatomic, strong) YMATaskList *taskList;

@end

@implementation YMAAddTaskListViewController

- (YMATaskList *)taskList {
    if (!_taskList){
        _taskList = [YMATaskList new];
        _taskList.idTaskList = @(arc4random_uniform(100000));
    }
    return  _taskList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)]];
    self.title = @"Add Project";

}

#pragma mark - Actions

- (void)doneButtonTapped {
    self.taskList.name = _nameLabel.text;
    [self.delegate incomingTaskList:self taskList:self.taskList];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
