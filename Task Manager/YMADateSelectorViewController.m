//
//  YMADateSelectorViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateSelectorViewController.h"

@interface YMADateSelectorViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePiker;

@end

@implementation YMADateSelectorViewController

- (IBAction)datePikerChanged:(id)sender {
    [self.delegate setDate:self.datePiker.date];
}


@end
