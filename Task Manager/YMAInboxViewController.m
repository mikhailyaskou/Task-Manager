//
//  YMAInboxViewController.m
//  Task Manager
//
//  Created by Mikhail Yaskou on 03.06.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAAddAndEditTaskViewController.h"
#import "YMAInboxViewController.h"
#import "YMATaskService.h"
#import "YMATask.h"
#import "YMADetailViewController.h"
#import "YMAConstants.h"

static NSString * const YMACellIdentifier = @"YMATaskCell";
static NSString * const YMADetailViewControllerIdentifier = @"detailView";

@interface YMAInboxViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMAInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.taskService = [[YMATaskService alloc] initWithMutableArrayTasks:[NSMutableArray new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskReccived:) name:YMANotificationNameForTaskReceiving object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)taskReccived:(NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    YMATask *task = dict[YMAKeyForTaskInNSNotificationMessage];
    [self.taskService incomingTask:task];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskService.numberOftasks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMACellIdentifier];
    NSUInteger index = [indexPath row];
    cell.textLabel.text = [self.taskService taskByIndex:index].name;
    return cell;
}

#pragma mark - Actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMADetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:YMADetailViewControllerIdentifier];
    detailView.task = [self.taskService taskByIndex:indexPath.row];
    [self showViewController:detailView sender:nil];
}

- (IBAction)addTaped:(id)sender {
    YMAAddAndEditTaskViewController *addViewController = [[YMAAddAndEditTaskViewController alloc]initWithNibName:YMANibNameForAddTaskViewController bundle:nil];
    [self showViewController:addViewController sender:nil];
}

@end
