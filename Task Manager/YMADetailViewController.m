//
//  YMADetailViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 05.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADetailViewController.h"
#import "YMAAddTaskViewController.h"
#import "YMATaskModel.h"
#import "YMATaskServiceModel.h"

@interface YMADetailViewController ()
@property (nonatomic, strong) YMATaskModel *task;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;

@end

@implementation YMADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.task = self.tasks.tasks[self.index];
    [self fillInterfaceFromTask];
}

-(void)fillInterfaceFromTask{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"mm:HH / dd.MM.yyyy"];
    self.dateLabel.text = [formatter stringFromDate:self.task.startDate];
    self.nameLabel.text = self.task.name;
    self.noteLabel.text = self.task.note;
}

#pragma marks - Actions

- (IBAction)editTaskTapped:(id)sender {
    YMAAddTaskViewController *addView = [[YMAAddTaskViewController alloc]initWithNibName:@"YMAAddTaskViewController" bundle:nil];
    addView.delegate = self;
    addView.task = self.task;
    [self showViewController:addView sender:nil];
}

- (IBAction)doneTapped:(id)sender {
    self.task.finishDate = [NSDate date];
    self.task.taskFinished = YES;
    [self addTaskToList:self.task];
}

#pragma mark - Delegate

-(void)addTaskToList:(YMATaskModel *)task{
    self.task = task;
    [self.tasks replaseTaskByIndex: self.index :self.task];
    [self fillInterfaceFromTask];
    
}


@end
