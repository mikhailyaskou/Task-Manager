//
//  YMADateSelectorViewController.h
//  Task Manager
//
//  Created by Mikhail Yaskou on 04.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YMADateSelectorViewController;

@protocol YMADateSelectorViewControllerDelegate <NSObject>

- (void)dateSelectorViewController:(id)Sender didSelectedDate:(NSDate *) date;

@end

#import <UIKit/UIKit.h>

@interface YMADateSelectorViewController : UIViewController

@property (nonatomic, weak) id <YMADateSelectorViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePiker;

@end
