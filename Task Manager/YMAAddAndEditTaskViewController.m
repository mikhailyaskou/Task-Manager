//
//  YMAAddTaskViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMATask.h"
#import "YMAAddAndEditTaskViewController.h"
#import "YMADateHelper.h"
#import "YMAConstants.h"

static NSString * const YMASaveButtonTitle = @"Save";
static NSString * const YMANibNameDateSelectorViewController = @"YMADateSelectorViewController";

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
    UIBarButtonItem *saveAndPopPreviousScreenButton = [[UIBarButtonItem alloc] initWithTitle:YMASaveButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(saveTask)];
    self.navigationItem.rightBarButtonItem = saveAndPopPreviousScreenButton;
    if (self.task) {
        self.nameField.text = self.task.name;
        self.noteField.text = self.task.note;
        [self setDate:self.task.startDate];
    }
    else {
        NSDate *currentDate = [NSDate date];
        [self setDate:currentDate];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self nameTextValueChanged:nil];
}

- (void)setDate:(NSDate *)date {
    self.startDate = date;
    [self.dateSelectButton setTitle:[YMADateHelper stringFromDate:date] forState:UIControlStateNormal];
}

#pragma marks - Actions

- (IBAction)nameTextValueChanged:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = self.nameField.text.length > 0;
}

- (void)saveTask {
    if (self.task) {
        self.task.name = self.nameField.text;
        self.task.note = self.noteField.text;
        self.task.startDate = self.startDate;
    }
    else {
        NSInteger id = arc4random_uniform(1000);
        self.task = [[YMATask alloc] initWithIdTask:id name:self.nameField.text note:self.noteField.text startDate:self.startDate];
    }
    NSDictionary *dict = @{YMATaskNotificationKey : self.task};
    [[NSNotificationCenter defaultCenter] postNotificationName:YMAReceivedTaskNotificationName object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selctDateTaped:(id)sender {
    YMADateSelectorViewController *dateSelectorView = [[YMADateSelectorViewController alloc]initWithNibName:YMANibNameDateSelectorViewController bundle:nil];
    dateSelectorView.delegate = self;
    [dateSelectorView.datePiker setDate:self.startDate];
    [self showViewController:dateSelectorView sender:nil];
}

#pragma marks - Delegate

- (void)dateSelectorViewController:(id)id didSelectedDate:(NSDate *)date {
    [self setDate:date];
}

@end
