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
#import "YMALocalizedConstants.h"
#import "YMAConstants.h"

@interface YMAAddTaskViewController () <UIActionSheetDelegate>

@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UISwitch *remindMeSwitch;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property(weak, nonatomic) IBOutlet UITextView *noteField;
@property(strong, nonatomic) NSDate *date;
@property(weak, nonatomic) IBOutlet UITableViewCell *priorityCell;

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
    if (_task) {
        self.title = YMATitleEditItem;
        [self updateUI];
    } else {
        self.title = YMATitleAddItem;
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

- (IBAction)unwindToEditViewController:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.identifier isEqualToString:YMADateSelectorDoneTappedIdentifier]) {
        YMADateSelectorViewController *dateSelectorViewController = unwindSegue.sourceViewController;
        [self setDate:dateSelectorViewController.date];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([[segue identifier] isEqualToString:YMADateSelectorTappedSegueIdentifier]) {
        YMADateSelectorViewController *dateSelectorViewController = [segue destinationViewController];
        dateSelectorViewController.date = self.date;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *priorities=@[YMAPriorityNone, YMAPriorityLow, YMAPriorityMedium,YMAPriorityHigh];
    UITableViewCell *theCellClicked = [self.tableView cellForRowAtIndexPath:indexPath];
    if (theCellClicked == self.priorityCell) {
        UIAlertController *actionSheet =
            [UIAlertController alertControllerWithTitle:YMATitleSelectPriority message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //add priorities
        for (NSString *priority in priorities) {
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:priority style:UIAlertActionStyleDefault handler:^(
                UIAlertAction *alertAction) {
              self.priorityLabel.text = alertAction.title;
              [self dismissViewControllerAnimated:YES completion:^{
              }];
            }];
            [actionSheet addAction:alertAction];
        }
        //add chancel
        [actionSheet addAction:[UIAlertAction actionWithTitle:YMATitleChancel style:UIAlertActionStyleCancel handler:^(
            UIAlertAction *action) {
          [self dismissViewControllerAnimated:YES completion:^{
          }];
        }]];

        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    //deselect row after selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
