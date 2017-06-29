//
//  YMADateSelectorViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateSelectorViewController.h"
#import "YMADateHelper.h"

@interface YMADateSelectorViewController ()
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(weak, nonatomic) IBOutlet UIDatePicker *datePiker;

@end

@implementation YMADateSelectorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateUi];
}

- (void)updateUi {
    self.dateLabel.text = [YMADateHelper stringFromDate:self.date];
    [self.datePiker setDate:self.date];
}

- (IBAction)datePickerChanged:(id)sender {
    self.date = self.datePiker.date;
    [self updateUi];
}

@end
