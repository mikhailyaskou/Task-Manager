//
//  YMAAddTaskViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskModel.h"
#import "YMAAddAndEditTaskViewController.h"

@interface YMAAddAndEditTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (nonatomic, strong) NSDate *startDate;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectButton;

@end

@implementation YMAAddAndEditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //save button on nav bar
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveTask)];
    self.navigationItem.rightBarButtonItem = saveButton;
    //set tooday date;
    if (self.task) {
        //fill intetrface if tesk reccived from table
        self.nameField.text = self.task.name;
        self.noteField.text = self.task.note;
        [self setDate:self.task.startDate];
    }else{
        NSDate *currentDate = [NSDate date];
        [self setDate:currentDate];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self nameTextValueChanged:nil];
}

#pragma marks - Actions

- (IBAction)nameTextValueChanged:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = self.nameField.text.length > 0 ? YES : NO;
}

- (void)saveTask{
    self.task = [[YMATaskModel alloc] initWithIdTask:2 name:self.nameField.text note:self.noteField.text startDate: self.startDate];
    NSNumber *indexOfTask = [NSNumber numberWithInteger:self.indexOfTaskInList];
    NSDictionary *dict = @{ @"task"  : self.task,
                            @"indexOfTask" : indexOfTask
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recciveTask" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selctDateTaped:(id)sender {
    YMADateSelectorViewController *dateSelectorView = [[YMADateSelectorViewController alloc]initWithNibName:@"YMADateSelectorViewController" bundle:nil];
    dateSelectorView.delegate = self;
    dateSelectorView.datePiker.date = self.startDate;
    [self showViewController:dateSelectorView sender:nil];
}

#pragma marks - Delegate

- (void)setDate:(NSDate *)date {
    self.startDate = date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"mm:HH / dd.MM.yyyy"];
    //self.dateField.text = [formatter stringFromDate:date];
    [self.dateSelectButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    
}

@end
