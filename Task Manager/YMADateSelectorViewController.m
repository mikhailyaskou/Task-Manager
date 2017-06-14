//
//  YMADateSelectorViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMADateSelectorViewController.h"

@interface YMADateSelectorViewController ()

@end

@implementation YMADateSelectorViewController

- (IBAction)datePikerChanged:(id)sender {
    [self.delegate dateSelectorViewController:self didSelectedDate:self.datePiker.date];
}

@end
