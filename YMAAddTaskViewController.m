//
//  YMAAddTaskViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 14.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddTaskViewController.h"
#import "YMATask.h"
#import "YMADateHelper.h"

@interface YMAAddTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISwitch *remindMeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (strong, nonatomic) NSDate *date;


@end

@implementation YMAAddTaskViewController

- (void)setDate:(NSDate *)date {
    _date = date;
    self.dateLabel.text = [YMADateHelper stringFromDate:date];
}

- (YMATask *)task {
    if (!_task) {
        _task = [YMATask new];
        _task.idTask = @(arc4random_uniform(100000));
    }
    return _task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)]];
    // update UI
    if (_task){
        self.title = @"Edit Item";
        [self updateUI];
    }
    else {
        self.title = @"Add Item";
        self.date = [NSDate date];
    }
}

- (void)updateUI {
    self.nameField.text = self.task.name;
    [self.remindMeSwitch setOn:self.task.remindMeOnADay animated:NO];
    self.date = self.task.startDate;
    self.priorityLabel.text = self.task.priority;
    self.noteField.text = self.task.note;
}

#pragma mark - Actions

- (void)doneButtonTapped {
    self.task.name = self.nameField.text;
    self.task.remindMeOnADay = self.remindMeSwitch.isOn;
    self.task.startDate = self.date;
    self.task.priority = self.priorityLabel.text;
    self.task.note = self.noteField.text;
    [self.delegate incomingTask:self task:self.task listIndex:self.listIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

- (void)dateSelectorViewController:(id)Sender didSelectedDate:(NSDate *)date {
    self.date = date;
}

@end
