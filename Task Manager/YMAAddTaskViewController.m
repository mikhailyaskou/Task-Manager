//
//  YMAAddTaskViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATaskModel.h"
#import "YMAAddTaskViewController.h"

@interface YMAAddTaskViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *dateField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (weak, nonatomic) NSDate *startDate;

@end

@implementation YMAAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //save button on nav bar
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveTask)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    //set tooday date;
    [self setDate: [NSDate date]];
    
    if (self.task) {
        self.nameField.text = self.task.name;
        self.noteField.text = self.task.note;
        [self setDate:self.task.startDate];
    }
}

#pragma marks - Actions

- (void)saveTask{
    self.task = [[YMATaskModel alloc] initWithIdTask:2 name:self.nameField.text note:self.noteField.text startDate: self.startDate];
    [self.delegate addTaskToList:self.task];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)selctDateTaped:(id)sender {
    YMADateSelectorViewController *dateSelectorView = [[YMADateSelectorViewController alloc]initWithNibName:@"YMADateSelectorViewController" bundle:nil];
    dateSelectorView.delegate = self;
    [self showViewController:dateSelectorView sender:nil];
}

#pragma marks - Delegate

- (void)setDate:(id)date {
    self.startDate = date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"mm:HH / dd.MM.yyyy"];
    self.dateField.text = [formatter stringFromDate:self.startDate];
}

@end
