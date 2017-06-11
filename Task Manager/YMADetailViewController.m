//
//  YMADetailViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADetailViewController.h"
#import "YMAAddAndEditTaskViewController.h"
#import "YMATask.h"
#import "YMATaskService.h"
#import "YMADateHelper.h"

@interface YMADetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation YMADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self taskFinisedOrNotCheckAndRedrowInterface];
    [self fillInterfaceFromTask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskReccived:) name:@"recciveTask" object:nil];
}

-(void)taskReccived:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    NSInteger indexOfTask = [[dict valueForKey:@"indexOfTask"] integerValue];
    YMATask *task = [dict valueForKey:@"task"];
    if (indexOfTask > 0) {
        if (task != nil) {
            
            self.task = task;
            [self fillInterfaceFromTask];
        }
    }
}

- (void)taskFinisedOrNotCheckAndRedrowInterface {
    self.navigationItem.rightBarButtonItem.enabled = (!self.task.isTaskFinished);
    self.doneButton.enabled = (!self.task.isTaskFinished);
}

- (void)fillInterfaceFromTask {
    self.dateLabel.text = [YMADateHelper stringFromDate:self.task.startDate];
    self.nameLabel.text = self.task.name;
    self.noteLabel.text = self.task.note;
}

#pragma marks - Actions

- (IBAction)editTaskTapped:(id)sender {
    YMAAddAndEditTaskViewController *editView = [[YMAAddAndEditTaskViewController alloc]initWithNibName:@"YMAAddTaskViewController" bundle:nil];
    editView.task = self.task;
    editView.indexOfTaskInList = self.indexOfTaskInList;
    [self showViewController:editView sender:nil];
}

- (IBAction)doneTapped:(id)sender {
    [self.task finishDate];
    self.task.taskFinished = YES;
    NSNumber *indexOfTask = [NSNumber numberWithInteger:self.indexOfTaskInList];
    NSDictionary *dict = @{ @"task"  : self.task,
                            @"indexOfTask" : indexOfTask
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recciveTask" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
